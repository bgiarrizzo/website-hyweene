import Foundation

#if canImport(Dispatch)
    import Dispatch
#endif
#if canImport(Network)
    import Network
#endif
#if canImport(Darwin)
    import Darwin
#elseif canImport(Glibc)
    import Glibc
#endif

/// Minimal static HTTP server used by `hyweene dev`.
public final class LocalHTTPServer {
    private let host: String
    private let port: Int
    private let rootPath: String

    #if canImport(Network)
        private var listener: NWListener?
    #else
        private var fallbackSocketFD: Int32 = -1
        private var fallbackQueue: DispatchQueue?
    #endif

    /// Create a local static HTTP server.
    /// - Parameters:
    ///   - host: Bind host, for example `0.0.0.0`.
    ///   - port: Bind port in the range 1...65535.
    ///   - rootPath: Root folder to serve.
    public init(host: String, port: Int, rootPath: String) {
        self.host = host
        self.port = port
        self.rootPath = rootPath
    }

    /// Start listening for HTTP requests.
    public func start() throws {
        #if canImport(Network)
            guard let nwPort = NWEndpoint.Port(rawValue: UInt16(port)) else {
                throw NSError(
                    domain: "LocalHTTPServer", code: 1,
                    userInfo: [
                        NSLocalizedDescriptionKey: "Invalid port: \(port)"
                    ])
            }

            let parameters = NWParameters.tcp
            let listener = try NWListener(using: parameters, on: nwPort)
            self.listener = listener

            let rootPath = self.rootPath

            listener.newConnectionHandler = { connection in
                LocalHTTPServer.handle(connection: connection, rootPath: rootPath)
            }

            listener.stateUpdateHandler = { [host, port] state in
                switch state {
                case .ready:
                    print("🌐 Dev server listening on http://\(host):\(port)")
                case .failed(let error):
                    print("❌ Dev server error: \(error)")
                default:
                    break
                }
            }

            listener.start(queue: .global(qos: .userInitiated))
        #else
            let serverFD = socket(AF_INET, Self.socketStreamType, 0)
            guard serverFD >= 0 else {
                throw Self.socketError(message: "Unable to create fallback server socket")
            }

            var reuseAddr: Int32 = 1
            if setsockopt(
                serverFD,
                SOL_SOCKET,
                SO_REUSEADDR,
                &reuseAddr,
                socklen_t(MemoryLayout<Int32>.size)
            ) < 0 {
                Self.closeSocket(serverFD)
                throw Self.socketError(message: "Unable to configure fallback server socket")
            }

            var address = sockaddr_in()
            address.sin_family = sa_family_t(AF_INET)
            address.sin_port = UInt16(port).bigEndian

            if host == "0.0.0.0" {
                address.sin_addr = in_addr(s_addr: in_addr_t(0))
            } else {
                let parseResult = host.withCString { cString in
                    inet_pton(AF_INET, cString, &address.sin_addr)
                }
                if parseResult != 1 {
                    Self.closeSocket(serverFD)
                    throw NSError(
                        domain: "LocalHTTPServer",
                        code: 3,
                        userInfo: [
                            NSLocalizedDescriptionKey:
                                "Invalid IPv4 host for fallback server: \(host)"
                        ])
                }
            }

            let bindResult = withUnsafePointer(to: &address) { pointer in
                pointer.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                    bind(serverFD, $0, socklen_t(MemoryLayout<sockaddr_in>.size))
                }
            }

            guard bindResult >= 0 else {
                Self.closeSocket(serverFD)
                throw Self.socketError(message: "Unable to bind fallback server to \(host):\(port)")
            }

            guard listen(serverFD, SOMAXCONN) >= 0 else {
                Self.closeSocket(serverFD)
                throw Self.socketError(message: "Unable to listen on fallback server socket")
            }

            fallbackSocketFD = serverFD

            let queue = DispatchQueue(label: "local-http-server-fallback", qos: .userInitiated)
            fallbackQueue = queue

            let rootPath = self.rootPath
            queue.async {
                Self.acceptLoop(serverFD: serverFD, rootPath: rootPath)
            }

            print("🌐 Dev server listening on http://\(host):\(port) (swift fallback)")
        #endif
    }

    /// Stop the server.
    public func stop() {
        #if canImport(Network)
            listener?.cancel()
            listener = nil
        #else
            if fallbackSocketFD >= 0 {
                Self.shutdownSocket(fallbackSocketFD)
                Self.closeSocket(fallbackSocketFD)
                fallbackSocketFD = -1
            }
            fallbackQueue = nil
        #endif
    }

    #if canImport(Network)

        private static func handle(connection: NWConnection, rootPath: String) {
            connection.start(queue: .global(qos: .utility))

            connection.receive(minimumIncompleteLength: 1, maximumLength: 8192) { data, _, _, _ in
                let request = String(data: data ?? Data(), encoding: .utf8) ?? ""
                let path = LocalHTTPServer.extractPath(from: request)
                let response = LocalHTTPServer.response(for: path, rootPath: rootPath)
                connection.send(
                    content: response,
                    completion: .contentProcessed { _ in
                        connection.cancel()
                    })
            }
        }

    #else

        private static func acceptLoop(serverFD: Int32, rootPath: String) {
            while true {
                var clientAddress = sockaddr()
                var clientLength = socklen_t(MemoryLayout<sockaddr>.size)

                let clientFD = withUnsafeMutablePointer(to: &clientAddress) { pointer in
                    pointer.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                        accept(serverFD, $0, &clientLength)
                    }
                }

                if clientFD < 0 {
                    if errno == EBADF || errno == EINVAL || errno == ENOTSOCK {
                        break
                    }
                    continue
                }

                Self.handle(clientFD: clientFD, rootPath: rootPath)
            }
        }

        private static func handle(clientFD: Int32, rootPath: String) {
            defer {
                closeSocket(clientFD)
            }

            var buffer = [UInt8](repeating: 0, count: 8192)
            let received = recv(clientFD, &buffer, buffer.count, 0)
            guard received > 0 else {
                return
            }

            let request = String(decoding: buffer.prefix(Int(received)), as: UTF8.self)
            let path = extractPath(from: request)
            let response = response(for: path, rootPath: rootPath)
            response.withUnsafeBytes { bytes in
                guard let baseAddress = bytes.bindMemory(to: UInt8.self).baseAddress else {
                    return
                }
                var sentTotal = 0
                while sentTotal < response.count {
                    let sent = send(
                        clientFD, baseAddress + sentTotal, response.count - sentTotal, 0)
                    if sent <= 0 {
                        break
                    }
                    sentTotal += sent
                }
            }
        }

        private static let socketStreamType: Int32 = {
            #if canImport(Darwin)
                return SOCK_STREAM
            #else
                return Int32(SOCK_STREAM.rawValue)
            #endif
        }()

        private static func socketError(message: String) -> NSError {
            NSError(
                domain: "LocalHTTPServer",
                code: 2,
                userInfo: [
                    NSLocalizedDescriptionKey: "\(message): \(String(cString: strerror(errno)))"
                ]
            )
        }

        private static func shutdownSocket(_ fd: Int32) {
            #if canImport(Darwin)
                _ = shutdown(fd, SHUT_RDWR)
            #else
                _ = shutdown(fd, Int32(SHUT_RDWR))
            #endif
        }

        private static func closeSocket(_ fd: Int32) {
            _ = close(fd)
        }

    #endif

    private static func extractPath(from request: String) -> String {
        let firstLine = request.split(separator: "\n").first ?? ""
        let parts = firstLine.split(separator: " ")
        guard parts.count >= 2 else {
            return "/"
        }
        let rawPath = String(parts[1])
        return rawPath.isEmpty ? "/" : rawPath
    }

    private static func response(for requestPath: String, rootPath: String) -> Data {
        guard let fileURL = resolveFileURL(for: requestPath, rootPath: rootPath) else {
            return httpResponse(
                status: "404 Not Found", contentType: "text/plain", body: Data("Not Found".utf8))
        }

        do {
            let body = try Data(contentsOf: fileURL)
            let type = mimeType(for: fileURL.pathExtension.lowercased())
            return httpResponse(status: "200 OK", contentType: type, body: body)
        } catch {
            return httpResponse(
                status: "500 Internal Server Error", contentType: "text/plain",
                body: Data("Internal Server Error".utf8))
        }
    }

    private static func resolveFileURL(for requestPath: String, rootPath: String) -> URL? {
        let sanitizedPath = requestPath.split(separator: "?").first.map(String.init) ?? "/"
        let relative = sanitizedPath.trimmingCharacters(in: CharacterSet(charactersIn: "/"))

        let rootURL = URL(fileURLWithPath: rootPath)
        var targetURL = rootURL

        if relative.isEmpty {
            targetURL = rootURL.appendingPathComponent("index.html")
            return targetURL
        }

        targetURL = rootURL.appendingPathComponent(relative)

        var isDirectory: ObjCBool = false
        if FileManager.default.fileExists(atPath: targetURL.path, isDirectory: &isDirectory),
            isDirectory.boolValue
        {
            let indexURL = targetURL.appendingPathComponent("index.html")
            if FileManager.default.fileExists(atPath: indexURL.path) {
                return indexURL
            }
        }

        if FileManager.default.fileExists(atPath: targetURL.path) {
            return targetURL
        }

        let withIndex =
            rootURL
            .appendingPathComponent(relative)
            .appendingPathComponent("index.html")

        if FileManager.default.fileExists(atPath: withIndex.path) {
            return withIndex
        }

        return nil
    }

    private static func httpResponse(status: String, contentType: String, body: Data) -> Data {
        var headers = "HTTP/1.1 \(status)\r\n"
        headers += "Content-Type: \(contentType)\r\n"
        headers += "Content-Length: \(body.count)\r\n"
        headers += "Cache-Control: no-cache, no-store, must-revalidate\r\n"
        headers += "Pragma: no-cache\r\n"
        headers += "Expires: 0\r\n"
        headers += "Connection: close\r\n\r\n"

        var response = Data(headers.utf8)
        response.append(body)
        return response
    }

    private static func mimeType(for ext: String) -> String {
        switch ext {
        case "html": return "text/html; charset=utf-8"
        case "css": return "text/css; charset=utf-8"
        case "js": return "application/javascript; charset=utf-8"
        case "xml": return "application/xml; charset=utf-8"
        case "json": return "application/json; charset=utf-8"
        case "svg": return "image/svg+xml"
        case "png": return "image/png"
        case "jpg", "jpeg": return "image/jpeg"
        case "gif": return "image/gif"
        case "webp": return "image/webp"
        case "txt": return "text/plain; charset=utf-8"
        default: return "application/octet-stream"
        }
    }
}

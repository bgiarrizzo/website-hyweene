import Foundation
import Network

/// Minimal static HTTP server used by `hyweene dev`.
public final class LocalHTTPServer {
    private let host: String
    private let port: Int
    private let rootPath: String

    private var listener: NWListener?

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
    }

    /// Stop the server.
    public func stop() {
        listener?.cancel()
        listener = nil
    }

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

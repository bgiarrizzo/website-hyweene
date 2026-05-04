import Foundation

/// Supported CLI commands for the `hyweene` executable.
public enum CLICommand: Equatable, Sendable {
    case build
    case dev(host: String, port: Int)
    case quickAddLink(url: String, comment: String?)
    case checkDeadLinks(path: String?)
}

/// Command parsing errors for the `hyweene` executable.
public enum CLICommandParserError: LocalizedError, Equatable {
    case missingCommand
    case unknownCommand(String)
    case missingValue(option: String)
    case invalidPort(String)
    case invalidOption(String)
    case missingURL
    case invalidURL(String)
    case missingComment

    public var errorDescription: String? {
        switch self {
        case .missingCommand:
            return "Missing command."
        case .unknownCommand(let command):
            return "Unknown command: \(command)"
        case .missingValue(let option):
            return "Missing value for option: \(option)"
        case .invalidPort(let raw):
            return "Invalid port: \(raw). Expected an integer between 1 and 65535."
        case .invalidOption(let option):
            return "Invalid option: \(option)"
        case .missingURL:
            return "Missing URL argument for quick-add-link command."
        case .invalidURL(let raw):
            return "Invalid URL: \(raw)"
        case .missingComment:
            return "Missing value for option: --comment"
        }
    }
}

/// Parse command-line arguments into a `CLICommand`.
///
/// This parser expects full `CommandLine.arguments`, including the executable path at index 0.
/// - Parameter arguments: Raw command-line arguments.
/// - Returns: Parsed `CLICommand`.
/// - Throws: `CLICommandParserError` for invalid arguments.
public func parseCLICommand(arguments: [String]) throws -> CLICommand {
    let args = Array(arguments.dropFirst())

    guard let command = args.first else {
        throw CLICommandParserError.missingCommand
    }

    switch command {
    case "help":
        print(cliHelp(programName: arguments.first ?? "hyweene"))
        exit(0)
    case "version":
        print("hyweene version 1.0.0")
        exit(0)
    case "build":
        guard args.count == 1 else {
            throw CLICommandParserError.invalidOption(args[1])
        }
        return .build
    case "dev":
        return try parseDevCommand(arguments: Array(args.dropFirst()))
    case "quick-add-link":
        return try parseQuickAddLinkCommand(arguments: Array(args.dropFirst()))
    case "check-dead-links":
        return try parseCheckDeadLinksCommand(arguments: Array(args.dropFirst()))
    default:
        throw CLICommandParserError.unknownCommand(command)
    }
}

/// Return help text for the CLI.
public func cliHelp(programName: String = "hyweene") -> String {
    return """
        Usage:
            \(programName) build
            \(programName) dev --host <host> --port <port>
            \(programName) quick-add-link <url> [--comment <text>]
            \(programName) check-dead-links [--path <dir>]

        Commands:
            build                       Build the static website once.
            dev --host --port           Build, serve, and rebuild on file changes.
            quick-add-link <url>        Add a new curated link from a URL.
                                        With --comment, run non-interactively.
            check-dead-links            Check generated HTML for dead links.

        Examples:
            \(programName) build
            \(programName) dev --host 0.0.0.0 --port 1234
            \(programName) quick-add-link https://example.com
            \(programName) quick-add-link https://example.com --comment "Great read"
            \(programName) check-dead-links
            \(programName) check-dead-links --path ./current
        """
}

private func parseDevCommand(arguments: [String]) throws -> CLICommand {
    var host = "0.0.0.0"
    var port = 8000

    var index = 0
    while index < arguments.count {
        let token = arguments[index]

        switch token {
        case "--host":
            let valueIndex = index + 1
            guard valueIndex < arguments.count else {
                throw CLICommandParserError.missingValue(option: "--host")
            }
            host = arguments[valueIndex]
            index += 2
        case "--port":
            let valueIndex = index + 1
            guard valueIndex < arguments.count else {
                throw CLICommandParserError.missingValue(option: "--port")
            }
            let rawPort = arguments[valueIndex]
            guard let parsedPort = Int(rawPort), (1...65535).contains(parsedPort) else {
                throw CLICommandParserError.invalidPort(rawPort)
            }
            port = parsedPort
            index += 2
        default:
            throw CLICommandParserError.invalidOption(token)
        }
    }

    return .dev(host: host, port: port)
}

private func parseQuickAddLinkCommand(arguments: [String]) throws -> CLICommand {
    var urlString: String?
    var comment: String?

    var index = 0
    while index < arguments.count {
        let token = arguments[index]

        if token == "--comment" {
            let valueIndex = index + 1
            guard valueIndex < arguments.count else {
                throw CLICommandParserError.missingComment
            }
            comment = arguments[valueIndex]
            index += 2
            continue
        }

        if token.hasPrefix("--") {
            throw CLICommandParserError.invalidOption(token)
        }

        if urlString == nil {
            urlString = token
            index += 1
            continue
        }

        throw CLICommandParserError.invalidOption(token)
    }

    guard let resolvedURLString = urlString else {
        throw CLICommandParserError.missingURL
    }

    guard let url = URL(string: resolvedURLString), url.scheme != nil, url.host != nil else {
        throw CLICommandParserError.invalidURL(resolvedURLString)
    }

    return .quickAddLink(url: resolvedURLString, comment: comment)
}

private func parseCheckDeadLinksCommand(arguments: [String]) throws -> CLICommand {
    guard !arguments.isEmpty else {
        return .checkDeadLinks(path: nil)
    }

    var path: String?
    var index = 0

    while index < arguments.count {
        let token = arguments[index]

        switch token {
        case "--path":
            let valueIndex = index + 1
            guard valueIndex < arguments.count else {
                throw CLICommandParserError.missingValue(option: "--path")
            }
            path = arguments[valueIndex]
            index += 2
        default:
            throw CLICommandParserError.invalidOption(token)
        }
    }

    return .checkDeadLinks(path: path)
}

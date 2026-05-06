import ArgumentParser
import Foundation

/// Root command for the `hyweene` CLI.
public struct HyweeneCLIApp: AsyncParsableCommand {
    public static let configuration = CommandConfiguration(
        commandName: "hyweene",
        abstract: "Static site generator for hyweene.fr.",
        version: "1.0.0",
        subcommands: [Build.self, Dev.self, QuickAddLink.self, CheckDeadLinks.self]
    )

    public init() {}

    /// Build the website once.
    public struct Build: AsyncParsableCommand {
        public static let configuration = CommandConfiguration(
            commandName: "build",
            abstract: "Build the static website once."
        )

        public init() {}

        public mutating func run() async throws {
            _ = try BuildSiteUseCase().execute()
        }
    }

    /// Build, serve, and rebuild on changes.
    public struct Dev: AsyncParsableCommand {
        public static let configuration = CommandConfiguration(
            commandName: "dev",
            abstract: "Build, serve, and rebuild on file changes."
        )

        @Option(name: .long, help: "Bind host.")
        public var host: String = "0.0.0.0"

        @Option(name: .long, help: "Bind port (1...65535).")
        public var port: Int = 8000

        public init() {}

        public mutating func validate() throws {
            guard (1...65535).contains(port) else {
                throw ValidationError("--port must be between 1 and 65535.")
            }
        }

        public mutating func run() async throws {
            try await runDevMode(host: host, port: port)
        }
    }

    /// Add a curated link from a URL.
    public struct QuickAddLink: AsyncParsableCommand {
        public static let configuration = CommandConfiguration(
            commandName: "quick-add-link",
            abstract: "Add a curated link from a URL."
        )

        @Argument(help: "Absolute URL to fetch.")
        public var url: String

        @Option(name: .long, help: "Optional one-line comment (non-interactive mode).")
        public var comment: String?

        public init() {}

        public mutating func run() async throws {
            try await runQuickAddLink(urlString: url, comment: comment)
        }
    }

    /// Check generated HTML for dead external links.
    public struct CheckDeadLinks: AsyncParsableCommand {
        public static let configuration = CommandConfiguration(
            commandName: "check-dead-links",
            abstract: "Check generated HTML for dead external links."
        )

        @Option(name: .long, help: "Path to scan. Defaults to current release.")
        public var path: String?

        public init() {}

        public mutating func run() async throws {
            try await runCheckDeadLinks(path: path)
        }
    }
}

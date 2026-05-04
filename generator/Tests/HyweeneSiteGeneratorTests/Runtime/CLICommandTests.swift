import ArgumentParser
import Testing

@testable import HyweeneSiteGenerator

struct CLICommandTests {
    @Test("Parse build subcommand")
    func parseBuildSubcommand() throws {
        _ = try HyweeneCLIApp.Build.parse([])
    }

    @Test("Parse dev subcommand with explicit host and port")
    func parseDevSubcommandWithHostAndPort() throws {
        let command = try HyweeneCLIApp.Dev.parse([
            "--host", "0.0.0.0", "--port", "1234",
        ])
        #expect(command.host == "0.0.0.0")
        #expect(command.port == 1234)
    }

    @Test("Parse dev subcommand with defaults")
    func parseDevSubcommandWithDefaults() throws {
        let command = try HyweeneCLIApp.Dev.parse([])
        #expect(command.host == "0.0.0.0")
        #expect(command.port == 8000)
    }

    @Test("Parse unknown subcommand throws")
    func parseUnknownSubcommandThrows() {
        #expect(throws: Error.self) {
            _ = try HyweeneCLIApp.parseAsRoot(["unknown"])
        }
    }

    @Test("Parse invalid port format throws")
    func parseInvalidPortFormatThrows() {
        #expect(throws: Error.self) {
            _ = try HyweeneCLIApp.Dev.parse(["--port", "abc"])
        }
    }

    @Test("Parse out-of-range port throws")
    func parseOutOfRangePortThrows() {
        #expect(throws: Error.self) {
            _ = try HyweeneCLIApp.Dev.parse(["--port", "70000"])
        }
    }

    @Test("Parse missing host value throws")
    func parseMissingHostValueThrows() {
        #expect(throws: Error.self) {
            _ = try HyweeneCLIApp.Dev.parse(["--host"])
        }
    }

    @Test("Parse quick-add-link subcommand")
    func parseQuickAddLinkSubcommand() throws {
        let command = try HyweeneCLIApp.QuickAddLink.parse(["https://example.com"])
        #expect(command.url == "https://example.com")
        #expect(command.comment == nil)
    }

    @Test("Parse quick-add-link subcommand with comment option")
    func parseQuickAddLinkSubcommandWithComment() throws {
        let command = try HyweeneCLIApp.QuickAddLink.parse([
            "https://example.com", "--comment", "Great read",
        ])
        #expect(command.url == "https://example.com")
        #expect(command.comment == "Great read")
    }

    @Test("Parse quick-add-link missing URL throws")
    func parseQuickAddLinkMissingURLThrows() {
        #expect(throws: Error.self) {
            _ = try HyweeneCLIApp.QuickAddLink.parse([])
        }
    }

    @Test("Parse quick-add-link missing comment value throws")
    func parseQuickAddLinkMissingCommentValueThrows() {
        #expect(throws: Error.self) {
            _ = try HyweeneCLIApp.QuickAddLink.parse(["https://example.com", "--comment"])
        }
    }

    @Test("Parse check-dead-links default path")
    func parseCheckDeadLinksDefaultPath() throws {
        let command = try HyweeneCLIApp.CheckDeadLinks.parse([])
        #expect(command.path == nil)
    }

    @Test("Parse check-dead-links custom path")
    func parseCheckDeadLinksCustomPath() throws {
        let command = try HyweeneCLIApp.CheckDeadLinks.parse(["--path", "./current"])
        #expect(command.path == "./current")
    }

    @Test("Parse check-dead-links missing path value throws")
    func parseCheckDeadLinksMissingPathValueThrows() {
        #expect(throws: Error.self) {
            _ = try HyweeneCLIApp.CheckDeadLinks.parse(["--path"])
        }
    }
}

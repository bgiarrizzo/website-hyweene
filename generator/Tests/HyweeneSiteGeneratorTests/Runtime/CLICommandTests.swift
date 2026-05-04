import Testing

@testable import HyweeneSiteGenerator

@Suite("CLICommand") struct CLICommandTests {
    @Test("Parse build command")
    func parseBuildCommand() throws {
        let command = try parseCLICommand(arguments: ["hyweene", "build"])
        #expect(command == .build)
    }

    @Test("Parse dev command with explicit host and port")
    func parseDevCommandWithHostAndPort() throws {
        let command = try parseCLICommand(arguments: [
            "hyweene", "dev", "--host", "0.0.0.0", "--port", "1234",
        ])
        #expect(command == .dev(host: "0.0.0.0", port: 1234))
    }

    @Test("Parse dev command with defaults")
    func parseDevCommandWithDefaults() throws {
        let command = try parseCLICommand(arguments: ["hyweene", "dev"])
        #expect(command == .dev(host: "0.0.0.0", port: 8000))
    }

    @Test("Parse unknown command throws")
    func parseUnknownCommandThrows() {
        #expect(throws: CLICommandParserError.unknownCommand("unknown")) {
            _ = try parseCLICommand(arguments: ["hyweene", "unknown"])
        }
    }

    @Test("Parse invalid port throws")
    func parseInvalidPortThrows() {
        #expect(throws: CLICommandParserError.invalidPort("abc")) {
            _ = try parseCLICommand(arguments: ["hyweene", "dev", "--port", "abc"])
        }
    }

    @Test("Parse out-of-range port throws")
    func parseOutOfRangePortThrows() {
        #expect(throws: CLICommandParserError.invalidPort("70000")) {
            _ = try parseCLICommand(arguments: ["hyweene", "dev", "--port", "70000"])
        }
    }

    @Test("Parse missing host value throws")
    func parseMissingHostValueThrows() {
        #expect(throws: CLICommandParserError.missingValue(option: "--host")) {
            _ = try parseCLICommand(arguments: ["hyweene", "dev", "--host"])
        }
    }

    @Test("Help text contains both commands")
    func helpTextContainsCommands() {
        let help = cliHelp(programName: "hyweene")

        #expect(help.contains("hyweene build"))
        #expect(help.contains("hyweene dev --host <host> --port <port>"))
        #expect(help.contains("hyweene quick-add-link <url> [--comment <text>]"))
        #expect(help.contains("hyweene check-dead-links [--path <dir>]"))
    }

    @Test("Parse quick-add-link command")
    func parseQuickAddLinkCommand() throws {
        let command = try parseCLICommand(arguments: [
            "hyweene", "quick-add-link", "https://example.com",
        ])
        #expect(command == .quickAddLink(url: "https://example.com", comment: nil))
    }

    @Test("Parse quick-add-link command with comment option")
    func parseQuickAddLinkCommandWithComment() throws {
        let command = try parseCLICommand(arguments: [
            "hyweene", "quick-add-link", "https://example.com", "--comment", "Great read",
        ])
        #expect(command == .quickAddLink(url: "https://example.com", comment: "Great read"))
    }

    @Test("Parse quick-add-link missing URL throws")
    func parseQuickAddLinkMissingURLThrows() {
        #expect(throws: CLICommandParserError.missingURL) {
            _ = try parseCLICommand(arguments: ["hyweene", "quick-add-link"])
        }
    }

    @Test("Parse quick-add-link invalid URL throws")
    func parseQuickAddLinkInvalidURLThrows() {
        #expect(throws: CLICommandParserError.invalidURL("notaurl")) {
            _ = try parseCLICommand(arguments: ["hyweene", "quick-add-link", "notaurl"])
        }
    }

    @Test("Parse quick-add-link missing comment value throws")
    func parseQuickAddLinkMissingCommentValueThrows() {
        #expect(throws: CLICommandParserError.missingComment) {
            _ = try parseCLICommand(arguments: [
                "hyweene", "quick-add-link", "https://example.com", "--comment",
            ])
        }
    }

    @Test("Parse check-dead-links default path")
    func parseCheckDeadLinksDefaultPath() throws {
        let command = try parseCLICommand(arguments: ["hyweene", "check-dead-links"])
        #expect(command == .checkDeadLinks(path: nil))
    }

    @Test("Parse check-dead-links custom path")
    func parseCheckDeadLinksCustomPath() throws {
        let command = try parseCLICommand(arguments: [
            "hyweene", "check-dead-links", "--path", "./current",
        ])
        #expect(command == .checkDeadLinks(path: "./current"))
    }

    @Test("Parse check-dead-links missing path value throws")
    func parseCheckDeadLinksMissingPathValueThrows() {
        #expect(throws: CLICommandParserError.missingValue(option: "--path")) {
            _ = try parseCLICommand(arguments: ["hyweene", "check-dead-links", "--path"])
        }
    }
}

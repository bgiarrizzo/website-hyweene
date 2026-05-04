import Foundation
import HyweeneSiteGenerator

@main
struct HyweeneCLI {
    static func main() async {
        let statusCode = await run(arguments: CommandLine.arguments)
        Foundation.exit(statusCode)
    }

    private static func run(arguments: [String]) async -> Int32 {
        do {
            let command = try parseCLICommand(arguments: arguments)

            switch command {
            case .build:
                _ = try buildSite()
                return 0
            case .dev(let host, let port):
                try await runDevMode(host: host, port: port)
                return 0
            case .quickAddLink(let url, let comment):
                try await runQuickAddLink(urlString: url, comment: comment)
                return 0
            case .checkDeadLinks(let path):
                try await runCheckDeadLinks(path: path)
                return 0
            }
        } catch let parserError as CLICommandParserError {
            if parserError != .missingCommand {
                print("❌ \(parserError.localizedDescription)")
            }
            print("")
            print(cliHelp(programName: "hyweene"))
            return 2
        } catch {
            print("")
            print("❌ Error: \(error)")
            print("")
            return 1
        }
    }
}

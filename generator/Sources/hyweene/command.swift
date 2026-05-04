import ArgumentParser
import HyweeneSiteGenerator

@main
struct HyweeneCLI: AsyncParsableCommand {
    static let configuration = HyweeneCLIApp.configuration
}

import Foundation

/// Run the development mode: initial build, static server, and file watching.
/// - Parameters:
///   - host: Server host.
///   - port: Server port.
/// - Throws: Any build or server startup error.
public func runDevMode(host: String, port: Int) async throws {
    print("🔧 Starting development mode...")

    _ = try buildSite()

    let server = LocalHTTPServer(host: host, port: port, rootPath: Config.currentReleasePath)
    try server.start()

    let watcher = DirectoryWatcher(
        watchedDirectories: [
            Config.siteContentPath,
            Config.templatePath,
        ],
        debounceDuration: .milliseconds(500)
    )

    print("👀 Watching for changes in \(Config.siteContentPath) and \(Config.templatePath)")

    await watcher.watch {
        print("🔄 Change detected, rebuilding...")
        do {
            _ = try buildSite()
            print("✅ Rebuild complete")
        } catch {
            print("❌ Rebuild failed: \(error)")
            print("ℹ️  Serving previous successful build from \(Config.currentReleasePath)")
        }
    }
}

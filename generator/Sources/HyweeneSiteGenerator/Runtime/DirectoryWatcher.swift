import Foundation

/// Polling-based directory watcher built on modern Swift concurrency.
public struct DirectoryWatcher {
    private let watchedDirectories: [String]
    private let debounceDuration: Duration

    /// Create a watcher for one or more directories.
    /// - Parameters:
    ///   - watchedDirectories: Absolute or relative directory paths.
    ///   - debounceDuration: Polling interval and debounce window.
    public init(watchedDirectories: [String], debounceDuration: Duration = .milliseconds(500)) {
        self.watchedDirectories = watchedDirectories
        self.debounceDuration = debounceDuration
    }

    /// Start watching and call `onChange` whenever content changes are detected.
    /// - Parameter onChange: Async callback executed after a debounced change signal.
    public func watch(onChange: @escaping @Sendable () async -> Void) async {
        var previousSnapshot = snapshot()

        while !Task.isCancelled {
            do {
                try await Task.sleep(for: debounceDuration)
            } catch {
                return
            }

            let currentSnapshot = snapshot()
            if currentSnapshot != previousSnapshot {
                previousSnapshot = currentSnapshot
                await onChange()
            }
        }
    }

    private func snapshot() -> [String: Date] {
        let fm = FileManager.default
        var state: [String: Date] = [:]

        for directory in watchedDirectories {
            let rootURL = URL(fileURLWithPath: directory)

            guard
                let enumerator = fm.enumerator(
                    at: rootURL,
                    includingPropertiesForKeys: [.contentModificationDateKey, .isRegularFileKey],
                    options: [.skipsHiddenFiles, .skipsPackageDescendants]
                )
            else {
                continue
            }

            for case let fileURL as URL in enumerator {
                guard
                    let values = try? fileURL.resourceValues(forKeys: [
                        .isRegularFileKey, .contentModificationDateKey,
                    ]),
                    values.isRegularFile == true
                else {
                    continue
                }

                let key = fileURL.path
                state[key] = values.contentModificationDate ?? .distantPast
            }
        }

        return state
    }
}

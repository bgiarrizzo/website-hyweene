import Foundation

/// `FileRepository` implementation backed by the local file system.
///
/// All writes are placed under `basePath`, which is typically `Config.releasePath`.
public struct LocalFileRepository: FileRepository {
    private let basePath: String

    /// - Parameter basePath: Absolute path prepended to every `relativePath` in `writeFile`.
    public init(basePath: String) {
        self.basePath = basePath
    }

    // MARK: - FileRepository

    public func writeFile(content: String, to relativePath: String) throws {
        let fullPath = "\(basePath)/\(relativePath)"
        try FileManager.default.writeFile(content: content, to: fullPath)
    }
}

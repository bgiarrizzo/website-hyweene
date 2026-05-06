/// Protocol for file-system write operations used by content generators.
///
/// Implementations must be safe to call from any concurrency context.
public protocol FileRepository: Sendable {
    /// Write `content` to `relativePath` under the repository's configured base path.
    func writeFile(content: String, to relativePath: String) throws
}

/// Protocol for loading validated link entities from content sources.
public protocol LinkContentRepository: Sendable {
    /// Load and return all link items sorted by publish date descending.
    func loadLinks() throws -> [LinkItemEntity]
}

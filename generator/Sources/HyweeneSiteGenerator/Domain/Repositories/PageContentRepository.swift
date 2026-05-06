/// Protocol for loading validated static page entities from content sources.
public protocol PageContentRepository: Sendable {
    /// Load and return all static pages.
    func loadPages() throws -> [PageEntity]
}

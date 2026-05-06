/// Protocol describing how domain content is loaded from its source.
///
/// Implementations must be safe to call from any concurrency context.
public protocol ContentRepository: Sendable {
    /// Load all blog posts from the content source.
    func loadBlogPosts() throws -> [BlogPostEntity]
}

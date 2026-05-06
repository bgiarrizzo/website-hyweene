/// The result of a successful blog generation run.
public struct BuildBlogResult: @unchecked Sendable {
    /// Non-draft posts sorted by publish date descending.
    public let posts: [BlogPostEntity]
    /// Unique categories extracted from the posts, sorted by name.
    public let categories: [BlogPostCategory]

    /// Memberwise initialiser.
    public init(posts: [BlogPostEntity], categories: [BlogPostCategory]) {
        self.posts = posts
        self.categories = categories
    }
}

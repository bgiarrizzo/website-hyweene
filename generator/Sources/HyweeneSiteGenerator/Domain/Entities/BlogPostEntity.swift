import Foundation

/// Immutable domain entity representing a fully-validated blog post.
///
/// `@unchecked Sendable` because `DateFormat` is a class with only `let` properties,
/// making it effectively immutable and safe to share across concurrency contexts.
public struct BlogPostEntity: @unchecked Sendable {
    /// Post title.
    public let title: String
    /// URL-friendly slug derived from the title.
    public let slug: String
    /// Rendered HTML body.
    public let body: String
    /// Short summary of the post.
    public let summary: String
    /// Publish date with multiple format representations.
    public let publishDate: DateFormat
    /// Last update date; defaults to `publishDate` when absent.
    public let updateDate: DateFormat
    /// Blog category.
    public let category: BlogPostCategory
    /// List of tags.
    public let tags: [String]
    /// Estimated reading time in minutes.
    public let readingTime: Int
    /// URL path segment, e.g. `"2024-01-15-my-post"`.
    public let path: String
    /// Whether Prism syntax highlighting is required.
    public let prismNeeded: Bool
    /// Optional cover image path.
    public let cover: String?
    /// Whether the post is a draft.
    public let draft: Bool
    /// Optional HTML table of contents.
    public let tocHTML: String?

    /// Memberwise initialiser.
    public init(
        title: String,
        slug: String,
        body: String,
        summary: String,
        publishDate: DateFormat,
        updateDate: DateFormat,
        category: BlogPostCategory,
        tags: [String],
        readingTime: Int,
        path: String,
        prismNeeded: Bool,
        cover: String?,
        draft: Bool,
        tocHTML: String?
    ) {
        self.title = title
        self.slug = slug
        self.body = body
        self.summary = summary
        self.publishDate = publishDate
        self.updateDate = updateDate
        self.category = category
        self.tags = tags
        self.readingTime = readingTime
        self.path = path
        self.prismNeeded = prismNeeded
        self.cover = cover
        self.draft = draft
        self.tocHTML = tocHTML
    }

    // MARK: - Template Context

    /// Returns a template context dictionary whose shape matches `BlogPost.toDictionary()`.
    ///
    /// This preserves compatibility with existing Stencil templates during migration.
    public func toDictionary() -> [String: Any] {
        var dict: [String: Any] = [
            "title": title,
            "slug": slug,
            "body": body,
            "summary": summary,
            "tags": tags,
            "reading_time": formattedReadingTime,
            "prism_needed": prismNeeded,
            "draft": draft,
            "path": path,
            "publish_date": publishDate.toDictionary(),
            "update_date": updateDate.toDictionary(),
            "category": category.toDictionary(),
        ]
        if let cover { dict["cover"] = cover }
        if let tocHTML { dict["toc_html"] = tocHTML }
        return dict
    }

    // MARK: - Private Helpers

    private var formattedReadingTime: String {
        readingTime == 1 ? "1 minute" : "\(readingTime) minutes"
    }
}

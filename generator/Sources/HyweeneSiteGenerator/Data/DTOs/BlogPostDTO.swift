import Foundation

/// Raw data parsed from a blog post Markdown file.
///
/// All fields are optional to faithfully represent unvalidated YAML frontmatter.
/// This type is consumed exclusively by `BlogPostMapper`; it must not leak into Domain.
public struct BlogPostDTO: Sendable {
    /// Source file path, used for error diagnostics.
    public let filePath: String
    /// Post title from frontmatter.
    public let title: String?
    /// Pre-computed slug; derived from title when absent.
    public let slug: String?
    /// Rendered HTML body.
    public let body: String
    /// Short summary.
    public let summary: String?
    /// Parsed publish date.
    public let publishDate: DateFormat?
    /// Parsed update date.
    public let updateDate: DateFormat?
    /// Raw category name string.
    public let categoryName: String?
    /// Tag list.
    public let tags: [String]
    /// Whether Prism syntax highlighting is required.
    public let prismNeeded: Bool
    /// Optional cover image path.
    public let cover: String?
    /// Whether this is a draft post.
    public let draft: Bool
    /// Optional HTML table of contents.
    public let tocHTML: String?

    /// Build a DTO from the raw dictionary produced by `MarkdownParser.parseMarkdownFile(_:)`.
    public init(from rawData: [String: Any], filePath: String) {
        self.filePath = filePath
        self.title = rawData["title"] as? String
        self.slug = (rawData["slug"] as? String)
        self.body = rawData["body"] as? String ?? ""
        self.summary = rawData["summary"] as? String

        // Publish date — Yams may return a String or a Date object
        if let str = rawData["publish_date"] as? String {
            self.publishDate = DateFormat(from: str) ?? DateFormat()
        } else if let date = rawData["publish_date"] as? Date {
            self.publishDate = DateFormat(date)
        } else {
            self.publishDate = nil
        }

        // Update date
        if let str = rawData["update_date"] as? String {
            self.updateDate = DateFormat(from: str)
        } else if let date = rawData["update_date"] as? Date {
            self.updateDate = DateFormat(date)
        } else {
            self.updateDate = nil
        }

        self.categoryName = rawData["category"] as? String
        self.tags = rawData["tags"] as? [String] ?? []
        self.prismNeeded = rawData["prism_needed"] as? Bool ?? false
        self.cover = rawData["cover"] as? String
        self.draft = rawData["draft"] as? Bool ?? false
        self.tocHTML = rawData["toc_html"] as? String
    }
}

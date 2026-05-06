/// Raw data parsed from a static page Markdown file.
///
/// Fields remain optional until validated by `PageMapper`.
public struct PageDTO: Sendable {
    /// Source file path, used for diagnostics.
    public let filePath: String
    /// Page title from frontmatter.
    public let title: String?
    /// Rendered HTML body.
    public let body: String
    /// Public URL segment.
    public let permalink: String?
    /// Optional summary text.
    public let summary: String?
    /// Optional cover image path.
    public let cover: String?

    /// Build a DTO from the raw parser output.
    public init(from rawData: [String: Any], filePath: String) {
        self.filePath = filePath
        self.title = rawData["title"] as? String
        self.body = rawData["body"] as? String ?? ""
        self.permalink = rawData["permalink"] as? String
        self.summary = rawData["summary"] as? String
        self.cover = rawData["cover"] as? String
    }
}

/// Immutable domain entity representing a validated static page.
public struct PageEntity: Sendable {
    /// Display title for the page.
    public let title: String
    /// Rendered HTML body.
    public let body: String
    /// Public URL segment, e.g. "about". Empty means homepage.
    public let permalink: String
    /// Slug derived from the title.
    public let slug: String
    /// Short summary text.
    public let summary: String
    /// Optional cover image path.
    public let cover: String?

    /// Memberwise initialiser.
    public init(
        title: String,
        body: String,
        permalink: String,
        slug: String,
        summary: String,
        cover: String?
    ) {
        self.title = title
        self.body = body
        self.permalink = permalink
        self.slug = slug
        self.summary = summary
        self.cover = cover
    }

    /// Returns a template context dictionary matching legacy `Page.toDictionary()`.
    public func toDictionary() -> [String: Any] {
        var dict: [String: Any] = [
            "title": title,
            "body": body,
            "permalink": permalink,
            "slug": slug,
            "summary": summary,
        ]

        if let cover {
            dict["cover"] = cover
        }

        return dict
    }
}

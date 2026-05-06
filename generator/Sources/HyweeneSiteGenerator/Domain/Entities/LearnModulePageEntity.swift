/// Immutable domain entity representing a validated page inside a learning module.
public struct LearnModulePageEntity: Sendable {
    /// Sort identifier.
    public let id: Int?
    /// Display title.
    public let title: String
    /// URL slug derived from the title.
    public let slug: String
    /// Short summary text.
    public let summary: String
    /// Normalized page tags.
    public let tags: [String]
    /// Publish date.
    public let publishDate: DateFormat
    /// Last update date.
    public let updateDate: DateFormat
    /// HTML table of contents.
    public let toc: String
    /// Rendered HTML body.
    public let body: String
    /// Whether Prism assets are required.
    public let prismNeeded: Bool
    /// Disabled flag retained for template compatibility.
    public let disabled: Bool

    /// Memberwise initialiser.
    public init(
        id: Int?,
        title: String,
        slug: String,
        summary: String,
        tags: [String],
        publishDate: DateFormat,
        updateDate: DateFormat,
        toc: String,
        body: String,
        prismNeeded: Bool,
        disabled: Bool
    ) {
        self.id = id
        self.title = title
        self.slug = slug
        self.summary = summary
        self.tags = tags
        self.publishDate = publishDate
        self.updateDate = updateDate
        self.toc = toc
        self.body = body
        self.prismNeeded = prismNeeded
        self.disabled = disabled
    }

    /// Returns a template dictionary matching the legacy learning page shape.
    public func toDictionary(module: LearnModuleEntity) -> [String: Any] {
        var dict: [String: Any] = [
            "title": title,
            "slug": slug,
            "summary": summary,
            "tags": tags,
            "publish_date": publishDate.toDictionary(),
            "update_date": updateDate.toDictionary(),
            "toc": toc,
            "body": body,
            "prism_needed": prismNeeded,
            "disabled": disabled,
            "module": module.summaryDictionary(),
        ]

        if let id {
            dict["id"] = id
        }

        return dict
    }
}

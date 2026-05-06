import Foundation

/// Immutable domain entity representing a validated curated link.
public struct LinkItemEntity: @unchecked Sendable {
    /// Display title of the curated link.
    public let title: String
    /// Target URL of the curated resource.
    public let url: String
    /// URL path segment, e.g. "2026-04-20-some-title".
    public let path: String
    /// Short optional description.
    public let description: String
    /// Parsed publication date.
    public let publishDate: DateFormat
    /// Optional update date.
    public let updateDate: DateFormat?
    /// Rendered HTML body.
    public let body: String
    /// URL-friendly slug.
    public let slug: String

    /// Memberwise initialiser.
    public init(
        title: String,
        url: String,
        path: String,
        description: String,
        publishDate: DateFormat,
        updateDate: DateFormat?,
        body: String,
        slug: String
    ) {
        self.title = title
        self.url = url
        self.path = path
        self.description = description
        self.publishDate = publishDate
        self.updateDate = updateDate
        self.body = body
        self.slug = slug
    }

    /// Returns a template context dictionary matching legacy `LinkItem.toDictionary()`.
    public func toDictionary() -> [String: Any] {
        var dict: [String: Any] = [
            "title": title,
            "url": url,
            "description": description,
            "body": body,
            "slug": slug,
            "path": path,
            "publish_date": publishDate.toDictionary(),
            "is_image": isImageURL(url),
        ]

        if let updateDate {
            dict["update_date"] = updateDate.toDictionary()
            dict["show_update_date"] = updateDate.short != publishDate.short
        }

        return dict
    }

    private func isImageURL(_ value: String) -> Bool {
        let url = value.lowercased()
        return url.hasSuffix(".jpg") || url.hasSuffix(".jpeg") || url.hasSuffix(".png") || url.hasSuffix(".gif")
    }
}

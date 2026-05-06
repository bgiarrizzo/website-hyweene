/// Immutable domain value object representing a blog category.
public struct BlogPostCategory: Sendable {
    /// Display name of the category.
    public let name: String
    /// URL-friendly slug derived from `name`.
    public let slug: String

    /// - Parameter name: Raw category display name.
    public init(name: String) {
        self.name = name
        self.slug = slugify(name)
    }

    /// Returns the template dictionary shape used by blog templates.
    public func toDictionary() -> [String: Any] {
        [
            "name": name,
            "slug": slug,
        ]
    }
}

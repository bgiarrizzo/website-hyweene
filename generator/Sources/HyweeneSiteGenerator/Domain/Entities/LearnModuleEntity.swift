/// Immutable domain entity representing a validated learning module.
public struct LearnModuleEntity: Sendable {
    /// Sort identifier.
    public let id: Int?
    /// Module display name.
    public let name: String
    /// URL slug derived from the name.
    public let slug: String
    /// Optional logo asset name.
    public let logo: String?
    /// Short description text.
    public let description: String
    /// Disabled flag retained for template compatibility.
    public let disabled: Bool
    /// Validated pages sorted by ascending id.
    public let pages: [LearnModulePageEntity]

    /// Memberwise initialiser.
    public init(
        id: Int?,
        name: String,
        slug: String,
        logo: String?,
        description: String,
        disabled: Bool,
        pages: [LearnModulePageEntity]
    ) {
        self.id = id
        self.name = name
        self.slug = slug
        self.logo = logo
        self.description = description
        self.disabled = disabled
        self.pages = pages.sorted { ($0.id ?? 0) < ($1.id ?? 0) }
    }

    /// Returns a compact dictionary for nested page context.
    public func summaryDictionary() -> [String: Any] {
        var dict: [String: Any] = [
            "name": name,
            "slug": slug,
            "description": description,
            "id": id ?? 0,
        ]

        if let logo {
            dict["logo"] = logo
        }

        return dict
    }

    /// Returns a template dictionary matching the legacy learning module shape.
    public func toDictionary() -> [String: Any] {
        var dict: [String: Any] = [
            "name": name,
            "slug": slug,
            "description": description,
            "disabled": disabled,
            "pages": pages.map { $0.toDictionary(module: self) },
        ]

        if let id {
            dict["id"] = id
        }
        if let logo {
            dict["logo"] = logo
        }

        return dict
    }
}

/// Raw parsed data for a learning module descriptor.
public struct LearnModuleDTO: Sendable {
    /// Source file path for diagnostics.
    public let filePath: String
    /// Sort identifier.
    public let id: Int?
    /// Display name.
    public let name: String?
    /// Optional logo asset name.
    public let logo: String?
    /// Optional description text.
    public let description: String?
    /// Disabled flag.
    public let disabled: Bool
    /// Raw page DTOs discovered under the module directory.
    public let pages: [LearnModulePageDTO]

    /// Memberwise initialiser.
    public init(
        filePath: String,
        id: Int?,
        name: String?,
        logo: String?,
        description: String?,
        disabled: Bool,
        pages: [LearnModulePageDTO]
    ) {
        self.filePath = filePath
        self.id = id
        self.name = name
        self.logo = logo
        self.description = description
        self.disabled = disabled
        self.pages = pages
    }

    /// Build a DTO from parsed YAML data and page DTOs.
    public init(from rawData: [String: Any], filePath: String, pages: [LearnModulePageDTO]) {
        self.filePath = filePath
        self.id = rawData["id"] as? Int
        self.name = rawData["name"] as? String
        self.logo = rawData["logo"] as? String
        self.description = rawData["description"] as? String
        self.disabled = rawData["disabled"] as? Bool ?? false
        self.pages = pages
    }
}

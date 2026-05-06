/// Raw parsed data for a resume skill section.
public struct ResumeSkillDTO: Sendable {
    /// Source file path for diagnostics.
    public let filePath: String
    /// Sort identifier.
    public let id: Int?
    /// Rendered HTML body.
    public let body: String

    /// Build a DTO from raw parser output.
    public init(from rawData: [String: Any], filePath: String) {
        self.filePath = filePath
        self.id = rawData["id"] as? Int
        self.body = rawData["body"] as? String ?? ""
    }
}

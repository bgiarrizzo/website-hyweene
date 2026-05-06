/// Raw parsed data for the resume head section.
public struct ResumeHeadDTO: Sendable {
    /// Source file path for diagnostics.
    public let filePath: String
    /// Rendered HTML body.
    public let body: String

    /// Build a DTO from raw parser output.
    public init(from rawData: [String: Any], filePath: String) {
        self.filePath = filePath
        self.body = rawData["body"] as? String ?? ""
    }
}

/// Raw parsed data for a resume experience entry.
public struct ResumeExperienceDTO: Sendable {
    /// Source file path for diagnostics.
    public let filePath: String
    /// Sort identifier.
    public let id: Int?
    /// Job title.
    public let title: String?
    /// Company name.
    public let company: String?
    /// Optional company URL.
    public let companyURL: String?
    /// Location label.
    public let location: String?
    /// Work mode label.
    public let workMode: String?
    /// Optional start date label.
    public let startDate: String?
    /// Optional end date label.
    public let endDate: String?
    /// Optional contract type label.
    public let contractType: String?
    /// Raw tags.
    public let tags: [String]
    /// Rendered HTML body.
    public let body: String

    /// Build a DTO from raw parser output.
    public init(from rawData: [String: Any], filePath: String) {
        self.filePath = filePath
        self.id = rawData["id"] as? Int
        self.title = rawData["title"] as? String
        self.company = rawData["company"] as? String
        self.companyURL = rawData["company_url"] as? String
        self.location = rawData["location"] as? String
        self.workMode = rawData["work_mode"] as? String
        self.startDate = rawData["start_date"] as? String
        self.endDate = rawData["end_date"] as? String
        self.contractType = rawData["contract_type"] as? String
        self.tags = rawData["tags"] as? [String] ?? []
        self.body = rawData["body"] as? String ?? ""
    }
}

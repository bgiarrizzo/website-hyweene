/// Raw parsed data for a resume education entry.
public struct ResumeEducationDTO: Sendable {
    /// Source file path for diagnostics.
    public let filePath: String
    /// Sort identifier.
    public let id: Int?
    /// Formation title.
    public let title: String?
    /// School name.
    public let school: String?
    /// Location label.
    public let location: String?
    /// Optional start date label.
    public let startDate: String?
    /// Optional end date label.
    public let endDate: String?
    /// Optional formation type label.
    public let formationType: String?
    /// Optional status label.
    public let status: String?
    /// Rendered HTML body.
    public let body: String

    /// Build a DTO from raw parser output.
    public init(from rawData: [String: Any], filePath: String) {
        self.filePath = filePath
        self.id = rawData["id"] as? Int
        self.title = rawData["title"] as? String
        self.school = rawData["school"] as? String
        self.location = rawData["location"] as? String
        self.startDate = rawData["start_date"] as? String
        self.endDate = rawData["end_date"] as? String
        self.formationType = rawData["formation_type"] as? String
        self.status = rawData["status"] as? String
        self.body = rawData["body"] as? String ?? ""
    }
}

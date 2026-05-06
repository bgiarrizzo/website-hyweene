/// Immutable domain entity for a professional experience entry.
public struct ResumeExperienceEntity: Sendable {
    /// Sort identifier.
    public let id: Int?
    /// Job title.
    public let title: String
    /// Company name.
    public let company: String
    /// Optional company URL.
    public let companyURL: String?
    /// Location label.
    public let location: String
    /// Work mode label.
    public let workMode: String
    /// Optional start date label.
    public let startDate: String?
    /// Optional end date label.
    public let endDate: String?
    /// Optional contract type label.
    public let contractType: String?
    /// Experience tags.
    public let tags: [String]
    /// Rendered HTML body.
    public let body: String

    /// Memberwise initialiser.
    public init(
        id: Int?,
        title: String,
        company: String,
        companyURL: String?,
        location: String,
        workMode: String,
        startDate: String?,
        endDate: String?,
        contractType: String?,
        tags: [String],
        body: String
    ) {
        self.id = id
        self.title = title
        self.company = company
        self.companyURL = companyURL
        self.location = location
        self.workMode = workMode
        self.startDate = startDate
        self.endDate = endDate
        self.contractType = contractType
        self.tags = tags
        self.body = body
    }

    /// Returns a template dictionary matching legacy `ResumeExperience.toDictionary()`.
    public func toDictionary() -> [String: Any] {
        var dict: [String: Any] = [
            "title": title,
            "company": company,
            "location": location,
            "work_mode": workMode,
            "tags": tags,
            "body": body,
        ]

        if let id {
            dict["id"] = id
        }
        if let companyURL {
            dict["company_url"] = companyURL
        }
        if let startDate {
            dict["start_date"] = startDate
        }
        if let endDate {
            dict["end_date"] = endDate
        }
        if let contractType {
            dict["contract_type"] = contractType
        }

        return dict
    }
}

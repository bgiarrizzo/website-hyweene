/// Immutable domain entity for an education entry.
public struct ResumeEducationEntity: Sendable {
    /// Sort identifier.
    public let id: Int?
    /// Formation title.
    public let title: String
    /// School name.
    public let school: String
    /// Location label.
    public let location: String
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

    /// Memberwise initialiser.
    public init(
        id: Int?,
        title: String,
        school: String,
        location: String,
        startDate: String?,
        endDate: String?,
        formationType: String?,
        status: String?,
        body: String
    ) {
        self.id = id
        self.title = title
        self.school = school
        self.location = location
        self.startDate = startDate
        self.endDate = endDate
        self.formationType = formationType
        self.status = status
        self.body = body
    }

    /// Returns a template dictionary matching legacy `ResumeEducation.toDictionary()`.
    public func toDictionary() -> [String: Any] {
        var dict: [String: Any] = [
            "title": title,
            "school": school,
            "location": location,
            "body": body,
        ]

        if let id {
            dict["id"] = id
        }
        if let startDate {
            dict["start_date"] = startDate
        }
        if let endDate {
            dict["end_date"] = endDate
        }
        if let formationType {
            dict["formation_type"] = formationType
        }
        if let status {
            dict["status"] = status
        }

        return dict
    }
}

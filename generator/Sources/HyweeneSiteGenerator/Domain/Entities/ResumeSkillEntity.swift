/// Immutable domain entity for a resume skill section.
public struct ResumeSkillEntity: Sendable {
    /// Sort identifier.
    public let id: Int?
    /// Rendered HTML body.
    public let body: String

    /// Memberwise initialiser.
    public init(id: Int?, body: String) {
        self.id = id
        self.body = body
    }

    /// Returns a template dictionary matching legacy `ResumeSkill.toDictionary()`.
    public func toDictionary() -> [String: Any] {
        var dict: [String: Any] = ["body": body]
        if let id {
            dict["id"] = id
        }
        return dict
    }
}

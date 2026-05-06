import Foundation

/// Immutable aggregate entity representing the full resume.
public struct ResumeEntity: Sendable {
    /// Header section.
    public let head: ResumeHeadEntity
    /// Experience entries sorted by ascending id.
    public let experiences: [ResumeExperienceEntity]
    /// Education entries sorted by ascending id.
    public let educations: [ResumeEducationEntity]
    /// Skill sections sorted by ascending id.
    public let skills: [ResumeSkillEntity]
    /// Unique normalized tags extracted from experiences.
    public let tags: [String]

    /// Memberwise initialiser with legacy sorting and tag extraction rules.
    public init(
        head: ResumeHeadEntity,
        experiences: [ResumeExperienceEntity],
        educations: [ResumeEducationEntity],
        skills: [ResumeSkillEntity]
    ) {
        self.head = head
        self.experiences = experiences.sorted { ($0.id ?? 0) < ($1.id ?? 0) }
        self.educations = educations.sorted { ($0.id ?? 0) < ($1.id ?? 0) }
        self.skills = skills.sorted { ($0.id ?? 0) < ($1.id ?? 0) }

        let keywords = Set(Config.keywords.map { $0.lowercased() })
        let extractedTags = Set(experiences.flatMap(\.tags).map { $0.lowercased() }).subtracting(
            keywords)
        self.tags = Array(extractedTags).sorted()
    }

    /// Returns a template dictionary matching legacy `Resume.toDictionary()`.
    public func toDictionary() -> [String: Any] {
        [
            "head": head.toDictionary(),
            "experiences": experiences.map { $0.toDictionary() },
            "educations": educations.map { $0.toDictionary() },
            "skills": skills.map { $0.toDictionary() },
            "tags": tags,
        ]
    }
}

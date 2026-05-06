import Foundation

/// `ResumeContentRepository` implementation backed by Markdown files on disk.
public struct FileSystemResumeContentRepository: ResumeContentRepository {
    private let resumePath: String

    /// - Parameter resumePath: Absolute path to the resume content root directory.
    public init(resumePath: String) {
        self.resumePath = resumePath
    }

    // MARK: - ResumeContentRepository

    public func loadResume() throws -> ResumeEntity {
        let headData = try parseMarkdownFile("\(resumePath)/head/head.md")
        let head = ResumeMapper.toEntity(
            from: ResumeHeadDTO(from: headData, filePath: "\(resumePath)/head/head.md"))

        let experienceFiles = FileManager.default.getAllFiles(
            from: "\(resumePath)/experiences", withExtension: ".md")
        let experiences = try experienceFiles.map { fileURL in
            let rawData = try parseMarkdownFile(fileURL.path)
            let dto = ResumeExperienceDTO(from: rawData, filePath: fileURL.path)
            return try ResumeMapper.toEntity(from: dto)
        }

        let educationFiles = FileManager.default.getAllFiles(
            from: "\(resumePath)/educations", withExtension: ".md")
        let educations = try educationFiles.map { fileURL in
            let rawData = try parseMarkdownFile(fileURL.path)
            let dto = ResumeEducationDTO(from: rawData, filePath: fileURL.path)
            return try ResumeMapper.toEntity(from: dto)
        }

        let skillFiles = FileManager.default.getAllFiles(
            from: "\(resumePath)/skills", withExtension: ".md")
        let skills = try skillFiles.map { fileURL in
            let rawData = try parseMarkdownFile(fileURL.path)
            let dto = ResumeSkillDTO(from: rawData, filePath: fileURL.path)
            return ResumeMapper.toEntity(from: dto)
        }

        return ResumeEntity(
            head: head,
            experiences: experiences,
            educations: educations,
            skills: skills
        )
    }
}

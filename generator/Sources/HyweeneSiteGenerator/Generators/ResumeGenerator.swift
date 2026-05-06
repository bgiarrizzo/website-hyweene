import Foundation

/// Resume/CV content generator
public class ResumeGenerator: Generator {
    var resume: ResumeEntity?

    public init() {}

    // MARK: - Generator Protocol

    public func generate() throws {
        print("#", String(repeating: "-", count: 80))
        print("Processing resume...")

        let contentRepository = FileSystemResumeContentRepository(resumePath: Config.resumePath)
        let fileRepository = LocalFileRepository(basePath: Config.releasePath)
        let templateRepository = try StencilTemplateRepository(templatePath: Config.templatePath)

        let useCase = GenerateResumeUseCase(
            contentRepository: contentRepository,
            fileRepository: fileRepository,
            templateRepository: templateRepository
        )

        let result = try useCase.execute()
        self.resume = result.resume
    }
}

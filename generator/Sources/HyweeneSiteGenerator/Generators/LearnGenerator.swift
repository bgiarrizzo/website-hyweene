import Foundation

/// Learn modules content generator
public class LearnGenerator: Generator {
    /// Learning modules produced by the last `generate()` call.
    public var modules: [LearnModuleEntity] = []

    public init() {}

    // MARK: - Generator Protocol

    public func generate() throws {
        print("#", String(repeating: "-", count: 80))
        print("Processing learning modules...")
        let contentRepository = FileSystemLearnContentRepository(learnPath: Config.learnPath)
        let fileRepository = LocalFileRepository(basePath: Config.releasePath)
        let templateRepository = try StencilTemplateRepository(templatePath: Config.templatePath)

        let useCase = GenerateLearnUseCase(
            contentRepository: contentRepository,
            fileRepository: fileRepository,
            templateRepository: templateRepository
        )

        let result = try useCase.execute()
        self.modules = result.modules
    }
}

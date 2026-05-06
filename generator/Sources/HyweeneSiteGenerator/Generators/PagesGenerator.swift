import Foundation

/// Pages content generator (about, now, projets, etc.)
public class PagesGenerator: Generator {
    /// Pages produced by the last `generate()` call.
    public var pages: [PageEntity] = []

    public init() {}

    // MARK: - Generator Protocol

    public func generate() throws {
        print("#", String(repeating: "-", count: 80))
        print("Processing pages...")

        let contentRepository = FileSystemPageContentRepository(pagesPath: Config.pagesPath)
        let fileRepository = LocalFileRepository(basePath: Config.releasePath)
        let templateRepository = try StencilTemplateRepository(templatePath: Config.templatePath)

        let useCase = GeneratePagesUseCase(
            contentRepository: contentRepository,
            fileRepository: fileRepository,
            templateRepository: templateRepository
        )

        let result = try useCase.execute()
        self.pages = result.pages
    }
}

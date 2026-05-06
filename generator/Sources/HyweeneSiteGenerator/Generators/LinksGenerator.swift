import Foundation

/// Links content generator
public class LinksGenerator: Generator {
    /// Links produced by the last `generate()` call.
    public var links: [LinkItemEntity] = []

    public init() {}

    // MARK: - Generator Protocol

    public func generate() throws {
        print("#", String(repeating: "-", count: 80))
        print("Generating links...")

        let contentRepository = FileSystemLinkContentRepository(linksPath: Config.linksPath)
        let fileRepository = LocalFileRepository(basePath: Config.releasePath)
        let templateRepository = try StencilTemplateRepository(templatePath: Config.templatePath)

        let useCase = GenerateLinksUseCase(
            contentRepository: contentRepository,
            fileRepository: fileRepository,
            templateRepository: templateRepository
        )

        let result = try useCase.execute()
        self.links = result.links
    }
}

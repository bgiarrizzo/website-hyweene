import Foundation

/// `PageContentRepository` implementation backed by Markdown files on disk.
public struct FileSystemPageContentRepository: PageContentRepository {
    private let pagesPath: String

    /// - Parameter pagesPath: Absolute path to the pages Markdown source directory.
    public init(pagesPath: String) {
        self.pagesPath = pagesPath
    }

    // MARK: - PageContentRepository

    public func loadPages() throws -> [PageEntity] {
        let fileURLs = FileManager.default.getAllFiles(from: pagesPath, withExtension: ".md")
        var entities: [PageEntity] = []

        for fileURL in fileURLs {
            let rawData = try parseMarkdownFile(fileURL.path)
            let dto = PageDTO(from: rawData, filePath: fileURL.path)
            let entity = try PageMapper.toEntity(from: dto)
            entities.append(entity)
        }

        return entities
    }
}

import Foundation

/// `LinkContentRepository` implementation that loads links from the file system.
public struct FileSystemLinkContentRepository: LinkContentRepository {
    private let linksPath: String

    /// - Parameter linksPath: Absolute path to links Markdown files.
    public init(linksPath: String) {
        self.linksPath = linksPath
    }

    // MARK: - LinkContentRepository

    public func loadLinks() throws -> [LinkItemEntity] {
        let fileURLs = FileManager.default.getAllFiles(from: linksPath, withExtension: ".md")
        var entities: [LinkItemEntity] = []

        for fileURL in fileURLs {
            let rawData = try parseMarkdownFile(fileURL.path)
            let dto = LinkItemDTO(from: rawData, filePath: fileURL.path)
            let entity = try LinkItemMapper.toEntity(from: dto)
            entities.append(entity)
        }

        return entities.sorted { $0.publishDate.original > $1.publishDate.original }
    }
}

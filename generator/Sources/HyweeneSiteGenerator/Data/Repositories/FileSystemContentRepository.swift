import Foundation

/// `ContentRepository` implementation that loads blog posts from the file system.
///
/// Files under a `draft/` sub-directory are skipped as a file-system-level optimisation.
/// Draft status from frontmatter is preserved in the entity for domain-level filtering.
public struct FileSystemContentRepository: ContentRepository {
    private let blogPath: String

    /// - Parameter blogPath: Absolute path to the blog Markdown source directory.
    public init(blogPath: String) {
        self.blogPath = blogPath
    }

    // MARK: - ContentRepository

    public func loadBlogPosts() throws -> [BlogPostEntity] {
        let fileURLs = FileManager.default.getAllFiles(from: blogPath, withExtension: ".md")
        var entities: [BlogPostEntity] = []

        for fileURL in fileURLs {
            // Skip the `draft/` folder as a fast path; draft posts are otherwise
            // identified by the `draft: true` frontmatter field.
            guard !fileURL.path.contains("/draft/") else { continue }

            let rawData = try parseMarkdownFile(fileURL.path)
            let dto = BlogPostDTO(from: rawData, filePath: fileURL.path)
            let entity = try BlogPostMapper.toEntity(from: dto)
            entities.append(entity)
        }

        return entities.sorted { $0.publishDate.original > $1.publishDate.original }
    }
}

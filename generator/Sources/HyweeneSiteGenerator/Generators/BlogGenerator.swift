import Foundation

/// Blog content generator.
///
/// Delegates generation to `GenerateBlogUseCase` and stores the result
/// for use by `HomepageGenerator` until that generator is also migrated.
public class BlogGenerator: Generator {
    /// Non-draft posts produced by the last `generate()` call.
    public private(set) var posts: [BlogPostEntity] = []
    /// Unique categories extracted from `posts`.
    public private(set) var categories: [BlogPostCategory] = []

    public init() {}

    // MARK: - Generator Protocol

    public func generate() throws {
        print("#", String(repeating: "-", count: 80))
        print("Processing blog data...")

        let contentRepo = FileSystemContentRepository(blogPath: Config.blogPath)
        let fileRepo = LocalFileRepository(basePath: Config.releasePath)
        let templateRepo = try StencilTemplateRepository(templatePath: Config.templatePath)

        let result = try GenerateBlogUseCase(
            contentRepository: contentRepo,
            fileRepository: fileRepo,
            templateRepository: templateRepo
        ).execute()

        self.posts = result.posts
        self.categories = result.categories
    }
}

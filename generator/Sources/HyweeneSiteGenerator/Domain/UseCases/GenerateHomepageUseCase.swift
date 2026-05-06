/// Domain use case that renders the homepage from already-generated content.
public struct GenerateHomepageUseCase: Sendable {
    private let fileRepository: any FileRepository
    private let templateRepository: any TemplateRepository

    /// - Parameters:
    ///   - fileRepository: Sink for rendered homepage HTML.
    ///   - templateRepository: Renderer for Stencil templates.
    public init(
        fileRepository: any FileRepository,
        templateRepository: any TemplateRepository
    ) {
        self.fileRepository = fileRepository
        self.templateRepository = templateRepository
    }

    // MARK: - Execution

    /// Render and write the homepage using the latest generated posts and links.
    ///
    /// - Parameters:
    ///   - posts: Blog posts sorted newest-first.
    ///   - links: Link items sorted newest-first.
    /// - Throws: Any template-rendering or file-writing error.
    public nonisolated func execute(
        posts: [BlogPostEntity],
        links: [LinkItemEntity]
    ) throws {
        let latestPosts = Array(posts.prefix(10))
        let latestLinks = Array(links.prefix(10))

        let context: [String: Any] = [
            "page_title": Config.name,
            "latest_posts": latestPosts.map { $0.toDictionary() },
            "latest_links": latestLinks.map { $0.toDictionary() },
        ]

        let html = try templateRepository.render(template: "homepage.stencil", context: context)
        try fileRepository.writeFile(content: html, to: "index.html")
        print("🏠 Writing homepage: index.html")
    }
}

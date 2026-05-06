/// Domain use case that orchestrates the static pages generation pipeline.
public struct GeneratePagesUseCase: Sendable {
    private let contentRepository: any PageContentRepository
    private let fileRepository: any FileRepository
    private let templateRepository: any TemplateRepository

    /// - Parameters:
    ///   - contentRepository: Source of validated `PageEntity` values.
    ///   - fileRepository: Sink for rendered HTML/XML output.
    ///   - templateRepository: Renderer for Stencil templates.
    public init(
        contentRepository: any PageContentRepository,
        fileRepository: any FileRepository,
        templateRepository: any TemplateRepository
    ) {
        self.contentRepository = contentRepository
        self.fileRepository = fileRepository
        self.templateRepository = templateRepository
    }

    // MARK: - Execution

    /// Run the full pages generation pipeline and return a result summary.
    @discardableResult
    public nonisolated func execute() throws -> BuildPagesResult {
        let pages = try contentRepository.loadPages()

        try writePages(pages)
        try writeSitemap(pages)

        print("✅ Pages generation complete! (\(pages.count) pages)")
        return BuildPagesResult(pages: pages)
    }

    // MARK: - Individual Pages

    private func writePages(_ pages: [PageEntity]) throws {
        try runConcurrently(
            operations: pages.map { page in
                {
                    let context: [String: Any] = [
                        "page_title": page.title,
                        "page": page.toDictionary(),
                    ]
                    let html = try self.templateRepository.render(
                        template: "page/main.stencil", context: context)
                    let outputPath =
                        page.permalink.isEmpty ? "index.html" : "\(page.permalink)/index.html"
                    try self.fileRepository.writeFile(content: html, to: outputPath)
                    if page.permalink.isEmpty {
                        print("📄 Writing homepage: \(page.title)")
                    } else {
                        print("📄 Writing page: \(page.slug)")
                    }
                }
            })
    }

    // MARK: - Sitemap

    private func writeSitemap(_ pages: [PageEntity]) throws {
        let context: [String: Any] = [
            "pages": pages.map { $0.toDictionary() }
        ]
        let xml = try templateRepository.render(template: "page/sitemap.xml", context: context)
        try fileRepository.writeFile(content: xml, to: "sitemap-pages.xml")
        print("🗺️  Writing pages sitemap: sitemap-pages.xml")
    }
}

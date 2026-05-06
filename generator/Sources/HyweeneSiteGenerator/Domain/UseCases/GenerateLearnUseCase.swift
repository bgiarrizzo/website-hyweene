/// Domain use case that orchestrates the learning modules generation pipeline.
public struct GenerateLearnUseCase: Sendable {
    private let contentRepository: any LearnContentRepository
    private let fileRepository: any FileRepository
    private let templateRepository: any TemplateRepository

    /// - Parameters:
    ///   - contentRepository: Source of validated learning modules.
    ///   - fileRepository: Sink for rendered HTML/XML output.
    ///   - templateRepository: Renderer for Stencil templates.
    public init(
        contentRepository: any LearnContentRepository,
        fileRepository: any FileRepository,
        templateRepository: any TemplateRepository
    ) {
        self.contentRepository = contentRepository
        self.fileRepository = fileRepository
        self.templateRepository = templateRepository
    }

    // MARK: - Execution

    /// Run the full learning modules generation pipeline and return a result summary.
    @discardableResult
    public nonisolated func execute() throws -> BuildLearnResult {
        let modules = try contentRepository.loadModules()

        try writeModulePages(modules)
        try writeModulesList(modules)
        try writeSitemap(modules)

        print("✅ Learning modules generation complete! (\(modules.count) modules)")
        return BuildLearnResult(modules: modules)
    }

    private func writeModulePages(_ modules: [LearnModuleEntity]) throws {
        try runConcurrently(
            operations: modules.map { module in
                {
                    try self.writeTableOfContents(for: module)
                    try runConcurrently(
                        operations: module.pages.map { page in
                            {
                                let context: [String: Any] = [
                                    "learn": page.toDictionary(module: module)
                                ]
                                let html = try self.templateRepository.render(
                                    template: "learn/page.stencil",
                                    context: context
                                )
                                let outputPath = "apprendre/\(module.slug)/\(page.slug)/index.html"
                                try self.fileRepository.writeFile(content: html, to: outputPath)
                                print("📚 Writing learning page: \(outputPath)")
                            }
                        })
                }
            })
    }

    private func writeTableOfContents(for module: LearnModuleEntity) throws {
        let context: [String: Any] = [
            "module": module.toDictionary()
        ]
        let html = try templateRepository.render(template: "learn/toc.stencil", context: context)
        let outputPath = "apprendre/\(module.slug)/index.html"
        try fileRepository.writeFile(content: html, to: outputPath)
        print("📖 Writing learning module TOC: \(outputPath)")
    }

    private func writeModulesList(_ modules: [LearnModuleEntity]) throws {
        let context: [String: Any] = [
            "page_title": "Table des matières - Apprendre",
            "table_of_contents": modules.map { $0.toDictionary() },
        ]
        let html = try templateRepository.render(template: "learn/list.stencil", context: context)
        try fileRepository.writeFile(content: html, to: "apprendre/index.html")
        print("📋 Writing modules list: apprendre/index.html")
    }

    private func writeSitemap(_ modules: [LearnModuleEntity]) throws {
        let context: [String: Any] = [
            "modules": modules.map { $0.toDictionary() }
        ]
        let xml = try templateRepository.render(template: "learn/sitemap.xml", context: context)
        try fileRepository.writeFile(content: xml, to: "apprendre/sitemap.xml")
        print("🗺️  Writing learning sitemap: apprendre/sitemap.xml")
    }
}

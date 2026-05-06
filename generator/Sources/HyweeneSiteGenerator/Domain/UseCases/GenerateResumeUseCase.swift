/// Domain use case that orchestrates resume generation.
public struct GenerateResumeUseCase: Sendable {
    private let contentRepository: any ResumeContentRepository
    private let fileRepository: any FileRepository
    private let templateRepository: any TemplateRepository

    /// - Parameters:
    ///   - contentRepository: Source of a validated resume aggregate.
    ///   - fileRepository: Sink for rendered HTML output.
    ///   - templateRepository: Renderer for Stencil templates.
    public init(
        contentRepository: any ResumeContentRepository,
        fileRepository: any FileRepository,
        templateRepository: any TemplateRepository
    ) {
        self.contentRepository = contentRepository
        self.fileRepository = fileRepository
        self.templateRepository = templateRepository
    }

    // MARK: - Execution

    /// Run the resume generation pipeline and return the generated aggregate.
    @discardableResult
    public nonisolated func execute() throws -> BuildResumeResult {
        let resume = try contentRepository.loadResume()
        let context: [String: Any] = [
            "page_title": "Bruno Giarrizzo - CV",
            "resume": resume.toDictionary(),
        ]
        let html = try templateRepository.render(template: "resume/main.stencil", context: context)
        try fileRepository.writeFile(content: html, to: "cv/index.html")
        print("💼 Writing resume: cv/index.html")
        print("✅ Resume generation complete!")
        return BuildResumeResult(resume: resume)
    }
}

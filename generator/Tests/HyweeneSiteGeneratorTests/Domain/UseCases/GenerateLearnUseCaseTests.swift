import Foundation
import Testing

@testable import HyweeneSiteGenerator

final class MockLearnContentRepository: LearnContentRepository, @unchecked Sendable {
    var modulesToReturn: [LearnModuleEntity] = []
    var errorToThrow: Error?

    func loadModules() throws -> [LearnModuleEntity] {
        if let errorToThrow { throw errorToThrow }
        return modulesToReturn
    }
}

final class MockLearnFileRepository: FileRepository, @unchecked Sendable {
    private let lock = NSLock()
    var written: [String: String] = [:]
    var errorToThrow: Error?

    func writeFile(content: String, to relativePath: String) throws {
        if let errorToThrow { throw errorToThrow }
        lock.lock()
        defer { lock.unlock() }
        written[relativePath] = content
    }
}

final class MockLearnTemplateRepository: TemplateRepository, @unchecked Sendable {
    private let lock = NSLock()
    var stub = "<html/>"
    var errorToThrow: Error?
    var rendered: [(template: String, context: [String: Any])] = []

    func render(template: String, context: [String: Any]) throws -> String {
        if let errorToThrow { throw errorToThrow }
        lock.lock()
        defer { lock.unlock() }
        rendered.append((template: template, context: context))
        return stub
    }
}

struct GenerateLearnUseCaseTests {
    private func makeModule() -> LearnModuleEntity {
        LearnModuleEntity(
            id: 1,
            name: "Git",
            slug: "git",
            logo: nil,
            description: "desc",
            disabled: false,
            pages: [
                LearnModulePageEntity(
                    id: 1,
                    title: "Intro",
                    slug: "intro",
                    summary: "summary",
                    tags: ["git"],
                    publishDate: DateFormat(),
                    updateDate: DateFormat(),
                    toc: "",
                    body: "body",
                    prismNeeded: false,
                    disabled: false
                )
            ]
        )
    }

    @Test("execute writes module toc, page, list, and sitemap")
    func writesAllLearnOutputs() throws {
        let content = MockLearnContentRepository()
        content.modulesToReturn = [makeModule()]
        let file = MockLearnFileRepository()
        let template = MockLearnTemplateRepository()
        let useCase = GenerateLearnUseCase(
            contentRepository: content,
            fileRepository: file,
            templateRepository: template
        )

        let result = try useCase.execute()

        #expect(result.modules.count == 1)
        #expect(file.written["apprendre/git/index.html"] != nil)
        #expect(file.written["apprendre/git/intro/index.html"] != nil)
        #expect(file.written["apprendre/index.html"] != nil)
        #expect(file.written["apprendre/sitemap.xml"] != nil)
    }

    @Test("execute rethrows content repository errors")
    func rethrowsContentError() {
        enum E: Error { case boom }
        let content = MockLearnContentRepository()
        content.errorToThrow = E.boom
        let useCase = GenerateLearnUseCase(
            contentRepository: content,
            fileRepository: MockLearnFileRepository(),
            templateRepository: MockLearnTemplateRepository()
        )

        #expect(throws: E.self) {
            try useCase.execute()
        }
    }

    @Test("execute rethrows file repository errors")
    func rethrowsFileError() {
        enum E: Error { case boom }
        let content = MockLearnContentRepository()
        content.modulesToReturn = [makeModule()]
        let file = MockLearnFileRepository()
        file.errorToThrow = E.boom
        let useCase = GenerateLearnUseCase(
            contentRepository: content,
            fileRepository: file,
            templateRepository: MockLearnTemplateRepository()
        )

        #expect(throws: Error.self) {
            try useCase.execute()
        }
    }
}
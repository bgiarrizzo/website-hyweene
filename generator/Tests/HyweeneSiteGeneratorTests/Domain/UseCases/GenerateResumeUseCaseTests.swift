import Foundation
import Testing

@testable import HyweeneSiteGenerator

final class MockResumeContentRepository: ResumeContentRepository, @unchecked Sendable {
    var resumeToReturn = ResumeEntity(
        head: ResumeHeadEntity(body: "head"), experiences: [], educations: [], skills: [])
    var errorToThrow: Error?

    func loadResume() throws -> ResumeEntity {
        if let error = errorToThrow { throw error }
        return resumeToReturn
    }
}

final class MockResumeFileRepository: FileRepository, @unchecked Sendable {
    private let lock = NSLock()
    var written: [String: String] = [:]
    var errorToThrow: Error?

    func writeFile(content: String, to relativePath: String) throws {
        if let error = errorToThrow { throw error }
        lock.lock()
        defer { lock.unlock() }
        written[relativePath] = content
    }
}

final class MockResumeTemplateRepository: TemplateRepository, @unchecked Sendable {
    private let lock = NSLock()
    var stub: String = "<html/>"
    var errorToThrow: Error?
    var rendered: [(template: String, context: [String: Any])] = []

    func render(template: String, context: [String: Any]) throws -> String {
        if let error = errorToThrow { throw error }
        lock.lock()
        defer { lock.unlock() }
        rendered.append((template: template, context: context))
        return stub
    }
}

struct GenerateResumeUseCaseTests {
    @Test("execute writes resume file")
    func writesResumeFile() throws {
        let contentRepository = MockResumeContentRepository()
        let fileRepository = MockResumeFileRepository()
        let templateRepository = MockResumeTemplateRepository()
        let useCase = GenerateResumeUseCase(
            contentRepository: contentRepository,
            fileRepository: fileRepository,
            templateRepository: templateRepository
        )

        let result = try useCase.execute()

        #expect(fileRepository.written["cv/index.html"] != nil)
        #expect(templateRepository.rendered.first?.template == "resume/main.stencil")
        #expect(result.resume.head.body == "head")
    }

    @Test("execute rethrows content repository errors")
    func rethrowsContentError() {
        enum E: Error { case boom }
        let contentRepository = MockResumeContentRepository()
        contentRepository.errorToThrow = E.boom
        let useCase = GenerateResumeUseCase(
            contentRepository: contentRepository,
            fileRepository: MockResumeFileRepository(),
            templateRepository: MockResumeTemplateRepository()
        )

        #expect(throws: E.self) {
            try useCase.execute()
        }
    }

    @Test("execute rethrows file repository errors")
    func rethrowsFileError() {
        enum E: Error { case boom }
        let fileRepository = MockResumeFileRepository()
        fileRepository.errorToThrow = E.boom
        let useCase = GenerateResumeUseCase(
            contentRepository: MockResumeContentRepository(),
            fileRepository: fileRepository,
            templateRepository: MockResumeTemplateRepository()
        )

        #expect(throws: Error.self) {
            try useCase.execute()
        }
    }
}

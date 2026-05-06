import Foundation
import Testing

@testable import HyweeneSiteGenerator

final class MockPageContentRepository: PageContentRepository, @unchecked Sendable {
    var pagesToReturn: [PageEntity] = []
    var errorToThrow: Error?

    func loadPages() throws -> [PageEntity] {
        if let error = errorToThrow { throw error }
        return pagesToReturn
    }
}

final class MockPageFileRepository: FileRepository, @unchecked Sendable {
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

final class MockPageTemplateRepository: TemplateRepository, @unchecked Sendable {
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

struct GeneratePagesUseCaseTests {
    private func makeEntity(
        title: String = "About",
        permalink: String = "about",
        slug: String = "about"
    ) -> PageEntity {
        PageEntity(
            title: title,
            body: "body",
            permalink: permalink,
            slug: slug,
            summary: "summary",
            cover: nil
        )
    }

    private func makeUseCase(
        pages: [PageEntity] = [],
        contentError: Error? = nil,
        fileError: Error? = nil,
        templateError: Error? = nil
    ) -> (
        useCase: GeneratePagesUseCase,
        content: MockPageContentRepository,
        file: MockPageFileRepository,
        template: MockPageTemplateRepository
    ) {
        let content = MockPageContentRepository()
        content.pagesToReturn = pages
        content.errorToThrow = contentError

        let file = MockPageFileRepository()
        file.errorToThrow = fileError

        let template = MockPageTemplateRepository()
        template.errorToThrow = templateError

        let useCase = GeneratePagesUseCase(
            contentRepository: content,
            fileRepository: file,
            templateRepository: template
        )
        return (useCase, content, file, template)
    }

    @Test("execute writes individual page for each permalink page")
    func writesIndividualPages() throws {
        let pages = [
            makeEntity(title: "About", permalink: "about", slug: "about"),
            makeEntity(title: "Now", permalink: "now", slug: "now"),
        ]
        let (useCase, _, file, _) = makeUseCase(pages: pages)

        try useCase.execute()

        #expect(file.written["about/index.html"] != nil)
        #expect(file.written["now/index.html"] != nil)
    }

    @Test("execute writes homepage at root when permalink is empty")
    func writesHomepageAtRoot() throws {
        let (useCase, _, file, _) = makeUseCase(pages: [
            makeEntity(title: "Home", permalink: "", slug: "home")
        ])

        try useCase.execute()

        #expect(file.written["index.html"] != nil)
    }

    @Test("execute writes sitemap")
    func writesSitemap() throws {
        let (useCase, _, file, _) = makeUseCase(pages: [makeEntity()])

        try useCase.execute()

        #expect(file.written["sitemap-pages.xml"] != nil)
    }

    @Test("execute rethrows content repository error")
    func rethrowsContentError() {
        enum E: Error { case boom }
        let (useCase, _, _, _) = makeUseCase(contentError: E.boom)

        #expect(throws: E.self) {
            try useCase.execute()
        }
    }

    @Test("execute rethrows file repository error")
    func rethrowsFileError() {
        enum E: Error { case boom }
        let (useCase, _, _, _) = makeUseCase(pages: [makeEntity()], fileError: E.boom)

        #expect(throws: Error.self) {
            try useCase.execute()
        }
    }

    @Test("execute returns pages from repository")
    func returnsPages() throws {
        let pages = [
            makeEntity(title: "About"), makeEntity(title: "Now", permalink: "now", slug: "now"),
        ]
        let (useCase, _, _, _) = makeUseCase(pages: pages)

        let result = try useCase.execute()

        #expect(result.pages.count == 2)
        #expect(result.pages.first?.title == "About")
    }
}

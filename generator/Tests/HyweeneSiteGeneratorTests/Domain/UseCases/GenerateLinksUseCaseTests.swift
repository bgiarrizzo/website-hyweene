import Foundation
import Testing

@testable import HyweeneSiteGenerator

// MARK: - Mock Implementations

/// Controllable `LinkContentRepository` for use-case tests.
final class MockLinkContentRepository: LinkContentRepository, @unchecked Sendable {
    var linksToReturn: [LinkItemEntity] = []
    var errorToThrow: Error?

    func loadLinks() throws -> [LinkItemEntity] {
        if let error = errorToThrow { throw error }
        return linksToReturn
    }
}

/// Controllable `FileRepository` that records all writes.
final class MockLinkFileRepository: FileRepository, @unchecked Sendable {
    var written: [String: String] = [:]
    var errorToThrow: Error?

    func writeFile(content: String, to relativePath: String) throws {
        if let error = errorToThrow { throw error }
        written[relativePath] = content
    }
}

/// Controllable `TemplateRepository` that returns stub output.
final class MockLinkTemplateRepository: TemplateRepository, @unchecked Sendable {
    var stub: String = "<html/>"
    var errorToThrow: Error?
    var rendered: [(template: String, context: [String: Any])] = []

    func render(template: String, context: [String: Any]) throws -> String {
        if let error = errorToThrow { throw error }
        rendered.append((template: template, context: context))
        return stub
    }
}

struct GenerateLinksUseCaseTests {
    private func makeEntity(
        title: String = "A link",
        path: String = "2026-05-01-a-link",
        url: String = "https://example.com/a",
        publishDate: Date = Date(timeIntervalSince1970: 1_700_000_000)
    ) -> LinkItemEntity {
        LinkItemEntity(
            title: title,
            url: url,
            path: path,
            description: "desc",
            publishDate: DateFormat(publishDate),
            updateDate: nil,
            body: "body",
            slug: slugify(title)
        )
    }

    private func makeUseCase(
        links: [LinkItemEntity] = [],
        contentError: Error? = nil,
        fileError: Error? = nil,
        templateError: Error? = nil
    ) -> (
        useCase: GenerateLinksUseCase,
        content: MockLinkContentRepository,
        file: MockLinkFileRepository,
        template: MockLinkTemplateRepository
    ) {
        let content = MockLinkContentRepository()
        content.linksToReturn = links
        content.errorToThrow = contentError

        let file = MockLinkFileRepository()
        file.errorToThrow = fileError

        let template = MockLinkTemplateRepository()
        template.errorToThrow = templateError

        let useCase = GenerateLinksUseCase(
            contentRepository: content,
            fileRepository: file,
            templateRepository: template
        )
        return (useCase, content, file, template)
    }

    @Test("execute writes individual page for each link")
    func writesIndividualPages() throws {
        let links = [
            makeEntity(path: "2026-05-01-a"),
            makeEntity(path: "2026-05-02-b"),
        ]
        let (useCase, _, file, _) = makeUseCase(links: links)

        try useCase.execute()

        #expect(file.written["liens/2026-05-01-a/index.html"] != nil)
        #expect(file.written["liens/2026-05-02-b/index.html"] != nil)
    }

    @Test("execute writes list page, feed, and sitemap")
    func writesAggregateFiles() throws {
        let (useCase, _, file, _) = makeUseCase(links: [makeEntity()])

        try useCase.execute()

        #expect(file.written["liens/index.html"] != nil)
        #expect(file.written["liens/feed.xml"] != nil)
        #expect(file.written["liens/sitemap.xml"] != nil)
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
        let (useCase, _, _, _) = makeUseCase(links: [makeEntity()], fileError: E.boom)

        #expect(throws: Error.self) {
            try useCase.execute()
        }
    }

    @Test("execute returns links sorted by repository contract")
    func returnsLinksFromRepository() throws {
        let links = [
            makeEntity(title: "New", path: "2026-05-02-new"),
            makeEntity(title: "Old", path: "2026-05-01-old"),
        ]
        let (useCase, _, _, _) = makeUseCase(links: links)

        let result = try useCase.execute()

        #expect(result.links.count == 2)
        #expect(result.links[0].title == "New")
    }

    @Test("execute returns empty result when no links")
    func returnsEmptyResult() throws {
        let (useCase, _, _, _) = makeUseCase(links: [])

        let result = try useCase.execute()

        #expect(result.links.isEmpty)
    }
}

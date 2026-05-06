import Foundation
import Testing

@testable import HyweeneSiteGenerator

final class MockHomepageFileRepository: FileRepository, @unchecked Sendable {
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

final class MockHomepageTemplateRepository: TemplateRepository, @unchecked Sendable {
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

struct GenerateHomepageUseCaseTests {
    private func makePost(title: String) -> BlogPostEntity {
        let date = DateFormat(Date(timeIntervalSince1970: 1_700_000_000))
        return BlogPostEntity(
            title: title,
            slug: slugify(title),
            body: "body",
            summary: "summary",
            publishDate: date,
            updateDate: date,
            category: BlogPostCategory(name: "Swift"),
            tags: [],
            readingTime: 1,
            path: "\(date.short)-\(slugify(title))",
            prismNeeded: false,
            cover: nil,
            draft: false,
            tocHTML: nil
        )
    }

    private func makeLink(title: String) -> LinkItemEntity {
        let date = DateFormat(Date(timeIntervalSince1970: 1_700_000_000))
        return LinkItemEntity(
            title: title,
            url: "https://example.com/\(slugify(title))",
            path: "\(date.short)-\(slugify(title))",
            description: "desc",
            publishDate: date,
            updateDate: nil,
            body: "body",
            slug: slugify(title)
        )
    }

    @Test("execute writes homepage file")
    func writesHomepageFile() throws {
        let fileRepository = MockHomepageFileRepository()
        let templateRepository = MockHomepageTemplateRepository()
        let useCase = GenerateHomepageUseCase(
            fileRepository: fileRepository,
            templateRepository: templateRepository
        )

        try useCase.execute(posts: [makePost(title: "Post")], links: [makeLink(title: "Link")])

        #expect(fileRepository.written["index.html"] != nil)
        #expect(templateRepository.rendered.first?.template == "homepage.stencil")
    }

    @Test("execute limits homepage content to 10 items per section")
    func limitsHomepageContent() throws {
        let fileRepository = MockHomepageFileRepository()
        let templateRepository = MockHomepageTemplateRepository()
        let useCase = GenerateHomepageUseCase(
            fileRepository: fileRepository,
            templateRepository: templateRepository
        )

        let posts = (1...12).map { makePost(title: "Post \($0)") }
        let links = (1...15).map { makeLink(title: "Link \($0)") }

        try useCase.execute(posts: posts, links: links)

        let context = try #require(templateRepository.rendered.first?.context)
        let latestPosts = try #require(context["latest_posts"] as? [[String: Any]])
        let latestLinks = try #require(context["latest_links"] as? [[String: Any]])

        #expect(latestPosts.count == 10)
        #expect(latestLinks.count == 10)
    }

    @Test("execute rethrows template repository errors")
    func rethrowsTemplateError() {
        enum E: Error { case boom }
        let fileRepository = MockHomepageFileRepository()
        let templateRepository = MockHomepageTemplateRepository()
        templateRepository.errorToThrow = E.boom
        let useCase = GenerateHomepageUseCase(
            fileRepository: fileRepository,
            templateRepository: templateRepository
        )

        #expect(throws: E.self) {
            try useCase.execute(posts: [], links: [])
        }
    }

    @Test("execute rethrows file repository errors")
    func rethrowsFileError() {
        enum E: Error { case boom }
        let fileRepository = MockHomepageFileRepository()
        fileRepository.errorToThrow = E.boom
        let templateRepository = MockHomepageTemplateRepository()
        let useCase = GenerateHomepageUseCase(
            fileRepository: fileRepository,
            templateRepository: templateRepository
        )

        #expect(throws: Error.self) {
            try useCase.execute(posts: [makePost(title: "Post")], links: [makeLink(title: "Link")])
        }
    }
}

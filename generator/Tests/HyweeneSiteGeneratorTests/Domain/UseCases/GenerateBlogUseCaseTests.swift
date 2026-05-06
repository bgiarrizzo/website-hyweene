import Foundation
import Testing

@testable import HyweeneSiteGenerator

// MARK: - Mock Implementations

/// Controllable `ContentRepository` for use-case tests.
final class MockContentRepository: ContentRepository, @unchecked Sendable {
    var postsToReturn: [BlogPostEntity] = []
    var errorToThrow: Error?

    func loadBlogPosts() throws -> [BlogPostEntity] {
        if let error = errorToThrow { throw error }
        return postsToReturn
    }
}

/// Controllable `FileRepository` that records all writes.
final class MockFileRepository: FileRepository, @unchecked Sendable {
    var written: [String: String] = [:]  // relativePath → content
    var errorToThrow: Error?

    func writeFile(content: String, to relativePath: String) throws {
        if let error = errorToThrow { throw error }
        written[relativePath] = content
    }
}

/// Controllable `TemplateRepository` that returns stub HTML.
final class MockTemplateRepository: TemplateRepository, @unchecked Sendable {
    var stub: String = "<html/>"
    var errorToThrow: Error?
    var rendered: [(template: String, context: [String: Any])] = []

    func render(template: String, context: [String: Any]) throws -> String {
        if let error = errorToThrow { throw error }
        rendered.append((template: template, context: context))
        return stub
    }
}

// MARK: - GenerateBlogUseCaseTests

struct GenerateBlogUseCaseTests {
    // MARK: - Helpers

    private func makeEntity(
        title: String = "Post",
        slug: String = "post",
        path: String = "2024-01-01-post",
        categoryName: String = "Swift",
        draft: Bool = false
    ) -> BlogPostEntity {
        let date = DateFormat(Date(timeIntervalSince1970: 1_700_000_000))
        return BlogPostEntity(
            title: title,
            slug: slug,
            body: "body",
            summary: "summary",
            publishDate: date,
            updateDate: date,
            category: BlogPostCategory(name: categoryName),
            tags: [],
            readingTime: 1,
            path: path,
            prismNeeded: false,
            cover: nil,
            draft: draft,
            tocHTML: nil
        )
    }

    private func makeUseCase(
        posts: [BlogPostEntity] = [],
        contentError: Error? = nil,
        fileError: Error? = nil,
        templateError: Error? = nil
    ) -> (
        useCase: GenerateBlogUseCase,
        content: MockContentRepository,
        file: MockFileRepository,
        template: MockTemplateRepository
    ) {
        let content = MockContentRepository()
        content.postsToReturn = posts
        content.errorToThrow = contentError

        let file = MockFileRepository()
        file.errorToThrow = fileError

        let template = MockTemplateRepository()
        template.errorToThrow = templateError

        let useCase = GenerateBlogUseCase(
            contentRepository: content,
            fileRepository: file,
            templateRepository: template
        )
        return (useCase, content, file, template)
    }

    // MARK: - Output Files

    @Test("execute writes individual post file for each non-draft post")
    func writesIndividualPostFiles() throws {
        let posts = [
            makeEntity(path: "2024-01-01-alpha"),
            makeEntity(path: "2024-01-02-beta"),
        ]
        let (useCase, _, file, _) = makeUseCase(posts: posts)

        try useCase.execute()

        #expect(file.written["blog/2024-01-01-alpha/index.html"] != nil)
        #expect(file.written["blog/2024-01-02-beta/index.html"] != nil)
    }

    @Test("execute writes blog list file")
    func writesBlogListFile() throws {
        let (useCase, _, file, _) = makeUseCase(posts: [makeEntity()])
        try useCase.execute()
        #expect(file.written["blog/index.html"] != nil)
    }

    @Test("execute writes RSS feed")
    func writesRSSFeed() throws {
        let (useCase, _, file, _) = makeUseCase(posts: [makeEntity()])
        try useCase.execute()
        #expect(file.written["blog/feed.xml"] != nil)
    }

    @Test("execute writes sitemap")
    func writesSitemap() throws {
        let (useCase, _, file, _) = makeUseCase(posts: [makeEntity()])
        try useCase.execute()
        #expect(file.written["blog/sitemap.xml"] != nil)
    }

    @Test("execute writes category page for each unique category")
    func writesCategoryPage() throws {
        let posts = [
            makeEntity(path: "2024-01-01-a", categoryName: "Swift"),
            makeEntity(path: "2024-01-02-b", categoryName: "Swift"),
            makeEntity(path: "2024-01-03-c", categoryName: "iOS"),
        ]
        let (useCase, _, file, _) = makeUseCase(posts: posts)
        try useCase.execute()

        #expect(file.written["blog/category/swift/index.html"] != nil)
        #expect(file.written["blog/category/ios/index.html"] != nil)
    }

    // MARK: - Draft Filtering

    @Test("execute excludes draft posts from output files")
    func excludesDraftPosts() throws {
        let posts = [
            makeEntity(path: "2024-01-01-pub", draft: false),
            makeEntity(path: "2024-01-02-draft", draft: true),
        ]
        let (useCase, _, file, _) = makeUseCase(posts: posts)
        try useCase.execute()

        #expect(file.written["blog/2024-01-01-pub/index.html"] != nil)
        #expect(file.written["blog/2024-01-02-draft/index.html"] == nil)
    }

    @Test("execute returns only non-draft posts in result")
    func returnsOnlyNonDraftPostsInResult() throws {
        let posts = [
            makeEntity(draft: false),
            makeEntity(draft: true),
        ]
        let (useCase, _, _, _) = makeUseCase(posts: posts)
        let result = try useCase.execute()
        #expect(result.posts.count == 1)
        #expect(result.posts.first?.draft == false)
    }

    // MARK: - Error Propagation

    @Test("execute rethrows content repository error")
    func rethrowsContentRepositoryError() {
        enum E: Error { case boom }
        let (useCase, _, _, _) = makeUseCase(contentError: E.boom)
        #expect(throws: E.self) {
            try useCase.execute()
        }
    }

    @Test("execute rethrows file repository error")
    func rethrowsFileRepositoryError() {
        enum E: Error { case boom }
        let (useCase, _, _, _) = makeUseCase(
            posts: [makeEntity()],
            fileError: E.boom
        )
        #expect(throws: Error.self) {
            try useCase.execute()
        }
    }

    // MARK: - Result

    @Test("execute returns correct category count")
    func returnsCorrectCategoryCount() throws {
        let posts = [
            makeEntity(categoryName: "Swift"),
            makeEntity(categoryName: "iOS"),
            makeEntity(categoryName: "Swift"),
        ]
        let (useCase, _, _, _) = makeUseCase(posts: posts)
        let result = try useCase.execute()
        #expect(result.categories.count == 2)
    }

    @Test("execute returns empty result when no posts")
    func returnsEmptyResultWhenNoPosts() throws {
        let (useCase, _, _, _) = makeUseCase(posts: [])
        let result = try useCase.execute()
        #expect(result.posts.isEmpty)
        #expect(result.categories.isEmpty)
    }
}

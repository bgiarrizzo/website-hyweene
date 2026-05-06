import Foundation
import Testing

@testable import HyweeneSiteGenerator

struct BlogPostMapperTests {
    // MARK: - Helpers

    private func makeDTO(
        title: String? = "My Post",
        body: String = "<p>content</p>",
        summary: String? = "A summary",
        publishDate: DateFormat? = DateFormat(Date(timeIntervalSince1970: 1_700_000_000)),
        updateDate: DateFormat? = nil,
        categoryName: String? = "Swift",
        tags: [String] = [],
        draft: Bool = false
    ) -> BlogPostDTO {
        var dict: [String: Any] = ["body": body, "draft": draft, "tags": tags]
        if let title { dict["title"] = title }
        if let summary { dict["summary"] = summary }
        if let publishDate { dict["publish_date"] = publishDate.original }
        if let updateDate { dict["update_date"] = updateDate.original }
        if let categoryName { dict["category"] = categoryName }
        return BlogPostDTO(from: dict, filePath: "/posts/my-post.md")
    }

    // MARK: - Happy Path

    @Test("Mapper produces entity with correct title and slug")
    func producesEntityWithTitleAndSlug() throws {
        let dto = makeDTO(title: "Hello World")
        let entity = try BlogPostMapper.toEntity(from: dto)
        #expect(entity.title == "Hello World")
        #expect(entity.slug == "hello-world")
    }

    @Test("Mapper produces entity with correct body and summary")
    func producesEntityWithBodyAndSummary() throws {
        let dto = makeDTO(body: "<p>body</p>", summary: "short")
        let entity = try BlogPostMapper.toEntity(from: dto)
        #expect(entity.body == "<p>body</p>")
        #expect(entity.summary == "short")
    }

    @Test("Mapper computes path from publishDate and slug")
    func computesPathFromPublishDateAndSlug() throws {
        let date = DateFormat(Date(timeIntervalSince1970: 0))  // 1970-01-01
        let dto = makeDTO(title: "Test Post", publishDate: date)
        let entity = try BlogPostMapper.toEntity(from: dto)
        #expect(entity.path.hasSuffix("-test-post"))
    }

    @Test("Mapper uses publish date as update date when update date is absent")
    func usesPublishDateAsUpdateDateWhenAbsent() throws {
        let pub = DateFormat(Date(timeIntervalSince1970: 1_700_000_000))
        let dto = makeDTO(publishDate: pub, updateDate: nil)
        let entity = try BlogPostMapper.toEntity(from: dto)
        #expect(entity.updateDate.original == entity.publishDate.original)
    }

    @Test("Mapper uses provided update date when present")
    func usesProvidedUpdateDate() throws {
        let pub = DateFormat(Date(timeIntervalSince1970: 1_000_000_000))
        let upd = DateFormat(Date(timeIntervalSince1970: 1_700_000_000))
        let dto = makeDTO(publishDate: pub, updateDate: upd)
        let entity = try BlogPostMapper.toEntity(from: dto)
        #expect(entity.updateDate.original == upd.original)
    }

    @Test("Mapper defaults category to Uncategorized when absent")
    func defaultsCategoryToUncategorized() throws {
        let dto = makeDTO(categoryName: nil)
        let entity = try BlogPostMapper.toEntity(from: dto)
        #expect(entity.category.name == "Uncategorized")
    }

    @Test("Mapper assigns provided category name")
    func assignsProvidedCategoryName() throws {
        let dto = makeDTO(categoryName: "iOS")
        let entity = try BlogPostMapper.toEntity(from: dto)
        #expect(entity.category.name == "iOS")
    }

    @Test("Mapper defaults summary to empty string when absent")
    func defaultsSummaryToEmptyWhenAbsent() throws {
        let dto = makeDTO(summary: nil)
        let entity = try BlogPostMapper.toEntity(from: dto)
        #expect(entity.summary == "")
    }

    // MARK: - Error Cases

    @Test("Mapper throws missingTitle when title is nil")
    func throwsMissingTitleWhenNil() {
        let dto = makeDTO(title: nil)
        #expect(throws: BlogPostMapper.MappingError.self) {
            _ = try BlogPostMapper.toEntity(from: dto)
        }
    }

    @Test("Mapper throws missingTitle when title is empty")
    func throwsMissingTitleWhenEmpty() {
        let dto = makeDTO(title: "")
        #expect(throws: BlogPostMapper.MappingError.self) {
            _ = try BlogPostMapper.toEntity(from: dto)
        }
    }

    @Test("Mapper throws missingPublishDate when publishDate is nil")
    func throwsMissingPublishDateWhenNil() {
        let dto = makeDTO(publishDate: nil)
        #expect(throws: BlogPostMapper.MappingError.self) {
            _ = try BlogPostMapper.toEntity(from: dto)
        }
    }
}

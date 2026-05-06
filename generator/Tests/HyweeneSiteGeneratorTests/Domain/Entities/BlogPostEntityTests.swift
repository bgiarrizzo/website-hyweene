import Foundation
import Testing

@testable import HyweeneSiteGenerator

struct BlogPostEntityTests {
    // MARK: - Helpers

    private func makeEntity(
        title: String = "My Post",
        slug: String = "my-post",
        body: String = "Hello world",
        summary: String = "A summary",
        publishDate: DateFormat = DateFormat(Date(timeIntervalSince1970: 1_700_000_000)),
        updateDate: DateFormat? = nil,
        categoryName: String = "Swift",
        tags: [String] = ["swift", "test"],
        readingTime: Int = 1,
        path: String = "2024-01-01-my-post",
        prismNeeded: Bool = false,
        cover: String? = nil,
        draft: Bool = false,
        tocHTML: String? = nil
    ) -> BlogPostEntity {
        let pub = publishDate
        return BlogPostEntity(
            title: title,
            slug: slug,
            body: body,
            summary: summary,
            publishDate: pub,
            updateDate: updateDate ?? pub,
            category: BlogPostCategory(name: categoryName),
            tags: tags,
            readingTime: readingTime,
            path: path,
            prismNeeded: prismNeeded,
            cover: cover,
            draft: draft,
            tocHTML: tocHTML
        )
    }

    // MARK: - toDictionary

    @Test("toDictionary contains all required keys")
    func toDictionaryContainsAllRequiredKeys() {
        let entity = makeEntity()
        let dict = entity.toDictionary()

        #expect(dict["title"] as? String == "My Post")
        #expect(dict["slug"] as? String == "my-post")
        #expect(dict["body"] as? String == "Hello world")
        #expect(dict["summary"] as? String == "A summary")
        #expect(dict["tags"] as? [String] == ["swift", "test"])
        #expect(dict["draft"] as? Bool == false)
        #expect(dict["path"] as? String == "2024-01-01-my-post")
        #expect(dict["prism_needed"] as? Bool == false)
        #expect(dict["publish_date"] != nil)
        #expect(dict["update_date"] != nil)
        #expect(dict["category"] != nil)
    }

    @Test("toDictionary omits cover when nil")
    func toDictionaryOmitsCoverWhenNil() {
        let entity = makeEntity(cover: nil)
        #expect(entity.toDictionary()["cover"] == nil)
    }

    @Test("toDictionary includes cover when present")
    func toDictionaryIncludesCoverWhenPresent() {
        let entity = makeEntity(cover: "images/cover.jpg")
        #expect(entity.toDictionary()["cover"] as? String == "images/cover.jpg")
    }

    @Test("toDictionary omits toc_html when nil")
    func toDictionaryOmitsTocHTMLWhenNil() {
        let entity = makeEntity(tocHTML: nil)
        #expect(entity.toDictionary()["toc_html"] == nil)
    }

    @Test("toDictionary includes toc_html when present")
    func toDictionaryIncludesTocHTMLWhenPresent() {
        let entity = makeEntity(tocHTML: "<ul><li>Intro</li></ul>")
        #expect(entity.toDictionary()["toc_html"] as? String == "<ul><li>Intro</li></ul>")
    }

    // MARK: - Reading Time Formatting

    @Test("toDictionary formats reading_time as singular for 1 minute")
    func toDictionaryFormatsReadingTimeSingular() {
        let entity = makeEntity(readingTime: 1)
        #expect(entity.toDictionary()["reading_time"] as? String == "1 minute")
    }

    @Test("toDictionary formats reading_time as plural for many minutes")
    func toDictionaryFormatsReadingTimePlural() {
        let entity = makeEntity(readingTime: 5)
        #expect(entity.toDictionary()["reading_time"] as? String == "5 minutes")
    }

    // MARK: - Stored Properties

    @Test("Entity stores all properties correctly")
    func entityStoresAllPropertiesCorrectly() {
        let date = DateFormat(Date(timeIntervalSince1970: 1_700_000_000))
        let entity = makeEntity(
            title: "Test", slug: "test", body: "body", summary: "sum",
            publishDate: date, categoryName: "Tech", tags: ["a", "b"],
            readingTime: 3, path: "2024-01-01-test", prismNeeded: true,
            cover: "img.jpg", draft: true, tocHTML: "<ul/>"
        )
        #expect(entity.title == "Test")
        #expect(entity.slug == "test")
        #expect(entity.body == "body")
        #expect(entity.summary == "sum")
        #expect(entity.category.name == "Tech")
        #expect(entity.tags == ["a", "b"])
        #expect(entity.readingTime == 3)
        #expect(entity.path == "2024-01-01-test")
        #expect(entity.prismNeeded == true)
        #expect(entity.cover == "img.jpg")
        #expect(entity.draft == true)
        #expect(entity.tocHTML == "<ul/>")
    }
}

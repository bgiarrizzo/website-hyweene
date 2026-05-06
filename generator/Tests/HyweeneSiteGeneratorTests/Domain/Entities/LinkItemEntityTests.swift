import Foundation
import Testing

@testable import HyweeneSiteGenerator

struct LinkItemEntityTests {
    private func makeEntity(
        title: String = "A link",
        url: String = "https://example.com/article",
        path: String = "2026-05-01-a-link",
        description: String = "desc",
        publishDate: DateFormat = DateFormat(Date(timeIntervalSince1970: 1_700_000_000)),
        updateDate: DateFormat? = nil,
        body: String = "<p>Body</p>",
        slug: String = "a-link"
    ) -> LinkItemEntity {
        LinkItemEntity(
            title: title,
            url: url,
            path: path,
            description: description,
            publishDate: publishDate,
            updateDate: updateDate,
            body: body,
            slug: slug
        )
    }

    @Test("Entity stores all properties correctly")
    func storesProperties() {
        let publishDate = DateFormat(Date(timeIntervalSince1970: 1_700_000_000))
        let updateDate = DateFormat(Date(timeIntervalSince1970: 1_700_086_400))
        let entity = makeEntity(publishDate: publishDate, updateDate: updateDate)

        #expect(entity.title == "A link")
        #expect(entity.url == "https://example.com/article")
        #expect(entity.path == "2026-05-01-a-link")
        #expect(entity.description == "desc")
        #expect(entity.publishDate.short == publishDate.short)
        #expect(entity.updateDate?.short == updateDate.short)
        #expect(entity.slug == "a-link")
    }

    @Test("toDictionary contains required keys")
    func toDictionaryContainsRequiredKeys() {
        let dict = makeEntity().toDictionary()

        #expect(dict["title"] as? String == "A link")
        #expect(dict["url"] as? String == "https://example.com/article")
        #expect(dict["description"] as? String == "desc")
        #expect(dict["body"] as? String == "<p>Body</p>")
        #expect(dict["slug"] as? String == "a-link")
        #expect(dict["path"] as? String == "2026-05-01-a-link")
        #expect(dict["publish_date"] != nil)
    }

    @Test("toDictionary marks image URLs")
    func marksImageURLs() {
        let imageEntity = makeEntity(url: "https://example.com/image.jpg")
        let webEntity = makeEntity(url: "https://example.com/page")

        #expect(imageEntity.toDictionary()["is_image"] as? Bool == true)
        #expect(webEntity.toDictionary()["is_image"] as? Bool == false)
    }

    @Test("toDictionary includes update date fields when update date exists")
    func includesUpdateDateWhenPresent() {
        let publishDate = DateFormat(Date(timeIntervalSince1970: 1_700_000_000))
        let updateDate = DateFormat(Date(timeIntervalSince1970: 1_700_086_400))
        let dict = makeEntity(publishDate: publishDate, updateDate: updateDate).toDictionary()

        #expect(dict["update_date"] != nil)
        #expect(dict["show_update_date"] as? Bool == true)
    }
}

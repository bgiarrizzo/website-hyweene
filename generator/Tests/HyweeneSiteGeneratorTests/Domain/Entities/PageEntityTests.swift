import Testing

@testable import HyweeneSiteGenerator

struct PageEntityTests {
    private func makeEntity(
        title: String = "About",
        body: String = "<p>Body</p>",
        permalink: String = "about",
        slug: String = "about",
        summary: String = "summary",
        cover: String? = nil
    ) -> PageEntity {
        PageEntity(
            title: title,
            body: body,
            permalink: permalink,
            slug: slug,
            summary: summary,
            cover: cover
        )
    }

    @Test("Entity stores all properties correctly")
    func storesProperties() {
        let entity = makeEntity(cover: "cover.jpg")

        #expect(entity.title == "About")
        #expect(entity.body == "<p>Body</p>")
        #expect(entity.permalink == "about")
        #expect(entity.slug == "about")
        #expect(entity.summary == "summary")
        #expect(entity.cover == "cover.jpg")
    }

    @Test("toDictionary contains required keys")
    func containsRequiredKeys() {
        let dict = makeEntity().toDictionary()

        #expect(dict["title"] as? String == "About")
        #expect(dict["body"] as? String == "<p>Body</p>")
        #expect(dict["permalink"] as? String == "about")
        #expect(dict["slug"] as? String == "about")
        #expect(dict["summary"] as? String == "summary")
    }

    @Test("toDictionary includes cover when present")
    func includesCover() {
        let dict = makeEntity(cover: "cover.jpg").toDictionary()
        #expect(dict["cover"] as? String == "cover.jpg")
    }

    @Test("toDictionary omits cover when absent")
    func omitsCover() {
        let dict = makeEntity(cover: nil).toDictionary()
        #expect(dict["cover"] == nil)
    }
}

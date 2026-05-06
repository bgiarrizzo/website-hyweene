import Testing

@testable import HyweeneSiteGenerator

struct PageMapperTests {
    private func makeDTO(title: String? = "About", permalink: String? = "about") -> PageDTO {
        let raw: [String: Any] = [
            "title": title as Any,
            "body": "<p>Body</p>",
            "permalink": permalink as Any,
            "summary": "summary",
            "cover": "cover.jpg",
        ]
        return PageDTO(from: raw, filePath: "/tmp/about.md")
    }

    @Test("Mapper produces entity with expected fields")
    func mapsFields() throws {
        let entity = try PageMapper.toEntity(from: makeDTO())

        #expect(entity.title == "About")
        #expect(entity.body == "<p>Body</p>")
        #expect(entity.permalink == "about")
        #expect(entity.slug == "about")
        #expect(entity.summary == "summary")
        #expect(entity.cover == "cover.jpg")
    }

    @Test("Mapper defaults permalink to empty string when absent")
    func defaultsPermalink() throws {
        let entity = try PageMapper.toEntity(from: makeDTO(permalink: nil))
        #expect(entity.permalink.isEmpty)
    }

    @Test("Mapper throws missingTitle when title is nil")
    func throwsMissingTitleWhenNil() {
        #expect(throws: PageMapper.MappingError.self) {
            try PageMapper.toEntity(from: makeDTO(title: nil))
        }
    }

    @Test("Mapper throws missingTitle when title is empty")
    func throwsMissingTitleWhenEmpty() {
        #expect(throws: PageMapper.MappingError.self) {
            try PageMapper.toEntity(from: makeDTO(title: ""))
        }
    }
}

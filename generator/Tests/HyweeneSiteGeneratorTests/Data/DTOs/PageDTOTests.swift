import Testing

@testable import HyweeneSiteGenerator

struct PageDTOTests {
    @Test("DTO initialises all fields from raw dict")
    func initialisesAllFields() {
        let raw: [String: Any] = [
            "title": "About",
            "body": "<p>Body</p>",
            "permalink": "about",
            "summary": "summary",
            "cover": "cover.jpg",
        ]

        let dto = PageDTO(from: raw, filePath: "/tmp/about.md")

        #expect(dto.filePath == "/tmp/about.md")
        #expect(dto.title == "About")
        #expect(dto.body == "<p>Body</p>")
        #expect(dto.permalink == "about")
        #expect(dto.summary == "summary")
        #expect(dto.cover == "cover.jpg")
    }

    @Test("DTO keeps optional fields nil when absent")
    func keepsOptionalsNilWhenAbsent() {
        let dto = PageDTO(from: [:], filePath: "file.md")

        #expect(dto.title == nil)
        #expect(dto.body.isEmpty)
        #expect(dto.permalink == nil)
        #expect(dto.summary == nil)
        #expect(dto.cover == nil)
    }
}

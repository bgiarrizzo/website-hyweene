import Foundation
import Testing

@testable import HyweeneSiteGenerator

struct LinkItemDTOTests {
    @Test("DTO initialises all fields from raw dict")
    func initialisesAllFields() {
        let raw: [String: Any] = [
            "title": "A link",
            "url": "https://example.com",
            "description": "desc",
            "body": "<p>Body</p>",
            "publish_date": "2026-05-01",
            "update_date": "2026-05-02",
            "slug": "a-link",
        ]

        let dto = LinkItemDTO(from: raw, filePath: "/tmp/link.md")

        #expect(dto.filePath == "/tmp/link.md")
        #expect(dto.title == "A link")
        #expect(dto.url == "https://example.com")
        #expect(dto.description == "desc")
        #expect(dto.body == "<p>Body</p>")
        #expect(dto.publishDate != nil)
        #expect(dto.updateDate != nil)
        #expect(dto.slug == "a-link")
    }

    @Test("DTO keeps optional fields nil when absent")
    func keepsOptionalsNilWhenAbsent() {
        let dto = LinkItemDTO(from: [:], filePath: "file.md")

        #expect(dto.title == nil)
        #expect(dto.url == nil)
        #expect(dto.description == nil)
        #expect(dto.publishDate == nil)
        #expect(dto.updateDate == nil)
        #expect(dto.slug == nil)
        #expect(dto.body.isEmpty)
    }

    @Test("DTO parses publish_date from Date object")
    func parsesPublishDateFromDateObject() {
        let raw: [String: Any] = ["publish_date": Date()]
        let dto = LinkItemDTO(from: raw, filePath: "file.md")
        #expect(dto.publishDate != nil)
    }
}

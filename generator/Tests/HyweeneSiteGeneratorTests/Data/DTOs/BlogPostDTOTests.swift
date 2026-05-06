import Foundation
import Testing

@testable import HyweeneSiteGenerator

struct BlogPostDTOTests {
    // MARK: - Helpers

    private func rawData(
        title: String? = "My Post",
        body: String = "<p>Hello</p>",
        summary: String? = "Summary",
        publishDate: String? = "2024-01-15",
        draft: Bool = false
    ) -> [String: Any] {
        var dict: [String: Any] = [
            "body": body,
            "draft": draft,
        ]
        if let title { dict["title"] = title }
        if let summary { dict["summary"] = summary }
        if let publishDate { dict["publish_date"] = publishDate }
        return dict
    }

    // MARK: - Tests

    @Test("DTO initialises all fields from raw dict")
    func initialisesAllFieldsFromRawDict() {
        let dto = BlogPostDTO(
            from: rawData(title: "Hello", summary: "Short desc", publishDate: "2024-06-01"),
            filePath: "/path/to/post.md"
        )
        #expect(dto.title == "Hello")
        #expect(dto.summary == "Short desc")
        #expect(dto.body == "<p>Hello</p>")
        #expect(dto.draft == false)
        #expect(dto.filePath == "/path/to/post.md")
        #expect(dto.publishDate != nil)
    }

    @Test("DTO sets nil title when key is absent")
    func setsTitleNilWhenAbsent() {
        let dto = BlogPostDTO(from: rawData(title: nil), filePath: "/p.md")
        #expect(dto.title == nil)
    }

    @Test("DTO sets nil summary when key is absent")
    func setsSummaryNilWhenAbsent() {
        let dto = BlogPostDTO(from: rawData(summary: nil), filePath: "/p.md")
        #expect(dto.summary == nil)
    }

    @Test("DTO sets nil publishDate when key is absent")
    func setsPublishDateNilWhenAbsent() {
        let dto = BlogPostDTO(from: rawData(publishDate: nil), filePath: "/p.md")
        #expect(dto.publishDate == nil)
    }

    @Test("DTO parses publishDate from Date object (Yams auto-parse)")
    func parsesPublishDateFromDateObject() {
        let date = Date(timeIntervalSince1970: 1_700_000_000)
        let dto = BlogPostDTO(from: ["body": "", "publish_date": date], filePath: "/p.md")
        #expect(dto.publishDate != nil)
    }

    @Test("DTO captures tags from raw dict")
    func capturesTagsFromRawDict() {
        let dto = BlogPostDTO(
            from: ["body": "", "tags": ["swift", "ios"]],
            filePath: "/p.md"
        )
        #expect(dto.tags == ["swift", "ios"])
    }

    @Test("DTO defaults tags to empty array when absent")
    func defaultsTagsToEmptyWhenAbsent() {
        let dto = BlogPostDTO(from: ["body": ""], filePath: "/p.md")
        #expect(dto.tags.isEmpty)
    }

    @Test("DTO captures draft flag from raw dict")
    func capturesDraftFlag() {
        let dto = BlogPostDTO(from: ["body": "", "draft": true], filePath: "/p.md")
        #expect(dto.draft == true)
    }

    @Test("DTO defaults draft to false when absent")
    func defaultsDraftToFalseWhenAbsent() {
        let dto = BlogPostDTO(from: ["body": ""], filePath: "/p.md")
        #expect(dto.draft == false)
    }
}

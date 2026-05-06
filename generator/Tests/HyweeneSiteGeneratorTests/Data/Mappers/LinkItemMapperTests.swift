import Foundation
import Testing

@testable import HyweeneSiteGenerator

struct LinkItemMapperTests {
    private func makeDTO(
        title: String? = "A link",
        url: String? = "https://example.com",
        publishDate: DateFormat? = DateFormat(Date(timeIntervalSince1970: 1_700_000_000)),
        slug: String? = nil
    ) -> LinkItemDTO {
        let raw: [String: Any] = [
            "title": title as Any,
            "url": url as Any,
            "publish_date": publishDate?.short as Any,
            "body": "<p>Body</p>",
            "description": "desc",
            "slug": slug as Any,
        ]
        return LinkItemDTO(from: raw, filePath: "/tmp/link.md")
    }

    @Test("Mapper produces entity with expected core fields")
    func mapsCoreFields() throws {
        let dto = makeDTO(title: "Interesting", url: "https://example.com")
        let entity = try LinkItemMapper.toEntity(from: dto)

        #expect(entity.title == "Interesting")
        #expect(entity.url == "https://example.com")
        #expect(entity.description == "desc")
        #expect(entity.path.hasSuffix("-interesting"))
    }

    @Test("Mapper throws missingTitle when title is nil")
    func throwsMissingTitleWhenNil() {
        let dto = makeDTO(title: nil)
        #expect(throws: LinkItemMapper.MappingError.self) {
            try LinkItemMapper.toEntity(from: dto)
        }
    }

    @Test("Mapper throws missingTitle when title is empty")
    func throwsMissingTitleWhenEmpty() {
        let dto = makeDTO(title: "")
        #expect(throws: LinkItemMapper.MappingError.self) {
            try LinkItemMapper.toEntity(from: dto)
        }
    }

    @Test("Mapper throws missingURL when URL is nil")
    func throwsMissingURLWhenNil() {
        let dto = makeDTO(url: nil)
        #expect(throws: LinkItemMapper.MappingError.self) {
            try LinkItemMapper.toEntity(from: dto)
        }
    }

    @Test("Mapper computes slug from title when missing")
    func computesSlugWhenMissing() throws {
        let dto = makeDTO(title: "Mon titre", slug: nil)
        let entity = try LinkItemMapper.toEntity(from: dto)
        #expect(entity.slug == "mon-titre")
    }

    @Test("Mapper uses slug from DTO when provided")
    func usesProvidedSlug() throws {
        let dto = makeDTO(slug: "custom-slug")
        let entity = try LinkItemMapper.toEntity(from: dto)
        #expect(entity.slug == "custom-slug")
    }
}

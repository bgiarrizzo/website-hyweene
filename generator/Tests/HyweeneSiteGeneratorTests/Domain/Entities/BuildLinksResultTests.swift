import Foundation
import Testing

@testable import HyweeneSiteGenerator

struct BuildLinksResultTests {
    @Test("BuildLinksResult stores links")
    func storesLinks() {
        let date = DateFormat(Date(timeIntervalSince1970: 1_700_000_000))
        let entity = LinkItemEntity(
            title: "A",
            url: "https://example.com",
            path: "2026-05-01-a",
            description: "",
            publishDate: date,
            updateDate: nil,
            body: "",
            slug: "a"
        )

        let result = BuildLinksResult(links: [entity])

        #expect(result.links.count == 1)
        #expect(result.links.first?.title == "A")
    }
}

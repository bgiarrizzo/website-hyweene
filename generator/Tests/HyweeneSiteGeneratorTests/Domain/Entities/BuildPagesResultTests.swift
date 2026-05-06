import Testing

@testable import HyweeneSiteGenerator

struct BuildPagesResultTests {
    @Test("BuildPagesResult stores pages")
    func storesPages() {
        let page = PageEntity(
            title: "About",
            body: "body",
            permalink: "about",
            slug: "about",
            summary: "",
            cover: nil
        )

        let result = BuildPagesResult(pages: [page])

        #expect(result.pages.count == 1)
        #expect(result.pages.first?.title == "About")
    }
}

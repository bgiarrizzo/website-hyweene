import Foundation
import Testing

@testable import HyweeneSiteGenerator

struct LearnModulePageEntityTests {
    @Test("toDictionary exposes normalized learning page fields")
    func toDictionaryExposesFields() {
        let page = LearnModulePageEntity(
            id: 1,
            title: "Intro",
            slug: "intro",
            summary: "summary",
            tags: ["git", "vcs"],
            publishDate: DateFormat(Date(timeIntervalSince1970: 1_700_000_000)),
            updateDate: DateFormat(Date(timeIntervalSince1970: 1_700_000_100)),
            toc: "<ul></ul>",
            body: "<p>body</p>",
            prismNeeded: true,
            disabled: false
        )
        let module = LearnModuleEntity(
            id: 1,
            name: "Git",
            slug: "git",
            logo: "logo.png",
            description: "desc",
            disabled: false,
            pages: [page]
        )

        let dict = page.toDictionary(module: module)

        #expect(dict["title"] as? String == "Intro")
        #expect(dict["tags"] as? [String] == ["git", "vcs"])
        #expect((dict["module"] as? [String: Any])?["slug"] as? String == "git")
    }
}
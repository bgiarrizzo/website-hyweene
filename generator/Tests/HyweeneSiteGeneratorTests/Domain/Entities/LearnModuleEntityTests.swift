import Foundation
import Testing

@testable import HyweeneSiteGenerator

struct LearnModuleEntityTests {
    @Test("module sorts pages by ascending id")
    func sortsPagesByID() {
        let module = LearnModuleEntity(
            id: 1,
            name: "Git",
            slug: "git",
            logo: nil,
            description: "desc",
            disabled: false,
            pages: [
                LearnModulePageEntity(
                    id: 2,
                    title: "Second",
                    slug: "second",
                    summary: "",
                    tags: [],
                    publishDate: DateFormat(),
                    updateDate: DateFormat(),
                    toc: "",
                    body: "",
                    prismNeeded: false,
                    disabled: false
                ),
                LearnModulePageEntity(
                    id: 1,
                    title: "First",
                    slug: "first",
                    summary: "",
                    tags: [],
                    publishDate: DateFormat(),
                    updateDate: DateFormat(),
                    toc: "",
                    body: "",
                    prismNeeded: false,
                    disabled: false
                ),
            ]
        )

        #expect(module.pages.map(\.id) == [1, 2])
    }

    @Test("toDictionary contains legacy module keys")
    func toDictionaryContainsLegacyKeys() {
        let module = LearnModuleEntity(
            id: 1,
            name: "Git",
            slug: "git",
            logo: "logo.png",
            description: "desc",
            disabled: false,
            pages: []
        )

        let dict = module.toDictionary()

        #expect(dict["name"] as? String == "Git")
        #expect(dict["slug"] as? String == "git")
        #expect(dict["logo"] as? String == "logo.png")
        #expect((dict["pages"] as? [[String: Any]])?.isEmpty == true)
    }
}

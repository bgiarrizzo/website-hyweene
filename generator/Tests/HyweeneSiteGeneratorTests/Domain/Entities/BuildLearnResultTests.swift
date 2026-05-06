import Testing

@testable import HyweeneSiteGenerator

struct BuildLearnResultTests {
    @Test("BuildLearnResult stores modules")
    func storesModules() {
        let module = LearnModuleEntity(
            id: 1,
            name: "Git",
            slug: "git",
            logo: nil,
            description: "desc",
            disabled: false,
            pages: []
        )

        let result = BuildLearnResult(modules: [module])

        #expect(result.modules.count == 1)
        #expect(result.modules.first?.name == "Git")
    }
}
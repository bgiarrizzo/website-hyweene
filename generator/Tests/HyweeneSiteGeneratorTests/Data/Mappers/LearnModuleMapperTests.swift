import Testing

@testable import HyweeneSiteGenerator

struct LearnModuleMapperTests {
    @Test("mapper produces module entity with normalized page slug")
    func mapsModule() throws {
        let pageDTO = LearnModulePageDTO(
            from: [
                "id": 1,
                "title": "Intro Git",
                "tags": "git, vcs",
            ],
            filePath: "/tmp/01-intro.md"
        )
        let moduleDTO = LearnModuleDTO(
            from: [
                "id": 1,
                "name": "Git",
            ],
            filePath: "/tmp/00-module.yml",
            pages: [pageDTO]
        )

        let entity = try LearnModuleMapper.toEntity(from: moduleDTO)

        #expect(entity.slug == "git")
        #expect(entity.pages.first?.slug == "intro-git")
        #expect(entity.pages.first?.tags == ["git", "vcs"])
    }

    @Test("mapper throws when module name is missing")
    func throwsMissingModuleName() {
        let moduleDTO = LearnModuleDTO(
            from: [:],
            filePath: "/tmp/00-module.yml",
            pages: []
        )

        #expect(throws: LearnModuleMapper.MappingError.self) {
            try LearnModuleMapper.toEntity(from: moduleDTO)
        }
    }

    @Test("mapper throws when page title is missing")
    func throwsMissingPageTitle() {
        let pageDTO = LearnModulePageDTO(from: [:], filePath: "/tmp/01-intro.md")

        #expect(throws: LearnModuleMapper.MappingError.self) {
            try LearnModuleMapper.toEntity(from: pageDTO)
        }
    }
}
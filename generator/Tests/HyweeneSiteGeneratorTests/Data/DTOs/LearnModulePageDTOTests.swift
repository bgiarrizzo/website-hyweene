import Testing

@testable import HyweeneSiteGenerator

struct LearnModulePageDTOTests {
    @Test("DTO normalizes comma separated tags")
    func normalizesCommaSeparatedTags() {
        let dto = LearnModulePageDTO(
            from: [
                "title": "Intro",
                "tags": "git, vcs, workflow",
            ],
            filePath: "/tmp/01-intro.md"
        )

        #expect(dto.title == "Intro")
        #expect(dto.tags == ["git", "vcs", "workflow"])
    }

    @Test("DTO keeps array tags unchanged")
    func keepsArrayTags() {
        let dto = LearnModulePageDTO(
            from: [
                "tags": ["git", "vcs"]
            ],
            filePath: "/tmp/01-intro.md"
        )

        #expect(dto.tags == ["git", "vcs"])
    }
}
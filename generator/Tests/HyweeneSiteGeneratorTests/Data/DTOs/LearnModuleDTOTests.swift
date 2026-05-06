import Testing

@testable import HyweeneSiteGenerator

struct LearnModuleDTOTests {
    @Test("DTO initialises module fields from YAML data")
    func initialisesModuleFields() {
        let dto = LearnModuleDTO(
            from: [
                "id": 1,
                "name": "Git",
                "logo": "logo.png",
                "description": "desc",
                "disabled": true,
            ],
            filePath: "/tmp/00-module.yml",
            pages: []
        )

        #expect(dto.filePath == "/tmp/00-module.yml")
        #expect(dto.id == 1)
        #expect(dto.name == "Git")
        #expect(dto.logo == "logo.png")
        #expect(dto.description == "desc")
        #expect(dto.disabled)
    }
}
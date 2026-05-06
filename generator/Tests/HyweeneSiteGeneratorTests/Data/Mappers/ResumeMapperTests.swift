import Testing

@testable import HyweeneSiteGenerator

struct ResumeMapperTests {
    @Test("experience mapper produces entity with expected fields")
    func mapsExperience() throws {
        let dto = ResumeExperienceDTO(
            from: [
                "id": 1,
                "title": "Engineer",
                "company": "Acme",
                "company_url": "https://acme.test",
                "location": "Paris",
                "work_mode": "Remote",
                "start_date": "2023",
                "end_date": "2024",
                "contract_type": "CDI",
                "tags": ["Swift"],
                "body": "body",
            ],
            filePath: "/tmp/experience.md"
        )

        let entity = try ResumeMapper.toEntity(from: dto)

        #expect(entity.title == "Engineer")
        #expect(entity.company == "Acme")
        #expect(entity.tags == ["Swift"])
    }

    @Test("experience mapper throws when title is missing")
    func experienceThrowsMissingTitle() {
        let dto = ResumeExperienceDTO(
            from: ["company": "Acme", "body": "body"],
            filePath: "/tmp/experience.md"
        )

        #expect(throws: ResumeMapper.MappingError.self) {
            try ResumeMapper.toEntity(from: dto)
        }
    }

    @Test("education mapper throws when school is missing")
    func educationThrowsMissingSchool() {
        let dto = ResumeEducationDTO(
            from: ["title": "Master", "body": "body"],
            filePath: "/tmp/education.md"
        )

        #expect(throws: ResumeMapper.MappingError.self) {
            try ResumeMapper.toEntity(from: dto)
        }
    }
}

import Testing

@testable import HyweeneSiteGenerator

struct ResumeEntityTests {
    private func makeEntity() -> ResumeEntity {
        ResumeEntity(
            head: ResumeHeadEntity(body: "head"),
            experiences: [
                ResumeExperienceEntity(
                    id: 2,
                    title: "Senior Engineer",
                    company: "Acme",
                    companyURL: nil,
                    location: "Paris",
                    workMode: "Remote",
                    startDate: "2023",
                    endDate: "2024",
                    contractType: "CDI",
                    tags: ["Swift", "Architecture", "ios"],
                    body: "body"
                ),
                ResumeExperienceEntity(
                    id: 1,
                    title: "Engineer",
                    company: "Beta",
                    companyURL: nil,
                    location: "Lyon",
                    workMode: "Hybrid",
                    startDate: "2022",
                    endDate: "2023",
                    contractType: nil,
                    tags: ["swift"],
                    body: "body"
                ),
            ],
            educations: [
                ResumeEducationEntity(
                    id: 2,
                    title: "Master",
                    school: "School B",
                    location: "Paris",
                    startDate: nil,
                    endDate: nil,
                    formationType: nil,
                    status: nil,
                    body: "body"
                ),
                ResumeEducationEntity(
                    id: 1,
                    title: "Licence",
                    school: "School A",
                    location: "Lyon",
                    startDate: nil,
                    endDate: nil,
                    formationType: nil,
                    status: nil,
                    body: "body"
                ),
            ],
            skills: [
                ResumeSkillEntity(id: 2, body: "B"),
                ResumeSkillEntity(id: 1, body: "A"),
            ]
        )
    }

    @Test("ResumeEntity sorts sections by ascending id")
    func sortsSectionsByID() {
        let entity = makeEntity()

        #expect(entity.experiences.map(\.id) == [1, 2])
        #expect(entity.educations.map(\.id) == [1, 2])
        #expect(entity.skills.map(\.id) == [1, 2])
    }

    @Test("ResumeEntity extracts unique normalized tags excluding site keywords")
    func extractsTags() {
        let entity = makeEntity()

        #expect(entity.tags.contains("ios"))
        #expect(!entity.tags.contains("swift"))
    }

    @Test("toDictionary contains legacy keys")
    func containsLegacyKeys() {
        let dict = makeEntity().toDictionary()

        #expect(dict["head"] != nil)
        #expect(dict["experiences"] != nil)
        #expect(dict["educations"] != nil)
        #expect(dict["skills"] != nil)
        #expect(dict["tags"] != nil)
    }
}

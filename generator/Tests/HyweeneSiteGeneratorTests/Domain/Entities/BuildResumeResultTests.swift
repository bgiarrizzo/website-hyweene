import Testing

@testable import HyweeneSiteGenerator

struct BuildResumeResultTests {
    @Test("BuildResumeResult stores resume aggregate")
    func storesResume() {
        let resume = ResumeEntity(
            head: ResumeHeadEntity(body: "head"),
            experiences: [],
            educations: [],
            skills: []
        )

        let result = BuildResumeResult(resume: resume)

        #expect(result.resume.head.body == "head")
    }
}

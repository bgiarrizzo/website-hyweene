import Foundation
import Testing

@testable import HyweeneSiteGenerator

struct FileSystemResumeContentRepositoryTests {
    @Test("loadResume returns aggregate with all sections")
    func returnsResumeAggregate() throws {
        let fm = FileManager.default
        let tempDir = fm.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        try fm.createDirectory(
            at: tempDir.appendingPathComponent("head"), withIntermediateDirectories: true)
        try fm.createDirectory(
            at: tempDir.appendingPathComponent("experiences"), withIntermediateDirectories: true)
        try fm.createDirectory(
            at: tempDir.appendingPathComponent("educations"), withIntermediateDirectories: true)
        try fm.createDirectory(
            at: tempDir.appendingPathComponent("skills"), withIntermediateDirectories: true)
        defer { try? fm.removeItem(at: tempDir) }

        try "Head".write(
            to: tempDir.appendingPathComponent("head/head.md"), atomically: true, encoding: .utf8)
        try """
        ---
        id: 1
        title: Engineer
        company: Acme
        ---

        Experience body
        """.write(
            to: tempDir.appendingPathComponent("experiences/exp.md"), atomically: true,
            encoding: .utf8)
        try """
        ---
        id: 1
        title: Master
        school: School
        ---

        Education body
        """.write(
            to: tempDir.appendingPathComponent("educations/edu.md"), atomically: true,
            encoding: .utf8)
        try """
        ---
        id: 1
        ---

        Skill body
        """.write(
            to: tempDir.appendingPathComponent("skills/skill.md"), atomically: true, encoding: .utf8
        )

        let repository = FileSystemResumeContentRepository(resumePath: tempDir.path)
        let resume = try repository.loadResume()

        #expect(resume.head.body.contains("Head"))
        #expect(resume.experiences.count == 1)
        #expect(resume.educations.count == 1)
        #expect(resume.skills.count == 1)
    }
}

import Foundation
import Testing

@testable import HyweeneSiteGenerator

/// Tests for `StencilTemplateRepository` — the `TemplateRepository` adapter that
/// wraps the Stencil engine.
///
/// Each test spins up a real temporary directory with an ad-hoc template so
/// the repository stays properly integrated with the underlying engine.
struct StencilTemplateRepositoryTests {

    // MARK: - Helpers

    /// Creates a throw-away temp directory, writes the provided templates, and
    /// returns a `StencilTemplateRepository` pointing at it.
    private func makeRepository(
        templates: [String: String]
    ) throws -> (repo: StencilTemplateRepository, dir: URL) {
        let dir = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString)
        try FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)

        for (name, body) in templates {
            let fileURL = dir.appendingPathComponent(name)
            // Create any intermediate subdirectory the template path needs.
            try FileManager.default.createDirectory(
                at: fileURL.deletingLastPathComponent(),
                withIntermediateDirectories: true
            )
            try body.write(to: fileURL, atomically: true, encoding: .utf8)
        }

        let repo = try StencilTemplateRepository(templatePath: dir.path)
        return (repo, dir)
    }

    // MARK: - Happy Path

    @Test("render returns interpolated variable content")
    func rendersVariable() throws {
        let (repo, dir) = try makeRepository(templates: ["hello.html": "Hi {{ name }}!"])
        defer { try? FileManager.default.removeItem(at: dir) }

        let result = try repo.render(template: "hello.html", context: ["name": "Hyweene"])

        #expect(result.contains("Hi Hyweene!"))
    }

    @Test("render merges multiple keys from context")
    func rendersMultipleContextKeys() throws {
        let (repo, dir) = try makeRepository(
            templates: ["multi.html": "{{ a }}+{{ b }}"])
        defer { try? FileManager.default.removeItem(at: dir) }

        let result = try repo.render(template: "multi.html", context: ["a": "foo", "b": "bar"])

        #expect(result.contains("foo+bar"))
    }

    @Test("render works with nested template in subdirectory")
    func rendersNestedTemplate() throws {
        let (repo, dir) = try makeRepository(
            templates: ["sub/nested.html": "Nested {{ value }}"])
        defer { try? FileManager.default.removeItem(at: dir) }

        let result = try repo.render(template: "sub/nested.html", context: ["value": "42"])

        #expect(result.contains("Nested 42"))
    }

    @Test("render returns content without variables unchanged")
    func rendersStaticContent() throws {
        let (repo, dir) = try makeRepository(
            templates: ["static.html": "<p>Hello</p>"])
        defer { try? FileManager.default.removeItem(at: dir) }

        let result = try repo.render(template: "static.html", context: [:])

        #expect(result.contains("<p>Hello</p>"))
    }

    // MARK: - Error Cases

    @Test("render throws when template does not exist")
    func throwsForMissingTemplate() throws {
        let (repo, dir) = try makeRepository(templates: [:])
        defer { try? FileManager.default.removeItem(at: dir) }

        #expect(throws: Error.self) {
            try repo.render(template: "nonexistent.html", context: [:])
        }
    }
}

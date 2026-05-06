import Foundation
import Testing

@testable import HyweeneSiteGenerator

struct LocalFileRepositoryTests {
    // MARK: - writeFile

    @Test("writeFile creates file at relative path under basePath")
    func createsFileAtRelativePath() throws {
        let tmp = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString).path
        defer { try? FileManager.default.removeItem(atPath: tmp) }

        let repo = LocalFileRepository(basePath: tmp)
        try repo.writeFile(content: "<html/>", to: "blog/index.html")

        let written = try String(
            contentsOf: URL(fileURLWithPath: "\(tmp)/blog/index.html"),
            encoding: .utf8
        )
        #expect(written == "<html/>")
    }

    @Test("writeFile creates intermediate directories")
    func createsIntermediateDirectories() throws {
        let tmp = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString).path
        defer { try? FileManager.default.removeItem(atPath: tmp) }

        let repo = LocalFileRepository(basePath: tmp)
        try repo.writeFile(content: "data", to: "a/b/c/page.html")

        let exists = FileManager.default.fileExists(
            atPath: "\(tmp)/a/b/c/page.html"
        )
        #expect(exists)
    }

    @Test("writeFile overwrites existing file")
    func overwritesExistingFile() throws {
        let tmp = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString).path
        defer { try? FileManager.default.removeItem(atPath: tmp) }

        let repo = LocalFileRepository(basePath: tmp)
        try repo.writeFile(content: "first", to: "page.html")
        try repo.writeFile(content: "second", to: "page.html")

        let written = try String(
            contentsOf: URL(fileURLWithPath: "\(tmp)/page.html"),
            encoding: .utf8
        )
        #expect(written == "second")
    }
}

import Foundation
import Testing

@testable import HyweeneSiteGenerator

struct FileSystemPageContentRepositoryTests {
    @Test("loadPages returns entities for markdown files")
    func returnsEntitiesForMarkdownFiles() throws {
        let fm = FileManager.default
        let tempDir = fm.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        try fm.createDirectory(at: tempDir, withIntermediateDirectories: true)
        defer { try? fm.removeItem(at: tempDir) }

        let file = tempDir.appendingPathComponent("about.md")
        try """
        ---
        title: About Page
        permalink: about
        summary: summary
        ---

        Body.
        """.write(to: file, atomically: true, encoding: .utf8)

        let repository = FileSystemPageContentRepository(pagesPath: tempDir.path)
        let pages = try repository.loadPages()

        #expect(pages.count == 1)
        #expect(pages.first?.title == "About Page")
        #expect(pages.first?.permalink == "about")
    }

    @Test("loadPages returns empty array for empty directory")
    func returnsEmptyArrayForEmptyDirectory() throws {
        let fm = FileManager.default
        let tempDir = fm.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        try fm.createDirectory(at: tempDir, withIntermediateDirectories: true)
        defer { try? fm.removeItem(at: tempDir) }

        let repository = FileSystemPageContentRepository(pagesPath: tempDir.path)
        let pages = try repository.loadPages()

        #expect(pages.isEmpty)
    }
}

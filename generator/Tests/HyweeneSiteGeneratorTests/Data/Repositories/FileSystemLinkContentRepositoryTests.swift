import Foundation
import Testing

@testable import HyweeneSiteGenerator

struct FileSystemLinkContentRepositoryTests {
    @Test("loadLinks returns entities for markdown files")
    func returnsEntitiesForMarkdownFiles() throws {
        let fm = FileManager.default
        let tempDir = fm.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        try fm.createDirectory(at: tempDir, withIntermediateDirectories: true)
        defer { try? fm.removeItem(at: tempDir) }

        let file = tempDir.appendingPathComponent("first.md")
        let content = """
        ---
        title: First Link
        url: https://example.com/first
        publish_date: 2026-05-01
        ---

        Body.
        """
        try content.write(to: file, atomically: true, encoding: .utf8)

        let repository = FileSystemLinkContentRepository(linksPath: tempDir.path)
        let links = try repository.loadLinks()

        #expect(links.count == 1)
        #expect(links.first?.title == "First Link")
        #expect(links.first?.url == "https://example.com/first")
    }

    @Test("loadLinks sorts links by publish date descending")
    func sortsByDateDescending() throws {
        let fm = FileManager.default
        let tempDir = fm.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        try fm.createDirectory(at: tempDir, withIntermediateDirectories: true)
        defer { try? fm.removeItem(at: tempDir) }

        let older = tempDir.appendingPathComponent("older.md")
        let newer = tempDir.appendingPathComponent("newer.md")

        try """
        ---
        title: Older
        url: https://example.com/older
        publish_date: 2026-01-01
        ---

        Old.
        """.write(to: older, atomically: true, encoding: .utf8)

        try """
        ---
        title: Newer
        url: https://example.com/newer
        publish_date: 2026-02-01
        ---

        New.
        """.write(to: newer, atomically: true, encoding: .utf8)

        let repository = FileSystemLinkContentRepository(linksPath: tempDir.path)
        let links = try repository.loadLinks()

        #expect(links.count == 2)
        #expect(links[0].title == "Newer")
        #expect(links[1].title == "Older")
    }

    @Test("loadLinks returns empty array for empty directory")
    func returnsEmptyArrayForEmptyDirectory() throws {
        let fm = FileManager.default
        let tempDir = fm.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        try fm.createDirectory(at: tempDir, withIntermediateDirectories: true)
        defer { try? fm.removeItem(at: tempDir) }

        let repository = FileSystemLinkContentRepository(linksPath: tempDir.path)
        let links = try repository.loadLinks()

        #expect(links.isEmpty)
    }
}

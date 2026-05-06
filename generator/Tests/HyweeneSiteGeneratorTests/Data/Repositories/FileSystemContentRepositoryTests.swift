import Foundation
import Testing

@testable import HyweeneSiteGenerator

struct FileSystemContentRepositoryTests {
    // MARK: - Helpers

    private func writeTempPost(
        in dir: URL,
        filename: String,
        title: String,
        publishDate: String,
        draft: Bool = false
    ) throws {
        let content = """
            ---
            title: \(title)
            publish_date: \(publishDate)
            draft: \(draft)
            ---
            This is the body of \(title).
            """
        let url = dir.appendingPathComponent(filename)
        try content.write(to: url, atomically: true, encoding: .utf8)
    }

    // MARK: - loadBlogPosts

    @Test("loadBlogPosts returns entities for each markdown file")
    func returnsBlogPostEntities() throws {
        let tmp = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString)
        try FileManager.default.createDirectory(
            at: tmp, withIntermediateDirectories: true)
        defer { try? FileManager.default.removeItem(at: tmp) }

        try writeTempPost(in: tmp, filename: "post-a.md", title: "Post A",
                          publishDate: "2024-03-01")
        try writeTempPost(in: tmp, filename: "post-b.md", title: "Post B",
                          publishDate: "2024-06-01")

        let repo = FileSystemContentRepository(blogPath: tmp.path)
        let posts = try repo.loadBlogPosts()

        #expect(posts.count == 2)
    }

    @Test("loadBlogPosts sorts posts by date descending")
    func sortsPostsByDateDescending() throws {
        let tmp = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString)
        try FileManager.default.createDirectory(
            at: tmp, withIntermediateDirectories: true)
        defer { try? FileManager.default.removeItem(at: tmp) }

        try writeTempPost(in: tmp, filename: "older.md", title: "Older Post",
                          publishDate: "2023-01-01")
        try writeTempPost(in: tmp, filename: "newer.md", title: "Newer Post",
                          publishDate: "2024-06-01")

        let repo = FileSystemContentRepository(blogPath: tmp.path)
        let posts = try repo.loadBlogPosts()

        #expect(posts.first?.title == "Newer Post")
        #expect(posts.last?.title == "Older Post")
    }

    @Test("loadBlogPosts skips files in draft sub-directory")
    func skipsDraftSubDirectory() throws {
        let tmp = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString)
        let draftDir = tmp.appendingPathComponent("draft")
        try FileManager.default.createDirectory(
            at: draftDir, withIntermediateDirectories: true)
        defer { try? FileManager.default.removeItem(at: tmp) }

        try writeTempPost(in: tmp, filename: "post.md", title: "Published",
                          publishDate: "2024-01-01")
        try writeTempPost(in: draftDir, filename: "draft-post.md",
                          title: "Draft In Folder", publishDate: "2024-02-01")

        let repo = FileSystemContentRepository(blogPath: tmp.path)
        let posts = try repo.loadBlogPosts()

        #expect(posts.count == 1)
        #expect(posts.first?.title == "Published")
    }

    @Test("loadBlogPosts returns empty array for empty directory")
    func returnsEmptyArrayForEmptyDirectory() throws {
        let tmp = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString)
        try FileManager.default.createDirectory(
            at: tmp, withIntermediateDirectories: true)
        defer { try? FileManager.default.removeItem(at: tmp) }

        let repo = FileSystemContentRepository(blogPath: tmp.path)
        let posts = try repo.loadBlogPosts()

        #expect(posts.isEmpty)
    }
}

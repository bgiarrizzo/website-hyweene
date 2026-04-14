import Foundation
import Testing
@testable import HyweeneSiteGenerator

struct ModelsTests {
    // MARK: - Models Tests
    @Test("BlogPost initializes from valid file")
    func blogPostInitialization() throws {
        let fm = FileManager.default
        let tempDir = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("test_\(UUID().uuidString)")
        
        defer { try? fm.removeItem(at: tempDir) }
        
        try fm.createDirectory(at: tempDir, withIntermediateDirectories: true)
        
        let content = """
        ---
        title: Test Post
        date: 2026-01-15
        category: Test
        tags: [swift, test]
        ---
        
        # Test Content
        
        This is a test post.
        """
        
        let file = tempDir.appendingPathComponent("2026-01-15-test-post.md")
        try content.write(to: file, atomically: true, encoding: .utf8)
        
        let post = try BlogPost(filePath: file.path)
        
        #expect(post.title == "Test Post")
        #expect(post.category == "Test")
        #expect(post.slug == "2026-01-15-test-post")
    }

    @Test("LinkItem initializes from valid file")
    func linkItemInitialization() throws {
        let fm = FileManager.default
        let tempDir = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("test_\(UUID().uuidString)")
        
        defer { try? fm.removeItem(at: tempDir) }
        
        try fm.createDirectory(at: tempDir, withIntermediateDirectories: true)
        
        let content = """
        ---
        title: Test Link
        date: 2026-01-15
        link: https://example.com
        ---
        
        Description of the link.
        """
        
        let file = tempDir.appendingPathComponent("2026-01-15-test-link.md")
        try content.write(to: file, atomically: true, encoding: .utf8)
        
        let link = try LinkItem(filePath: file.path)
        
        #expect(link.title == "Test Link")
        #expect(link.link == "https://example.com")
    }

    @Test("Page initializes from valid file")
    func pageInitialization() throws {
        let fm = FileManager.default
        let tempDir = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("test_\(UUID().uuidString)")
        
        defer { try? fm.removeItem(at: tempDir) }
        
        try fm.createDirectory(at: tempDir, withIntermediateDirectories: true)
        
        let content = """
        ---
        title: About Page
        slug: about
        ---
        
        # About Me
        
        This is the about page.
        """
        
        let file = tempDir.appendingPathComponent("about.md")
        try content.write(to: file, atomically: true, encoding: .utf8)
        
        let page = try Page(filePath: file.path)
        
        #expect(page.title == "About Page")
        #expect(page.slug == "about")
    }

    @Test("BlogPostCategory has correct properties")
    func blogPostCategoryProperties() {
        let category = BlogPostCategory(name: "Swift", count: 5, slug: "swift")
        
        #expect(category.name == "Swift")
        #expect(category.count == 5)
        #expect(category.slug == "swift")
    }

    @Test("DateFormat toDictionary returns all fields")
    func dateFormatToDictionary() {
        let date = DateFormat(from: "2026-01-15T10:30:00+00:00")
        let dict = date.toDictionary()
        
        #expect(dict["iso8601"] as? String != nil)
        #expect(dict["year"] as? Int != nil)
        #expect(dict["month"] as? Int != nil)
        #expect(dict["day"] as? Int != nil)
    }

    @Test("isDateOlderThanSixMonths returns correct result")
    func dateOlderThanSixMonths() {
        let calendar = Calendar.current
        let oldDate = calendar.date(byAdding: .month, value: -7, to: Date())!
        let recentDate = calendar.date(byAdding: .month, value: -3, to: Date())!
        
        #expect(isDateOlderThanSixMonths(oldDate))
        #expect(!isDateOlderThanSixMonths(recentDate))
    }
}
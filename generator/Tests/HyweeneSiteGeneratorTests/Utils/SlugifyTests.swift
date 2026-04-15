import Foundation
import Testing
@testable import HyweeneSiteGenerator

struct SlugifyTests {
// MARK: - Slugify Tests

@Test("Slugify basic text")
func slugifyBasicTest() {
    #expect(slugify("Hello World") == "hello-world")
    #expect(slugify("Test 123") == "test-123")
}

@Test("Slugify real-world blog titles")
func slugifyBlogTitles() {
    #expect(slugify("Comment j'ai installé Python sur Mac") == "comment-jai-installe-python-sur-mac")
    #expect(slugify("REST: Méthodes et status code HTTP") == "rest-methodes-et-status-code-http")
    #expect(slugify("Git - Comment je squash mes commits") == "git-comment-je-squash-mes-commits")
}

@Test("Slugify already slugified content")
func slugifyAlreadySlugified() {
    #expect(slugify("already-a-slug") == "already-a-slug")
    #expect(slugify("lowercase-slug-123") == "lowercase-slug-123")
}

@Test("Slugify with multiple spaces")
func slugifyMultipleSpaces() {
    #expect(slugify("Multiple   Spaces   Here") == "multiple-spaces-here")
}

@Test("Slugify removes leading/trailing hyphens")
func slugifyTrimsHyphens() {
    #expect(slugify("-test-") == "test")
    #expect(slugify("--start") == "start")
    #expect(slugify("end--") == "end")
}

@Test("Slugify empty strings")
func slugifyEmpty() {
    #expect(slugify("") == "")
    #expect(slugify("   ") == "")
}

@Test("Slugify with special characters")
func slugifySpecial() {
    #expect(slugify("C++ & Python") == "c-python")
    #expect(slugify("Price: $100") == "price-100")
    #expect(slugify("Hello@World!") == "helloworld")
}

@Test("Add slug to dictionary")
func addSlugToDictionary() {
    var data: [String: Any] = ["title": "My Test Title"]
    addSlug(to: &data)
    
    #expect(data["slug"] as? String == "my-test-title")
}

@Test("Add slug preserves existing data")
func addSlugPreservesData() {
    var data: [String: Any] = [
        "title": "Test",
        "author": "John",
        "date": "2026-01-01"
    ]
    addSlug(to: &data)
    
    #expect(data["author"] as? String == "John")
    #expect(data["date"] as? String == "2026-01-01")
    #expect(data["slug"] as? String == "test")
}

}
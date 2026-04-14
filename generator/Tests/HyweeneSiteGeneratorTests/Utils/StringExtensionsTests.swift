import Foundation
import Testing
@testable import HyweeneSiteGenerator

struct StringExtensionsTests {
// MARK: - String Extensions Tests

@Test("Slugify converts text to URL-friendly slug")
func slugifyBasicText() {
    #expect("Hello World".slugified() == "hello-world")
    #expect("Test 123".slugified() == "test-123")
}

@Test("Slugify handles French accents")
func slugifyFrenchAccents() {
    #expect("École française".slugified() == "ecole-francaise")
    #expect("Café à Paris".slugified() == "cafe-a-paris")
    #expect("Château d'été".slugified() == "chateau-dete")
}

@Test("Slugify handles special characters")
func slugifySpecialCharacters() {
    #expect("Test & Demo".slugified() == "test-demo")
    #expect("Price: $100".slugified() == "price-100")
    #expect("C++ Programming".slugified() == "c-programming")
}

@Test("Slugify removes leading and trailing hyphens")
func slugifyTrimsHyphens() {
    #expect("-test-".slugified() == "test")
    #expect("--multiple--".slugified() == "multiple")
}

@Test("Slugify handles empty and whitespace strings")
func slugifyEmptyStrings() {
    #expect("".slugified() == "")
    #expect("   ".slugified() == "")
}

@Test("Slugify with multiple spaces")
func slugifyMultipleSpaces() {
    #expect("Hello    World".slugified() == "hello-world")
    #expect("Test  \t  Tabs".slugified() == "test-tabs")
}

@Test("Truncated shortens text correctly")
func truncatedShortenText() {
    let longText = "This is a very long text that needs to be truncated"
    let truncated = longText.truncated(to: 20)
    
    #expect(truncated.count <= 23) // 20 + "..."
    #expect(truncated.hasSuffix("..."))
}

@Test("Truncated preserves short text")
func truncatedPreservesShortText() {
    let shortText = "Short"
    #expect(shortText.truncated(to: 20) == shortText)
}

@Test("Truncated custom trailing")
func truncatedCustomTrailing() {
    let text = "This is a long text"
    let truncated = text.truncated(to: 10, trailing: "…")
    
    #expect(truncated.hasSuffix("…"))
}

@Test("Stripping HTML removes simple tags")
func strippingHTMLSimpleTags() {
    #expect("<p>Hello</p>".strippingHTML() == "Hello")
    #expect("<b>Bold</b> text".strippingHTML() == "Bold text")
}

@Test("Stripping HTML removes tags with attributes")
func strippingHTMLWithAttributes() {
    #expect("<a href='test'>Link</a>".strippingHTML() == "Link")
    #expect("<div class='box'>Content</div>".strippingHTML() == "Content")
}

@Test("Stripping HTML handles nested tags")
func strippingHTMLNestedTags() {
    #expect("<div><p><b>Text</b></p></div>".strippingHTML() == "Text")
}

@Test("Stripping HTML preserves plain text")
func strippingHTMLPlainText() {
    #expect("No HTML here".strippingHTML() == "No HTML here")
}

@Test("Estimated reading time for short text")
func estimatedReadingTimeShort() {
    let shortText = "Hello world this is a test"
    let time = shortText.estimatedReadingTime()
    
    #expect(time == 1) // Minimum 1 minute
}

@Test("Estimated reading time for medium text")
func estimatedReadingTimeMedium() {
    let words = Array(repeating: "word", count: 500).joined(separator: " ")
    let time = words.estimatedReadingTime()
    
    #expect(time >= 2)
    #expect(time <= 3)
}

@Test("Estimated reading time for long text")
func estimatedReadingTimeLong() {
    let words = Array(repeating: "word", count: 2000).joined(separator: " ")
    let time = words.estimatedReadingTime()
    
    #expect(time >= 8)
    #expect(time <= 11)
}

@Test("Estimated reading time for empty text")
func estimatedReadingTimeEmpty() {
    #expect("".estimatedReadingTime() == 1)
}

@Test("Estimated reading time returns positive number")
func estimatedReadingTimePositive() {
    let text = "Some random text for testing"
    #expect(text.estimatedReadingTime() > 0)
}
}
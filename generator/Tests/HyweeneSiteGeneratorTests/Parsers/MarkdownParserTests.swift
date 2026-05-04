import Foundation
import Testing

@testable import HyweeneSiteGenerator

// MARK: - Markdown Parser Tests

struct MarkdownParserTests {
    @Test("Parse empty markdown")
    func parseEmptyMarkdown() throws {
        let parser = MarkdownParser()
        let result = parser.convertMarkdownToHTML("")

        #expect(result.isEmpty)
    }

    @Test("Parse markdown paragraph")
    func parseMarkdownParagraph() throws {
        let parser = MarkdownParser()
        let markdown = "This is a paragraph."
        let html = parser.convertMarkdownToHTML(markdown)

        #expect(html.contains("<p>"))
        #expect(html.contains("paragraph"))
        #expect(html.contains("</p>"))
    }

    @Test("Parse markdown headings")
    func parseMarkdownHeadings() throws {
        let parser = MarkdownParser()
        let markdown = """
            # H1
            ## H2
            ### H3
            """
        let html = parser.convertMarkdownToHTML(markdown)

        #expect(html.contains("<h1>"))
        #expect(html.contains("<h2>"))
        #expect(html.contains("<h3>"))
    }

    @Test("Parse markdown bold and italic")
    func parseMarkdownFormatting() throws {
        let parser = MarkdownParser()
        let markdown = "**bold** and *italic*"
        let html = parser.convertMarkdownToHTML(markdown)

        #expect(html.contains("<strong>") || html.contains("<b>"))
        #expect(html.contains("<em>") || html.contains("<i>"))
    }

    @Test("Parse markdown links")
    func parseMarkdownLinks() throws {
        let parser = MarkdownParser()
        let markdown = "[Link text](https://example.com)"
        let html = parser.convertMarkdownToHTML(markdown)

        #expect(html.contains("<a"))
        #expect(html.contains("href"))
        #expect(html.contains("example.com"))
    }

    @Test("Parse markdown code blocks")
    func parseMarkdownCodeBlocks() throws {
        let parser = MarkdownParser()
        let markdown = "```\ncode here\n```"
        let html = parser.convertMarkdownToHTML(markdown)

        #expect(html.contains("<code>") || html.contains("<pre>"))
    }

    @Test("Parse markdown code blocks with language")
    func parseMarkdownCodeBlocksWithLanguage() throws {
        let parser = MarkdownParser()
        let markdown = "```swift\nlet x = 1\n```"
        let html = parser.convertMarkdownToHTML(markdown)

        #expect(html.contains("swift") || html.contains("language-swift"))
    }

    @Test("Parse markdown lists")
    func parseMarkdownLists() throws {
        let parser = MarkdownParser()
        let markdown = """
            - Item 1
            - Item 2
            - Item 3
            """
        let html = parser.convertMarkdownToHTML(markdown)

        #expect(html.contains("<ul>") || html.contains("<li>"))
    }

    @Test("Prism code processor adds language class")
    func prismAddsLanguageClass() throws {
        let processor = PrismCodeProcessor()
        let code = "```swift\nlet x = 1\n```"
        let result = processor.process(code)

        #expect(result.contains("language-swift"))
    }

    @Test("Prism code processor handles empty language")
    func prismHandlesEmptyLanguage() throws {
        let processor = PrismCodeProcessor()
        let code = "some code"
        let result = processor.process(code)

        #expect(!result.isEmpty)
    }
}

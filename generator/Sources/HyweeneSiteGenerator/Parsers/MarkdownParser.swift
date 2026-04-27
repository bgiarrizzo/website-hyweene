import Foundation
import Yams
import Ink

public enum MarkdownParserError: Error {
    case fileNotFound(String)
    case invalidYAML(String)
    case parsingFailed(String)
}

/// Parser for Markdown files with YAML frontmatter
public struct MarkdownParser {
    private let prismProcessor = PrismCodeProcessor()
    
    // MARK: - YAML Frontmatter Parsing
    
    /// Parse YAML header and markdown body from file content
    /// - Parameter content: Markdown file content
    /// - Returns: Tuple of (yaml dictionary, markdown body)
    func parseYAMLAndMarkdown(from content: String) -> ([String: Any], String) {
        // Pattern to match YAML frontmatter: ---\n...\n---\n
        let pattern = #"^---\s*\n(.*?)\n---\s*\n"#
        
        guard let regex = try? NSRegularExpression(pattern: pattern, options: [.dotMatchesLineSeparators]) else {
            return ([:], content)
        }
        
        let range = NSRange(content.startIndex..., in: content)
        
        if let match = regex.firstMatch(in: content, options: [], range: range) {
            // Extract YAML header
            if let yamlRange = Range(match.range(at: 1), in: content) {
                let yamlString = String(content[yamlRange])
                
                // Parse YAML
                let yamlDict: [String: Any]
                do {
                    if let parsed = try Yams.load(yaml: yamlString) as? [String: Any] {
                        yamlDict = parsed
                    } else {
                        yamlDict = [:]
                    }
                } catch {
                    print("⚠️  YAML parsing error: \(error)")
                    yamlDict = [:]
                }
                
                // Extract markdown body (after the second ---)
                let bodyStartIndex = content.index(content.startIndex, offsetBy: match.range.upperBound)
                let markdownBody = String(content[bodyStartIndex...]).trimmingCharacters(in: .whitespacesAndNewlines)
                
                return (yamlDict, markdownBody)
            }
        }
        
        // No YAML frontmatter found
        return ([:], content)
    }
    
    /// Parse YAML header and markdown body from a file
    /// - Parameter filePath: Path to markdown file
    /// - Returns: Tuple of (yaml dictionary, markdown body)
    /// - Throws: File reading errors
    func parseYAMLAndMarkdown(fromFile filePath: String) throws -> ([String: Any], String) {
        let fileURL = URL(fileURLWithPath: filePath)
        let content = try String(contentsOf: fileURL, encoding: .utf8)
        return parseYAMLAndMarkdown(from: content)
    }
    
    // MARK: - Markdown to HTML Conversion
    
    /// Convert markdown text to HTML
    /// - Parameter markdown: Markdown text
    /// - Returns: HTML string
    func convertMarkdownToHTML(_ markdown: String) -> String {
        // First, process code blocks with Prism processor
        let processedMarkdown = prismProcessor.process(markdown)
        
        // Then convert to HTML using Ink's parser
        let inkParser = Ink.MarkdownParser()
        let html = inkParser.html(from: processedMarkdown)
        
        return html
    }
    
    // MARK: - Complete Parsing
    
    /// Parse markdown file and convert to HTML
    /// Returns dictionary with YAML fields + body HTML
    /// - Parameter filePath: Path to markdown file
    /// - Returns: Dictionary containing YAML metadata and HTML body
    /// - Throws: File reading or parsing errors
    func parseMarkdownFile(_ filePath: String) throws -> [String: Any] {
        let (yamlHeader, markdownBody) = try parseYAMLAndMarkdown(fromFile: filePath)
        let htmlBody = convertMarkdownToHTML(markdownBody)
        
        // Merge YAML header with HTML body
        var result = yamlHeader
        result["body"] = htmlBody
        
        // Calculate reading time if body exists
        if !markdownBody.isEmpty {
            let readingTime = markdownBody.estimatedReadingTime()
            result["reading_time"] = readingTime
        }
        
        return result
    }
}

// MARK: - Global Helper Functions

/// Parse a markdown file and return dictionary with YAML + HTML
public func parseMarkdownFile(_ path: String) throws -> [String: Any] {
    let parser = MarkdownParser()
    return try parser.parseMarkdownFile(path)
}

/// Convert markdown string to HTML
public func convertMarkdownToHTML(_ markdown: String) -> String {
    let parser = MarkdownParser()
    return parser.convertMarkdownToHTML(markdown)
}

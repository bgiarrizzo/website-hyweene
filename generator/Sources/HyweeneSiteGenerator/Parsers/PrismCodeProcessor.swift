import Foundation

public enum PrismCodeProcessorError: Error {
    case processingFailed(String)
}

/// Processes fenced code blocks for Prism.js syntax highlighting
/// Converts ```language blocks to <pre><code class="language-{lang}">...</code></pre>
public struct PrismCodeProcessor {
    private let fencePattern = try! NSRegularExpression(pattern: "^```\\s*(\\w+)?", options: [.anchorsMatchLines])
    
    /// Process markdown text to wrap code blocks in Prism-compatible HTML
    /// - Parameter text: Markdown text with fenced code blocks
    /// - Returns: Text with code blocks wrapped in HTML
    func process(_ text: String) -> String {
        let lines = text.components(separatedBy: .newlines)
        var processedLines: [String] = []
        var inCodeBlock = false
        var codeBlock: [String] = []
        var lang = "plaintext"
        
        for line in lines {
            if isFenceLine(line) {
                if !inCodeBlock {
                    // Start of code block
                    inCodeBlock = true
                    lang = extractLanguage(from: line) ?? "plaintext"
                    codeBlock = []
                } else {
                    // End of code block
                    inCodeBlock = false
                    let codeHTML = escape(codeBlock.joined(separator: "\n"))
                    processedLines.append(
                        "<pre><code class=\"language-\(lang)\">\(codeHTML)</code></pre>"
                    )
                }
            } else if inCodeBlock {
                codeBlock.append(line)
            } else {
                processedLines.append(line)
            }
        }
        
        // Handle unclosed code block
        if inCodeBlock {
            let codeHTML = escape(codeBlock.joined(separator: "\n"))
            processedLines.append(
                "<pre><code class=\"language-\(lang)\">\(codeHTML)</code></pre>"
            )
        }
        
        return processedLines.joined(separator: "\n")
    }
    
    /// Check if a line is a code fence (```)
    private func isFenceLine(_ line: String) -> Bool {
        let range = NSRange(line.startIndex..., in: line)
        return fencePattern.firstMatch(in: line, options: [], range: range) != nil
    }
    
    /// Extract language from fence line
    private func extractLanguage(from line: String) -> String? {
        let range = NSRange(line.startIndex..., in: line)
        guard let match = fencePattern.firstMatch(in: line, options: [], range: range) else {
            return nil
        }
        
        // Capture group 1 is the language
        if match.numberOfRanges > 1 {
            let langRange = match.range(at: 1)
            if langRange.location != NSNotFound,
               let range = Range(langRange, in: line) {
                return String(line[range])
            }
        }
        
        return nil
    }
    
    /// HTML-escape code content
    private func escape(_ text: String) -> String {
        return text
            .replacingOccurrences(of: "&", with: "&amp;")
            .replacingOccurrences(of: "<", with: "&lt;")
            .replacingOccurrences(of: ">", with: "&gt;")
    }
}

import Foundation

#if canImport(FoundationNetworking)
    import FoundationNetworking
#endif

/// Errors for link management runtime commands.
public enum LinkToolsRuntimeError: LocalizedError {
    case invalidURL(String)
    case invalidResponse
    case httpError(Int)
    case decodingFailed
    case titleNotFound

    public var errorDescription: String? {
        switch self {
        case .invalidURL(let raw):
            return "Invalid URL: \(raw)"
        case .invalidResponse:
            return "Invalid HTTP response."
        case .httpError(let statusCode):
            return "HTTP request failed with status code \(statusCode)."
        case .decodingFailed:
            return "Unable to decode HTML response body."
        case .titleNotFound:
            return "Could not extract page title from HTML."
        }
    }
}

/// Add a curated link file from a URL, reproducing quick_add_link.py behavior.
/// - Parameters:
///   - urlString: Absolute URL to fetch and convert into a link markdown file.
///   - comment: Optional one-line comment. If `nil`, the command prompts interactively.
public func runQuickAddLink(urlString: String, comment: String? = nil) async throws {
    guard let url = URL(string: urlString), url.scheme != nil, url.host != nil else {
        throw LinkToolsRuntimeError.invalidURL(urlString)
    }

    print("🌐 Fetching URL: \(urlString)")

    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    let (data, response) = try await URLSession.shared.data(for: request)

    guard let httpResponse = response as? HTTPURLResponse else {
        throw LinkToolsRuntimeError.invalidResponse
    }

    guard httpResponse.statusCode == 200 else {
        throw LinkToolsRuntimeError.httpError(httpResponse.statusCode)
    }

    guard let html = String(data: data, encoding: .utf8) else {
        throw LinkToolsRuntimeError.decodingFailed
    }

    guard let title = extractHTMLTitle(from: html) else {
        throw LinkToolsRuntimeError.titleNotFound
    }

    print("📝 Title: \(title)")

    let finalComment: String
    if let comment {
        finalComment = comment
    } else {
        print("Your Comment (one line only) : ", terminator: "")
        finalComment = readLine() ?? ""
    }

    let shortDate = DateFormat().short
    let fullDate = currentRFC3339Timestamp()
    let slug = slugify(title)
    let filename = "\(shortDate)-\(slug).md"
    let outputPath = "\(Config.linksPath)/\(filename)"

    let markdown = makeLinkMarkdown(
        title: title,
        url: urlString,
        publishDate: fullDate,
        updateDate: fullDate,
        comment: finalComment
    )

    try FileManager.default.writeFile(content: markdown, to: outputPath)

    print("✅ Created: \(outputPath)")
    print("")
    print("When you are done, run the following commands to commit and push your new link:")
    print("")
    print("mise run build")
    print("git add content/text/links/\(filename)")
    print("git commit -m \"add new link - \(filename)\"")
    print("git push")
}

/// Check generated HTML for dead external links, reproducing check_dead_links.py behavior.
/// - Parameter path: Optional path to scan. Defaults to `Config.currentReleasePath`.
public func runCheckDeadLinks(path: String?) async throws {
    let scanPath = path ?? Config.currentReleasePath
    print("Checking for dead links...")

    let htmlFiles = findHTMLFiles(in: scanPath)
    print("Found \(htmlFiles.count) HTML files.")

    var pages: [[String: Any]] = []

    for htmlFile in htmlFiles {
        let fileContent = try String(contentsOfFile: htmlFile, encoding: .utf8)
        let links = extractExternalLinks(from: fileContent)
        var deadLinks: [String] = []

        for link in links {
            if try await isDeadLink(link) {
                deadLinks.append(link)
            }
        }

        print("Checked \(htmlFile): \(links.count) links found, \(deadLinks.count) dead links.")

        if !deadLinks.isEmpty {
            pages.append([
                "path": htmlFile,
                "links": links,
                "dead_links": deadLinks,
            ])
        }
    }

    let payload: [String: Any] = ["pages": pages]
    let jsonData = try JSONSerialization.data(withJSONObject: payload, options: [.prettyPrinted])

    if let jsonText = String(data: jsonData, encoding: .utf8) {
        print(jsonText)
    }
}

private func makeLinkMarkdown(
    title: String,
    url: String,
    publishDate: String,
    updateDate: String,
    comment: String
) -> String {
    return """
        ---
        title: "\(escapeQuotes(title))"
        url: "\(escapeQuotes(url))"
        publish_date: \(publishDate)
        update_date: \(updateDate)
        tags:
        ---

        \(comment)
        """
}

private func extractHTMLTitle(from html: String) -> String? {
    let pattern = "<title[^>]*>(.*?)</title>"
    guard
        let regex = try? NSRegularExpression(
            pattern: pattern, options: [.caseInsensitive, .dotMatchesLineSeparators])
    else {
        return nil
    }

    let range = NSRange(html.startIndex..<html.endIndex, in: html)
    guard let match = regex.firstMatch(in: html, options: [], range: range),
        let titleRange = Range(match.range(at: 1), in: html)
    else {
        return nil
    }

    let rawTitle = String(html[titleRange])
    let normalized = rawTitle.replacingOccurrences(of: "\n", with: " ").trimmingCharacters(
        in: .whitespacesAndNewlines)
    return normalized.isEmpty ? nil : normalized
}

private func findHTMLFiles(in rootPath: String) -> [String] {
    let fm = FileManager.default
    var htmlFiles: [String] = []

    guard let enumerator = fm.enumerator(atPath: rootPath) else {
        return []
    }

    for case let relativePath as String in enumerator {
        if relativePath.contains("stats") {
            continue
        }

        if relativePath.hasSuffix(".html") {
            htmlFiles.append("\(rootPath)/\(relativePath)")
        }
    }

    return htmlFiles.sorted()
}

private func extractExternalLinks(from content: String) -> [String] {
    let pattern = "(?:href|src)\\s*=\\s*\"(https?://[^\"#]+)\""

    guard let regex = try? NSRegularExpression(pattern: pattern, options: [.caseInsensitive]) else {
        return []
    }

    let nsRange = NSRange(content.startIndex..<content.endIndex, in: content)
    let matches = regex.matches(in: content, options: [], range: nsRange)

    return matches.compactMap { match in
        guard match.numberOfRanges > 1,
            let range = Range(match.range(at: 1), in: content)
        else {
            return nil
        }
        return String(content[range])
    }
}

private func isDeadLink(_ urlString: String) async throws -> Bool {
    guard let url = URL(string: urlString) else {
        return true
    }

    var request = URLRequest(url: url)
    request.httpMethod = "HEAD"
    request.timeoutInterval = 12

    do {
        let (_, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse else {
            return false
        }
        return httpResponse.statusCode == 404
    } catch {
        print("Error checking \(urlString): \(error.localizedDescription)")
        return true
    }
}

private func currentRFC3339Timestamp() -> String {
    let formatter = ISO8601DateFormatter()
    formatter.formatOptions = [.withInternetDateTime]
    formatter.timeZone = TimeZone.current
    return formatter.string(from: Date())
}

private func escapeQuotes(_ value: String) -> String {
    value.replacingOccurrences(of: "\"", with: "\\\"")
}

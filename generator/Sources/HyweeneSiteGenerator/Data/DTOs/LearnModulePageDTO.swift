import Foundation

/// Raw parsed data for a learning module page.
public struct LearnModulePageDTO: Sendable {
    /// Source file path for diagnostics.
    public let filePath: String
    /// Sort identifier.
    public let id: Int?
    /// Page title.
    public let title: String?
    /// Summary text.
    public let summary: String?
    /// Raw normalized tags.
    public let tags: [String]
    /// Publish date.
    public let publishDate: DateFormat?
    /// Update date.
    public let updateDate: DateFormat?
    /// HTML table of contents.
    public let toc: String
    /// Rendered HTML body.
    public let body: String
    /// Whether Prism assets are required.
    public let prismNeeded: Bool
    /// Disabled flag.
    public let disabled: Bool

    /// Build a DTO from raw parser output.
    public init(from rawData: [String: Any], filePath: String) {
        self.filePath = filePath
        self.id = rawData["id"] as? Int
        self.title = rawData["title"] as? String
        self.summary = rawData["summary"] as? String
        self.tags = Self.parseTags(rawData["tags"])

        if let string = rawData["publish_date"] as? String {
            self.publishDate = DateFormat(from: string)
        } else if let date = rawData["publish_date"] as? Date {
            self.publishDate = DateFormat(date)
        } else {
            self.publishDate = nil
        }

        if let string = rawData["update_date"] as? String {
            self.updateDate = DateFormat(from: string)
        } else if let date = rawData["update_date"] as? Date {
            self.updateDate = DateFormat(date)
        } else {
            self.updateDate = nil
        }

        self.toc = rawData["toc_html"] as? String ?? ""
        self.body = rawData["body"] as? String ?? ""
        self.prismNeeded = rawData["prism_needed"] as? Bool ?? false
        self.disabled = rawData["disabled"] as? Bool ?? false
    }

    private static func parseTags(_ rawValue: Any?) -> [String] {
        if let tags = rawValue as? [String] {
            return tags
        }

        if let tagString = rawValue as? String {
            return
                tagString
                .split(separator: ",")
                .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
                .filter { !$0.isEmpty }
        }

        return []
    }
}

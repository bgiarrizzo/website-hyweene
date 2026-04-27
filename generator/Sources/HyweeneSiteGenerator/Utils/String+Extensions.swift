import Foundation

extension String {
    /// Slugifies a string (converts to URL-friendly format)
    /// Example: "Git : Comment je squash mes commits" → "git-comment-je-squash-mes-commits"
    func slugified() -> String {
        // Remove accents and diacritics
        let withoutAccents = self.folding(options: .diacriticInsensitive, locale: .current)
        
        // Convert to lowercase
        let lowercased = withoutAccents.lowercased()
        
        // Replace non-alphanumeric characters with hyphens
        let alphanumeric = lowercased.components(separatedBy: CharacterSet.alphanumerics.inverted)
            .filter { !$0.isEmpty }
            .joined(separator: "-")
        
        // Remove consecutive hyphens and trim
        let cleaned = alphanumeric
            .replacingOccurrences(of: "--+", with: "-", options: .regularExpression)
            .trimmingCharacters(in: CharacterSet(charactersIn: "-"))
        
        return cleaned
    }
    
    /// Truncates string to a maximum length
    func truncated(to length: Int, trailing: String = "...") -> String {
        if self.count <= length {
            return self
        }
        let endIndex = self.index(self.startIndex, offsetBy: length)
        return String(self[..<endIndex]) + trailing
    }
    
    /// Removes HTML tags from string
    func strippingHTML() -> String {
        return self.replacingOccurrences(
            of: "<[^>]+>",
            with: "",
            options: .regularExpression
        )
    }
    
    /// Calculate reading time in minutes (assuming 200 words per minute)
    func estimatedReadingTime() -> Int {
        let words = self.components(separatedBy: .whitespacesAndNewlines)
            .filter { !$0.isEmpty }
        let wordCount = words.count
        let minutes = max(1, wordCount / 200)  // Minimum 1 minute
        return minutes
    }
}

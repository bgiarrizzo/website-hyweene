import Foundation

/// DateFormat utility - provides multiple date format outputs
/// Mimics the Python DateFormat class functionality
public class DateFormat {
    let original: Date
    let rfc3339: String
    let condensed: String
    let short: String
    let medium: String
    let long: String
    let year: Int
    let month: String
    
    init(_ date: Date? = nil) {
        self.original = date ?? Date()
        
        // RFC3339 format (ISO 8601): "2025-08-29T11:30:00Z"
        let rfc3339Formatter = DateFormatter()
        rfc3339Formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        rfc3339Formatter.locale = Locale(identifier: "en_US_POSIX")
        rfc3339Formatter.timeZone = TimeZone(secondsFromGMT: 0)
        self.rfc3339 = rfc3339Formatter.string(from: self.original)
        
        // Condensed: "20250829"
        let condensedFormatter = ISO8601DateFormatter()
        condensedFormatter.formatOptions = [.withFullDate]
        condensedFormatter.timeZone = TimeZone.current
        self.condensed = condensedFormatter.string(from: self.original)
            .replacingOccurrences(of: "-", with: "")
        
        // Short: "2025-08-29"
        let shortFormatter = DateFormatter()
        shortFormatter.dateFormat = "yyyy-MM-dd"
        shortFormatter.timeZone = TimeZone.current
        self.short = shortFormatter.string(from: self.original)
        
        // Medium: "29 Aug 2025" (French: "29 août 2025")
        let mediumFormatter = DateFormatter()
        mediumFormatter.dateFormat = "dd MMM yyyy"
        mediumFormatter.locale = Locale(identifier: "fr_FR")
        mediumFormatter.timeZone = TimeZone.current
        self.medium = mediumFormatter.string(from: self.original)
        
        // Long: "29 August 2025" (French: "29 août 2025")
        let longFormatter = DateFormatter()
        longFormatter.dateFormat = "dd MMMM yyyy"
        longFormatter.locale = Locale(identifier: "fr_FR")
        longFormatter.timeZone = TimeZone.current
        self.long = longFormatter.string(from: self.original)
        
        // Year
        let calendar = Calendar.current
        self.year = calendar.component(.year, from: self.original)
        
        // Month: "08-August" (French: "08-août")
        let monthFormatter = DateFormatter()
        monthFormatter.dateFormat = "MM-MMMM"
        monthFormatter.locale = Locale(identifier: "fr_FR")
        monthFormatter.timeZone = TimeZone.current
        self.month = monthFormatter.string(from: self.original)
    }
    
    /// Creates DateFormat from ISO 8601 string
    convenience init?(from string: String) {
        // Try multiple date parsing strategies
        
        // Strategy 1: ISO8601DateFormatter with flexible options
        let iso8601Formatter = ISO8601DateFormatter()
        iso8601Formatter.formatOptions = [.withFullDate, .withTime, .withColonSeparatorInTimeZone]
        
        if let date = iso8601Formatter.date(from: string) {
            self.init(date)
            return
        }
        
        // Strategy 2: ISO8601 without colon in timezone
        iso8601Formatter.formatOptions = [.withFullDate, .withTime, .withTimeZone]
        if let date = iso8601Formatter.date(from: string) {
            self.init(date)
            return
        }
        
        // Strategy 3: DateFormatter with timezone offset format "+01:00"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        // Convert "+01:00" to "+0100" if needed
        var normalizedString = string
        if let range = normalizedString.range(of: #"[+-]\d{2}:\d{2}$"#, options: .regularExpression) {
            let timezone = String(normalizedString[range])
            let normalizedTimezone = timezone.replacingOccurrences(of: ":", with: "")
            normalizedString = normalizedString.replacingCharacters(in: range, with: normalizedTimezone)
        }
        
        if let date = dateFormatter.date(from: normalizedString) {
            self.init(date)
            return
        }
        
        // Strategy 4: Try without timezone
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        if let date = dateFormatter.date(from: string) {
            self.init(date)
            return
        }
        
        // Strategy 5: Simple date format "YYYY-MM-DD"
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if let date = dateFormatter.date(from: string) {
            self.init(date)
            return
        }
        
        // Strategy 6: Handle "now" keyword
        if string.lowercased() == "now" {
            self.init(Date())
            return
        }
        
        // All strategies failed
        return nil
    }
    
    /// Returns dictionary representation for template engine
    func toDictionary() -> [String: Any] {
        return [
            "original": original,
            "rfc3339": rfc3339,
            "condensed": condensed,
            "short": short,
            "medium": medium,
            "long": long,
            "year": year,
            "month": month
        ]
    }
}

/// Check if a date is older than 6 months
/// Used for marking outdated content
public func isDateOlderThanSixMonths(_ date: Date) -> Bool {
    let sixMonthsAgo = Calendar.current.date(byAdding: .month, value: -6, to: Date())!
    return date < sixMonthsAgo
}

/// Check if a DateFormat is older than 6 months
public func isDateOlderThanSixMonths(_ dateFormat: DateFormat) -> Bool {
    return isDateOlderThanSixMonths(dateFormat.original)
}

// MARK: - Date Extensions

extension Date {
    /// Get the year component of the date
    func year() -> Int {
        return Calendar.current.component(.year, from: self)
    }
    
    /// Get the month component of the date
    func month() -> Int {
        return Calendar.current.component(.month, from: self)
    }
}


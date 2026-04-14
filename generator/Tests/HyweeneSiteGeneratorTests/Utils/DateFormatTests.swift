import Foundation
import Testing
@testable import HyweeneSiteGenerator

// MARK: - Parsing ISO8601 Dates

@Test("Test_DateFormat_Parse_ISO8601_With_Colon_Timezone")
func parseISO8601WithColonTimezone() {
    // Test: "2020-08-27T09:30:00+01:00"
    let dateString = "2020-08-27T09:30:00+01:00"
    let dateFormat = DateFormat(from: dateString)
    
    #expect(dateFormat != nil, "Should parse ISO8601 date with colon in timezone")
    #expect(dateFormat?.short == "2020-08-27")
}

@Test("Test_DateFormat_Parse_ISO8601_Without_Colon_Timezone")
func parseISO8601WithoutColonTimezone() {
    // Test: "2020-08-27T09:30:00+0100"
    let dateString = "2020-08-27T09:30:00+0100"
    let dateFormat = DateFormat(from: dateString)
    
    #expect(dateFormat != nil, "Should parse ISO8601 date without colon in timezone")
    #expect(dateFormat?.short == "2020-08-27")
}

@Test("Test_DateFormat_Parse_ISO8601_Without_Timezone")
func parseISO8601WithoutTimezone() {
    // Test: "2020-08-27T09:30:00"
    let dateString = "2020-08-27T09:30:00"
    let dateFormat = DateFormat(from: dateString)
    
    #expect(dateFormat != nil, "Should parse ISO8601 date without timezone")
    #expect(dateFormat?.short == "2020-08-27")
}

@Test("Test_DateFormat_Parse_Simple_Date")
func parseSimpleDate() {
    // Test: "2020-08-27"
    let dateString = "2020-08-27"
    let dateFormat = DateFormat(from: dateString)
    
    #expect(dateFormat != nil, "Should parse simple date format")
    #expect(dateFormat?.short == "2020-08-27")
}

@Test("Test_DateFormat_Parse_Now_Keyword")
func parseNowKeyword() {
    // Test: "now"
    let dateFormat = DateFormat(from: "now")
    
    #expect(dateFormat != nil, "Should parse 'now' keyword")
    
    let calendar = Calendar.current
    let today = Date()
    let parsedYear = dateFormat?.year ?? 0
    let expectedYear = calendar.component(.year, from: today)
    
    #expect(parsedYear == expectedYear, "Should use current date for 'now'")
}

@Test("Test_DateFormat_Parse_Invalid_Date")
func parseInvalidDate() {
    // Test invalid date strings
    let invalidDates = [
        "not-a-date",
        "2020-13-45",  // Invalid month/day
        "abc123",
        ""
    ]
    
    for invalidDate in invalidDates {
        let dateFormat = DateFormat(from: invalidDate)
        #expect(dateFormat == nil, "Should return nil for invalid date: '\(invalidDate)'")
    }
}

// MARK: - Date Format Outputs

@Test("Test_DateFormat_Outputs")
func dateFormatOutputs() {
    // Create a known date: August 27, 2020 at 09:30:00 UTC
    let dateString = "2020-08-27T09:30:00+00:00"
    guard let dateFormat = DateFormat(from: dateString) else {
        Issue.record("Failed to parse test date")
        return
    }
    
    // Test short format (YYYY-MM-DD)
    #expect(dateFormat.short == "2020-08-27")
    
    // Test year
    #expect(dateFormat.year == 2020)
    
    // Test RFC3339 format contains the date
    #expect(dateFormat.rfc3339.contains("2020-08-27"))
    
    // Test long format (French locale, contains month name)
    #expect(dateFormat.long.contains("août") || dateFormat.long.contains("2020"))
}

@Test("Test_DateFormat_Init_With_Date")
func dateInitWithDate() {
    // Test creating DateFormat from Date object (used by Yams)
    let calendar = Calendar.current
    var components = DateComponents()
    components.year = 2020
    components.month = 8
    components.day = 27
    components.hour = 9
    components.minute = 30
    components.timeZone = TimeZone(secondsFromGMT: 0)
    
    guard let date = calendar.date(from: components) else {
        Issue.record("Failed to create test date")
        return
    }
    
    let dateFormat = DateFormat(date)
    
    #expect(dateFormat.year == 2020)
    #expect(dateFormat.short == "2020-08-27")
}

@Test("Test_DateFormat_Init_Default")
func dateInitDefault() {
    // Test creating DateFormat without parameters (uses current date)
    let dateFormat = DateFormat()
    
    let calendar = Calendar.current
    let today = Date()
    let expectedYear = calendar.component(.year, from: today)
    
    #expect(dateFormat.year == expectedYear)
}

// MARK: - Dictionary Conversion

@Test("Test_DateFormat_To_Dictionary")
func toDictionary() {
    let dateString = "2020-08-27T09:30:00+01:00"
    guard let dateFormat = DateFormat(from: dateString) else {
        Issue.record("Failed to parse test date")
        return
    }
    
    let dict = dateFormat.toDictionary()
    
    // Verify all expected keys exist
    #expect(dict["original"] != nil)
    #expect(dict["rfc3339"] != nil)
    #expect(dict["condensed"] != nil)
    #expect(dict["short"] != nil)
    #expect(dict["medium"] != nil)
    #expect(dict["long"] != nil)
    #expect(dict["year"] != nil)
    #expect(dict["month"] != nil)
    
    // Verify types
    #expect(dict["original"] is Date)
    #expect(dict["short"] is String)
    #expect(dict["year"] is Int)
    
    // Verify values
    #expect(dict["short"] as? String == "2020-08-27")
    #expect(dict["year"] as? Int == 2020)
}

// MARK: - Date Extensions

@Test("Test_DateFormat_Date_Year_Extension")
func dateYearExtension() {
    let calendar = Calendar.current
    var components = DateComponents()
    components.year = 2020
    components.month = 8
    components.day = 27
    
    guard let date = calendar.date(from: components) else {
        Issue.record("Failed to create test date")
        return
    }
    
    #expect(date.year() == 2020)
}

@Test("Test_DateFormat_Date_Month_Extension")
func dateMonthExtension() {
    let calendar = Calendar.current
    var components = DateComponents()
    components.year = 2020
    components.month = 8
    components.day = 27
    
    guard let date = calendar.date(from: components) else {
        Issue.record("Failed to create test date")
        return
    }
    
    #expect(date.month() == 8)
}

// MARK: - Outdated Check

@Test("Test_DateFormat_Is_Date_Older_Than_Six_Months_Old_Date")
func isDateOlderThanSixMonths_OldDate() {
    // Create a date 1 year ago
    let calendar = Calendar.current
    let oneYearAgo = calendar.date(byAdding: .year, value: -1, to: Date())!
    
    #expect(isDateOlderThanSixMonths(oneYearAgo))
}

@Test("Test_DateFormat_Is_Date_Older_Than_Six_Months_Recent_Date")
func isDateOlderThanSixMonths_RecentDate() {
    // Create a date 1 month ago
    let calendar = Calendar.current
    let oneMonthAgo = calendar.date(byAdding: .month, value: -1, to: Date())!
    
    #expect(isDateOlderThanSixMonths(oneMonthAgo) == false)
}

@Test("Test_DateFormat_Is_Date_Older_Than_Six_Months_DateFormat")
func isDateOlderThanSixMonths_DateFormat() {
    // Test with DateFormat object
    let calendar = Calendar.current
    let oneYearAgo = calendar.date(byAdding: .year, value: -1, to: Date())!
    let oldDateFormat = DateFormat(oneYearAgo)
    
    #expect(isDateOlderThanSixMonths(oldDateFormat))
}

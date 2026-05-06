import Foundation
import Testing

@testable import HyweeneSiteGenerator

struct ModelsTests {
    @Test("BlogPostCategory has correct properties")
    func blogPostCategoryProperties() {
        let category = BlogPostCategory(name: "Swift")

        #expect(category.name == "Swift")
        #expect(category.slug == "swift")
    }

    @Test("DateFormat toDictionary returns all fields")
    func dateFormatToDictionary() {
        let date = DateFormat(from: "2026-01-15T10:30:00+00:00")
        let dict = date?.toDictionary()

        #expect(dict?["rfc3339"] as? String != nil)
        #expect(dict?["year"] as? Int != nil)
        #expect(dict?["month"] as? String != nil)
        #expect(dict?["short"] as? String != nil)
    }

    @Test("isDateOlderThanSixMonths returns correct result")
    func dateOlderThanSixMonths() {
        let calendar = Calendar.current
        let oldDate = calendar.date(byAdding: .month, value: -7, to: Date())!
        let recentDate = calendar.date(byAdding: .month, value: -3, to: Date())!

        #expect(isDateOlderThanSixMonths(oldDate))
        #expect(!isDateOlderThanSixMonths(recentDate))
    }
}

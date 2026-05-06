import Foundation

/// Domain use case that orchestrates the full links generation pipeline.
///
/// Loads links via `LinkContentRepository`, renders templates via
/// `TemplateRepository`, and writes output through `FileRepository`.
public struct GenerateLinksUseCase: Sendable {
    private let contentRepository: any LinkContentRepository
    private let fileRepository: any FileRepository
    private let templateRepository: any TemplateRepository

    /// - Parameters:
    ///   - contentRepository: Source of validated `LinkItemEntity` objects.
    ///   - fileRepository: Sink for rendered HTML/XML output.
    ///   - templateRepository: Renderer for Stencil templates.
    public init(
        contentRepository: any LinkContentRepository,
        fileRepository: any FileRepository,
        templateRepository: any TemplateRepository
    ) {
        self.contentRepository = contentRepository
        self.fileRepository = fileRepository
        self.templateRepository = templateRepository
    }

    // MARK: - Execution

    /// Run the full links generation pipeline and return a result summary.
    @discardableResult
    public nonisolated func execute() throws -> BuildLinksResult {
        let links = try contentRepository.loadLinks()

        try writeLinks(links)
        try writeLinksListFile(links)
        try writeRSSFeed(links)
        try writeSitemap(links)

        print("✅ Links generation complete! (\(links.count) links)")
        return BuildLinksResult(links: links)
    }

    // MARK: - Individual Link Pages

    private func writeLinks(_ links: [LinkItemEntity]) throws {
        try runConcurrently(
            operations: links.map { link in
                {
                    let context: [String: Any] = [
                        "page_title": link.title,
                        "link": link.toDictionary(),
                    ]
                    let html = try self.templateRepository.render(
                        template: "links/single.stencil", context: context)
                    try self.fileRepository.writeFile(
                        content: html,
                        to: "liens/\(link.path)/index.html")
                    print("🔗 Writing link page: liens/\(link.path)/index.html")
                }
            })
    }

    // MARK: - Links List

    private func writeLinksListFile(_ links: [LinkItemEntity]) throws {
        let yearGroups = groupLinksByYearAndMonth(links)
        let context: [String: Any] = [
            "page_title": "Liens",
            "links_by_year": yearGroups,
        ]
        let html = try templateRepository.render(template: "links/list.stencil", context: context)
        try fileRepository.writeFile(content: html, to: "liens/index.html")
        print("📋 Writing link list: liens/index.html")
    }

    // MARK: - RSS Feed

    private func writeRSSFeed(_ links: [LinkItemEntity]) throws {
        let context: [String: Any] = [
            "links": links.map { $0.toDictionary() },
            "last_link": links.first?.toDictionary() ?? [:],
        ]
        let xml = try templateRepository.render(template: "links/feed.xml", context: context)
        try fileRepository.writeFile(content: xml, to: "liens/feed.xml")
        print("📡 Writing links RSS feed: liens/feed.xml")
    }

    // MARK: - Sitemap

    private func writeSitemap(_ links: [LinkItemEntity]) throws {
        let context: [String: Any] = [
            "links": links.map { $0.toDictionary() }
        ]
        let xml = try templateRepository.render(template: "links/sitemap.xml", context: context)
        try fileRepository.writeFile(content: xml, to: "liens/sitemap.xml")
        print("🗺️  Writing links sitemap: liens/sitemap.xml")
    }

    // MARK: - Grouping

    private func groupLinksByYearAndMonth(_ links: [LinkItemEntity]) -> [[String: Any]] {
        var linksByYear: [Int: [Int: [LinkItemEntity]]] = [:]

        for link in links {
            let year = link.publishDate.original.year()
            let month = link.publishDate.original.month()

            if linksByYear[year] == nil {
                linksByYear[year] = [:]
            }
            if linksByYear[year]![month] == nil {
                linksByYear[year]![month] = []
            }
            linksByYear[year]![month]!.append(link)
        }

        return linksByYear.keys.sorted(by: >).map { year in
            let monthsDict = linksByYear[year] ?? [:]

            let monthGroups: [[String: Any]] = monthsDict.keys.sorted(by: >).compactMap {
                monthNumber in
                guard let monthLinks = monthsDict[monthNumber], !monthLinks.isEmpty else {
                    return nil
                }
                let monthName = monthDisplayName(from: monthLinks.first!.publishDate.month)

                let sortedLinks = monthLinks.sorted {
                    $0.publishDate.original > $1.publishDate.original
                }

                return [
                    "month_name": monthName,
                    "links": sortedLinks.map { $0.toDictionary() },
                ]
            }

            return [
                "year": year,
                "months": monthGroups,
            ]
        }
    }

    private func monthDisplayName(from monthField: String) -> String {
        let parts = monthField.split(separator: "-")
        guard parts.count > 1 else { return "" }
        return String(parts[1]).capitalized
    }
}

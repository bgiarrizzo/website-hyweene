import Foundation

/// Links content generator
public class LinksGenerator: Generator {
    public var links: [LinkItem] = []
    
    public init() {}
    
    // MARK: - Generator Protocol
    
    public func generate() throws {
        print("#", String(repeating: "-", count: 80))
        print("Generating links...")
        
        // Discover and process all links
        try loadLinks()
        print("✅ Links loaded successfully")
        
        // Write individual link pages
        try writeLinks()
        print("✅ Individual link pages written successfully")
        
        // Write links list page        
        try writeLinkListFile()
        print("✅ Links list page written successfully")
        
        // Write RSS feed
        try writeRSSFeed()
        print("✅ RSS feed written successfully")
        
        // Write sitemap
        try writeSitemap()
        print("✅ Sitemap written successfully")
        
        print("✅ Links generation complete!")
    }
    
    // MARK: - Link Loading
    
    private func loadLinks() throws {
        let fm = FileManager.default
        let linksPath = Config.linksPath
        let linkFiles = fm.getAllFiles(from: linksPath, withExtension: ".md")
        
        var loadedLinks: [LinkItem] = []
        
        for linkFile in linkFiles {
            let link = try LinkItem(filePath: linkFile.path)
            loadedLinks.append(link)
        }
        
        // Sort by publish date (newest first)
        self.links = loadedLinks.sorted {
            guard let date1 = $0.publishDate?.original,
                  let date2 = $1.publishDate?.original else {
                return false
            }
            return date1 > date2
        }
        
        print("🔗 Loaded \(links.count) links")
    }
    
    // MARK: - File Writing
    
    private func writeLinks() throws {
        for link in links {
            try link.writeLinkPage()
        }
    }
    
    private func writeLinkListFile() throws {
        // Group links by year, then by month
        var linksByYear: [Int: [Int: [LinkItem]]] = [:]
        
        for link in links {
            guard let year = link.publishDate?.original.year(),
                  let month = link.publishDate?.original.month() else {
                continue
            }
            
            if linksByYear[year] == nil {
                linksByYear[year] = [:]
            }
            if linksByYear[year]![month] == nil {
                linksByYear[year]![month] = []
            }
            linksByYear[year]![month]!.append(link)
        }
        
        // Convert to sorted array structure for template
        var yearGroups: [[String: Any]] = []
        
        for year in linksByYear.keys.sorted(by: >) {
            guard let monthsDict = linksByYear[year] else { continue }
            
            var monthGroups: [[String: Any]] = []
            
            for monthNum in monthsDict.keys.sorted(by: >) {
                guard let monthLinks = monthsDict[monthNum], !monthLinks.isEmpty else { continue }
                
                // Get month name from first link's publish date
                let monthName: String
                if let firstLink = monthLinks.first,
                   let publishDate = firstLink.publishDate {
                    let parts = publishDate.month.split(separator: "-")
                    monthName = parts.count > 1 ? String(parts[1]).capitalized : ""
                } else {
                    monthName = ""
                }
                
                let sortedLinks = monthLinks.sorted {
                    let date1 = $0.publishDate?.original ?? Date.distantPast
                    let date2 = $1.publishDate?.original ?? Date.distantPast
                    return date1 > date2
                }
                
                monthGroups.append([
                    "month_name": monthName,
                    "links": sortedLinks.map { $0.toDictionary() }
                ])
            }
            
            yearGroups.append([
                "year": year,
                "months": monthGroups
            ])
        }
        
        let data: [[String: Any]] = [
            [
                "page_title": "Liens",
                "links_by_year": yearGroups
            ]
        ]
        
        let filename = "liens/index.html"
        print("📋 Writing link list: \(filename)")
        
        try writeFile(dataList: data, template: "links/list.stencil", to: filename)
    }
    
    private func writeRSSFeed() throws {
        let data: [[String: Any]] = [
            [
                "links": links.map { $0.toDictionary() },
                "last_link": links.first?.toDictionary() ?? [:]
            ]
        ]
        
        let filename = "liens/feed.xml"
        print("📡 Writing links RSS feed: \(filename)")
        
        try writeFile(dataList: data, template: "links/feed.xml", to: filename)
    }
    
    private func writeSitemap() throws {
        let data: [[String: Any]] = [
            ["links": links.map { $0.toDictionary() }]
        ]
        
        let filename = "liens/sitemap.xml"
        print("🗺️  Writing links sitemap: \(filename)")
        
        try writeFile(dataList: data, template: "links/sitemap.xml", to: filename)
    }
}

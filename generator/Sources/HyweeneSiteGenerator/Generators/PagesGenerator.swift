import Foundation

/// Pages content generator (about, now, projets, etc.)
public class PagesGenerator: Generator {
    public var pages: [Page] = []
    
    public init() {}
    
    // MARK: - Generator Protocol
    
    public func generate() throws {
        print("#", String(repeating: "-", count: 80))
        print("Processing pages...")
        
        // Discover and process all pages
        try loadPages()
        
        // Write individual pages
        try writePages()
        
        // Write sitemap
        try writeSitemap()
        
        print("✅ Pages generation complete!")
    }
    
    // MARK: - Page Loading
    
    private func loadPages() throws {
        let fm = FileManager.default
        let pagesPath = Config.pagesPath
        let pageFiles = fm.getAllFiles(from: pagesPath, withExtension: ".md")
        
        var loadedPages: [Page] = []
        
        for pageFile in pageFiles {
            let page = try Page(filePath: pageFile.path)
            loadedPages.append(page)
        }
        
        self.pages = loadedPages
        print("📄 Loaded \(pages.count) pages")
    }
    
    // MARK: - File Writing
    
    private func writePages() throws {
        for page in pages {
            try page.writePage()
        }
    }
    
    private func writeSitemap() throws {
        let data: [[String: Any]] = [
            ["pages": pages.map { $0.toDictionary() }]
        ]
        
        let filename = "sitemap-pages.xml"
        print("🗺️  Writing pages sitemap: \(filename)")
        
        try writeFile(dataList: data, template: "page/sitemap.xml", to: filename)
    }
}

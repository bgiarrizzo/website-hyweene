import Foundation

/// Sitemap and robots.txt generator
public class SitemapGenerator: Generator {
    public init() {}
    
    // MARK: - Generator Protocol
    
    public func generate() throws {
        print("#", String(repeating: "-", count: 80))
        print("Building sitemaps and robots.txt...")
        
        try writeSitemapIndex()
        try writeRobotsTxt()
        
        print("✅ Sitemaps generation complete!")
    }
    
    // MARK: - File Writing
    
    private func writeSitemapIndex() throws {
        // List of sitemap files to include in the index
        let sitemaps = [
            "blog",
            "liens",
            "apprendre"
        ]
        
        let data: [[String: Any]] = [
            ["sitemaps": sitemaps]
        ]
        
        let filename = "sitemap-index.xml"
        print("🗺️  Writing sitemap index: \(filename)")
        
        try writeFile(dataList: data, template: "sitemap-index.xml", to: filename)
    }
    
    private func writeRobotsTxt() throws {
        let data: [[String: Any]] = [
            [:]  // No specific data needed, template uses site context
        ]
        
        let filename = "robots.txt"
        print("🤖 Writing robots.txt: \(filename)")
        
        try writeFile(dataList: data, template: "robots.txt.stencil", to: filename)
    }
}

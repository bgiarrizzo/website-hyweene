import Foundation

/// Homepage generator (combines blog + links)
public class HomepageGenerator: Generator {
    let blogGenerator: BlogGenerator
    let linksGenerator: LinksGenerator
    
    public init(blog: BlogGenerator, links: LinksGenerator) {
        self.blogGenerator = blog
        self.linksGenerator = links
    }
    
    // MARK: - Generator Protocol
    
    public func generate() throws {
        print("#", String(repeating: "-", count: 80))
        print("Building homepage...")
        
        try writeHomepage()
        
        print("✅ Homepage generation complete!")
    }
    
    // MARK: - File Writing
    
    private func writeHomepage() throws {
        // Get latest posts and links
        let latestPosts = Array(blogGenerator.posts.prefix(10))
        let latestLinks = Array(linksGenerator.links.prefix(10))
        
        let data: [[String: Any]] = [
            [
                "page_title": Config.name,
                "latest_posts": latestPosts.map { $0.toDictionary() },
                "latest_links": latestLinks.map { $0.toDictionary() }
            ]
        ]
        
        let filename = "index.html"
        print("🏠 Writing homepage: \(filename)")
        
        try writeFile(dataList: data, template: "homepage.stencil", to: filename)
    }
}

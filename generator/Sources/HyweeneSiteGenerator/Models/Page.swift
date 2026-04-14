import Foundation

/// Represents a static page (about, now, projets, etc.)
public class Page {
    let filePath: String
    var title: String?
    var body: String = ""
    var permalink: String = ""  // URL slug (e.g., "about", "now", "projets")
    var slug: String?
    var summary: String = ""
    var cover: String?
    
    init(filePath: String) throws {
        self.filePath = filePath
        try processFile()
    }
    
    // MARK: - File Processing
    
    private func processFile() throws {
        let data = try parseMarkdownFile(filePath)
        
        self.title = data["title"] as? String
        self.body = data["body"] as? String ?? ""
        self.permalink = data["permalink"] as? String ?? ""
        self.summary = data["summary"] as? String ?? ""
        self.cover = data["cover"] as? String
        
        // Slug from title
        if let title = self.title {
            self.slug = slugify(title)
        }
    }
    
    // MARK: - Template Data
    
    func toDictionary() -> [String: Any] {
        var dict: [String: Any] = [
            "title": title ?? "",
            "body": body,
            "permalink": permalink,
            "slug": slug ?? "",
            "summary": summary
        ]
        
        if let cover = cover {
            dict["cover"] = cover
        }
        
        return dict
    }
    
    // MARK: - File Writing
    
    func writePage() throws {
        guard let title = self.title else {
            throw NSError(domain: "Page", code: 1, userInfo: [
                NSLocalizedDescriptionKey: "Missing title"
            ])
        }
        
        let data: [[String: Any]] = [
            ["page_title": title],
            ["page": toDictionary()]
        ]
        
        // Filename based on permalink
        let filename: String
        if permalink.isEmpty {
            filename = "index.html"
            print("📄 Writing homepage: \(title)")
        } else {
            filename = "\(permalink)/index.html"
            print("📄 Writing page: \(slug ?? permalink)")
        }
        
        try writeFile(dataList: data, template: "page/main.stencil", to: filename)
    }
}

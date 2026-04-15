import Foundation

/// Represents a link item (curated external link)
public class LinkItem {
    let filePath: String
    var title: String?
    var url: String?
    var path: String?  // YYYY-MM-DD-slug
    var description: String = ""
    var publishDate: DateFormat?
    var updateDate: DateFormat?
    var body: String = ""
    var slug: String?
    
    init(filePath: String) throws {
        self.filePath = filePath
        try processFile()
    }
    
    // MARK: - File Processing
    
    private func processFile() throws {
        let data = try parseMarkdownFile(filePath)
        
        self.title = data["title"] as? String
        self.url = data["url"] as? String
        self.body = data["body"] as? String ?? ""
        self.description = data["description"] as? String ?? ""
        
        // Publish date
        if let publishDateStr = data["publish_date"] as? String {
            self.publishDate = DateFormat(from: publishDateStr) ?? DateFormat()
        } else if let publishDateObj = data["publish_date"] as? Date {
            self.publishDate = DateFormat(publishDateObj)
        } else {
            self.publishDate = DateFormat()
        }
        
        // Slug
        if let title = self.title {
            self.slug = slugify(title)
        }
        
        // Path: YYYY-MM-DD-slug
        if let publishDate = self.publishDate, let slug = self.slug {
            self.path = "\(publishDate.short)-\(slug)"
        }
    }
    
    // MARK: - Template Data
    
    func toDictionary() -> [String: Any] {
        var dict: [String: Any] = [
            "title": title ?? "",
            "url": url ?? "",
            "description": description,
            "body": body,
            "slug": slug ?? "",
            "path": path ?? ""
        ]
        
        if let publishDate = publishDate {
            dict["publish_date"] = publishDate.toDictionary()
        }
        
        if let updateDate = updateDate {
            dict["update_date"] = updateDate.toDictionary()
            // Only show update date if it's different from publish date
            let showUpdateDate = updateDate.short != (publishDate?.short ?? "")
            dict["show_update_date"] = showUpdateDate
        }
        
        // Check if URL points to an image
        if let url = url?.lowercased() {
            let isImage = url.hasSuffix(".jpg") || url.hasSuffix(".jpeg") || 
                         url.hasSuffix(".png") || url.hasSuffix(".gif")
            dict["is_image"] = isImage
        } else {
            dict["is_image"] = false
        }
        
        return dict
    }
    
    // MARK: - File Writing
    
    func writeLinkPage() throws {
        guard let title = self.title, let path = self.path else {
            throw NSError(domain: "LinkItem", code: 1, userInfo: [
                NSLocalizedDescriptionKey: "Missing title or path"
            ])
        }
        
        print("🔗 Writing link page: liens/\(path)/index.html")
        
        let dict = toDictionary()
        let data: [[String: Any]] = [
            ["page_title": title],
            ["link": dict]
        ]
        
        let filename = "liens/\(path)/index.html"
        
        try writeFile(dataList: data, template: "links/single.stencil", to: filename)
        print("✅ Written: \(filename)")
    }
}

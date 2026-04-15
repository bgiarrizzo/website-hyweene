import Foundation

// MARK: - Blog Post Category

/// Represents a blog post category
public struct BlogPostCategory {
    let name: String
    let slug: String
    
    init(name: String) {
        self.name = name
        self.slug = slugify(name)
    }
    
    /// Convert to dictionary for templates
    func toDictionary() -> [String: Any] {
        return [
            "name": name,
            "slug": slug
        ]
    }
}

// MARK: - Blog Post

/// Represents a blog post with metadata and content
public class BlogPost {
    let filePath: String
    var title: String?
    var slug: String?
    var body: String = ""
    var summary: String = ""
    var publishDate: DateFormat?
    var updateDate: DateFormat?
    var category: BlogPostCategory?
    var tags: [String] = []
    var readingTime: Int = 1  // in minutes
    var path: String?  // YYYY-MM-DD-slug
    var prismNeeded: Bool = false
    var cover: String?
    var draft: Bool = false
    var tocHTML: String?
    
    init(filePath: String) throws {
        self.filePath = filePath
        try processFile()
    }
    
    // MARK: - File Processing
    
    /// Parse markdown file and populate fields
    private func processFile() throws {
        let data = try parseMarkdownFile(filePath)
        
        // Title
        self.title = data["title"] as? String
        
        // Body
        self.body = data["body"] as? String ?? ""
        
        // Category
        let categoryName = data["category"] as? String ?? "Uncategorized"
        self.category = BlogPostCategory(name: categoryName)
        
        // Publish date
        if let publishDateStr = data["publish_date"] as? String {
            self.publishDate = DateFormat(from: publishDateStr) ?? DateFormat()
        } else if let publishDateObj = data["publish_date"] as? Date {
            // Yams parses ISO dates as Date objects directly
            self.publishDate = DateFormat(publishDateObj)
        } else {
            self.publishDate = DateFormat()
        }
        
        // Draft status
        self.draft = data["draft"] as? Bool ?? false
        
        // Slug
        if let title = self.title {
            self.slug = slugify(title)
        }
        
        // Summary
        self.summary = data["summary"] as? String ?? ""
        
        // Tags
        if let tags = data["tags"] as? [String] {
            self.tags = tags
        }
        
        // Update date (fallback to publish date)
        if let updateDateStr = data["update_date"] as? String {
            self.updateDate = DateFormat(from: updateDateStr)
        } else if let updateDateObj = data["update_date"] as? Date {
            self.updateDate = DateFormat(updateDateObj)
        }
        if self.updateDate == nil {
            self.updateDate = self.publishDate
        }
        
        // Prism syntax highlighting
        self.prismNeeded = data["prism_needed"] as? Bool ?? false
        
        // Cover image
        self.cover = data["cover"] as? String
        
        // Reading time (simple calculation: words / 200 wpm)
        self.readingTime = body.estimatedReadingTime()
        
        // Path: YYYY-MM-DD-slug
        if let publishDate = self.publishDate, let slug = self.slug {
            self.path = "\(publishDate.short)-\(slug)"
        }
        
        // Table of contents (if available)
        self.tocHTML = data["toc_html"] as? String
    }
    
    // MARK: - Template Data
    
    /// Convert to dictionary for templates
    func toDictionary() -> [String: Any] {
        var dict: [String: Any] = [
            "title": title ?? "",
            "slug": slug ?? "",
            "body": body,
            "summary": summary,
            "tags": tags,
            "reading_time": formatReadingTime(readingTime),
            "prism_needed": prismNeeded,
            "draft": draft,
            "path": path ?? ""
        ]
        
        if let publishDate = publishDate {
            dict["publish_date"] = publishDate.toDictionary()
        }
        
        if let updateDate = updateDate {
            dict["update_date"] = updateDate.toDictionary()
        }
        
        if let category = category {
            dict["category"] = category.toDictionary()
        }
        
        if let cover = cover {
            dict["cover"] = cover
        }
        
        if let toc = tocHTML {
            dict["toc_html"] = toc
        }
        
        return dict
    }
    
    /// Format reading time for display
    private func formatReadingTime(_ minutes: Int) -> String {
        if minutes == 1 {
            return "1 minute"
        } else {
            return "\(minutes) minutes"
        }
    }
    
    // MARK: - File Writing
    
    /// Write blog post to HTML file
    func writePostFile() throws {
        guard let path = self.path, let title = self.title else {
            throw NSError(domain: "BlogPost", code: 1, userInfo: [
                NSLocalizedDescriptionKey: "Missing required fields (path or title)"
            ])
        }
        
        let data: [[String: Any]] = [
            ["page_title": "\(title) - Blog"],
            ["post": toDictionary()]
        ]
        
        let filename = "blog/\(path)/index.html"
        print("✍️  Writing blog post: \(filename)")
        
        try writeFile(dataList: data, template: "blog/single.stencil", to: filename)
    }
}

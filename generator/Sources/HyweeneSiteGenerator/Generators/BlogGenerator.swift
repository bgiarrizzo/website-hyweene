import Foundation

/// Blog content generator
public class BlogGenerator: Generator {
    public var posts: [BlogPost] = []
    public var categories: [BlogPostCategory] = []
    
    public init() {}
    
    // MARK: - Generator Protocol
    
    public func generate() throws {
        print("#", String(repeating: "-", count: 80))
        print("Processing blog data...")
        
        // Discover and process all blog posts
        try loadPosts()
        
        // Extract unique categories
        extractCategories()
        
        // Write individual posts
        try writePosts()
        
        // Write blog list page
        try writePostListFile()
        
        // Write category pages
        try writeCategoryPages()
        
        // Write RSS feed
        try writeRSSFeed()
        
        // Write sitemap
        try writeSitemap()
        
        print("✅ Blog generation complete!")
    }
    
    // MARK: - Post Loading
    
    private func loadPosts() throws {
        let fm = FileManager.default
        let blogPath = Config.blogPath
        let postFiles = fm.getAllFiles(from: blogPath, withExtension: ".md")
        
        var loadedPosts: [BlogPost] = []
        
        for postFile in postFiles {
            // Skip draft folder
            if postFile.path.contains("/draft/") {
                continue
            }
            
            let post = try BlogPost(filePath: postFile.path)
            
            // Skip draft posts
            if post.draft {
                continue
            }
            
            loadedPosts.append(post)
        }
        
        // Sort by publish date (newest first)
        self.posts = loadedPosts.sorted {
            guard let date1 = $0.publishDate?.original,
                  let date2 = $1.publishDate?.original else {
                return false
            }
            return date1 > date2
        }
        
        print("📝 Loaded \(posts.count) blog posts")
    }
    
    private func extractCategories() {
        var categoryMap: [String: BlogPostCategory] = [:]
        
        for post in posts {
            if let category = post.category {
                categoryMap[category.slug] = category
            }
        }
        
        self.categories = Array(categoryMap.values).sorted { $0.name < $1.name }
        print("📂 Found \(categories.count) categories")
    }
    
    // MARK: - File Writing
    
    private func writePosts() throws {
        for post in posts {
            try post.writePostFile()
        }
    }
    
    private func writePostListFile() throws {
        // Group posts by year (descending)
        var postsByYear: [Int: [BlogPost]] = [:]
        for post in posts {
            if let year = post.publishDate?.original.year() {
                postsByYear[year, default: []].append(post)
            }
        }
        
        // Convert to sorted array of dictionaries for template
        let yearGroups = postsByYear.keys.sorted(by: >).map { year in
            [
                "year": year,
                "posts": postsByYear[year]!
                    .sorted { ($0.publishDate?.original ?? Date()) > ($1.publishDate?.original ?? Date()) }
                    .map { $0.toDictionary() }
            ]
        }
        
        let data: [[String: Any]] = [
            [
                "page_title": "Blog",
                "posts_by_year": yearGroups,
                "categories": categories.map { $0.toDictionary() }
            ]
        ]
        
        let filename = "blog/index.html"
        print("📋 Writing blog post list: \(filename)")
        
        try writeFile(dataList: data, template: "blog/list.stencil", to: filename)
    }
    
    private func writeCategoryPages() throws {
        for category in categories {
            let filteredPosts = posts.filter { $0.category?.slug == category.slug }
            
            // Group filtered posts by year (descending)
            var postsByYear: [Int: [BlogPost]] = [:]
            for post in filteredPosts {
                if let year = post.publishDate?.original.year() {
                    postsByYear[year, default: []].append(post)
                }
            }
            
            // Convert to sorted array of dictionaries for template
            let yearGroups = postsByYear.keys.sorted(by: >).map { year in
                [
                    "year": year,
                    "posts": postsByYear[year]!
                        .sorted { ($0.publishDate?.original ?? Date()) > ($1.publishDate?.original ?? Date()) }
                        .map { $0.toDictionary() }
                ]
            }
            
            let data: [[String: Any]] = [
                [
                    "page_title": "Blog - \(category.name)",
                    "posts_by_year": yearGroups,
                    "category": category.toDictionary(),
                    "categories": categories.map { $0.toDictionary() }
                ]
            ]
            
            let filename = "blog/category/\(category.slug)/index.html"
            print("📂 Writing category page: \(filename)")
            
            try writeFile(dataList: data, template: "blog/list.stencil", to: filename)
        }
    }
    
    private func writeRSSFeed() throws {
        // Get sorted posts (already sorted by date descending)
        let sortedPosts = posts.filter { !$0.draft }
        
        let data: [[String: Any]] = [
            [
                "posts": sortedPosts.map { $0.toDictionary() },
                "last_post": sortedPosts.first?.toDictionary() ?? [:]
            ]
        ]
        
        let filename = "blog/feed.xml"
        print("📡 Writing blog RSS feed: \(filename)")
        
        try writeFile(dataList: data, template: "blog/feed.xml", to: filename)
    }
    
    private func writeSitemap() throws {
        let data: [[String: Any]] = [
            ["posts": posts.map { $0.toDictionary() }]
        ]
        
        let filename = "blog/sitemap.xml"
        print("🗺️  Writing blog sitemap: \(filename)")
        
        try writeFile(dataList: data, template: "blog/sitemap.xml", to: filename)
    }
}

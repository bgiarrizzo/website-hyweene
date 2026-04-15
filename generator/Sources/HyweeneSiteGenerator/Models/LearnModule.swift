import Foundation
import Yams

// MARK: - Learn Module Page

/// Represents a single page in a learning module
public class LearnModulePage {
    let filePath: String
    weak var module: LearnModule?  // Weak reference to avoid retain cycle
    
    var id: Int?
    var title: String?
    var slug: String?
    var summary: String = ""
    var publishDate: DateFormat?
    var updateDate: DateFormat?
    var toc: String = ""  // Table of contents HTML
    var body: String = ""
    var prismNeeded: Bool = false
    var disabled: Bool = false
    
    init(filePath: String, module: LearnModule) throws {
        self.filePath = filePath
        self.module = module
        try processFile()
    }
    
    // MARK: - File Processing
    
    private func processFile() throws {
        let data = try parseMarkdownFile(filePath)
        
        self.id = data["id"] as? Int
        self.title = data["title"] as? String
        
        if let title = self.title {
            self.slug = slugify(title)
        }
        
        self.summary = data["summary"] as? String ?? ""
        
        // Publish date
        if let publishDateStr = data["publish_date"] as? String {
            self.publishDate = DateFormat(from: publishDateStr) ?? DateFormat()
        } else if let publishDateObj = data["publish_date"] as? Date {
            self.publishDate = DateFormat(publishDateObj)
        } else {
            self.publishDate = DateFormat()
        }
        
        // Update date (fallback to publish date)
        if let updateDateStr = data["update_date"] as? String {
            self.updateDate = DateFormat(from: updateDateStr)
        } else if let updateDateObj = data["update_date"] as? Date {
            self.updateDate = DateFormat(updateDateObj)
        } else {
            self.updateDate = self.publishDate
        }
        
        self.toc = data["toc_html"] as? String ?? ""
        self.body = data["body"] as? String ?? ""
        self.prismNeeded = data["prism_needed"] as? Bool ?? false
        self.disabled = data["disabled"] as? Bool ?? false
    }
    
    // MARK: - Template Data
    
    func toDictionary() -> [String: Any] {
        var dict: [String: Any] = [
            "title": title ?? "",
            "slug": slug ?? "",
            "summary": summary,
            "toc": toc,
            "body": body,
            "prism_needed": prismNeeded,
            "disabled": disabled
        ]
        
        if let id = id {
            dict["id"] = id
        }
        
        if let publishDate = publishDate {
            dict["publish_date"] = publishDate.toDictionary()
        }
        
        if let updateDate = updateDate {
            dict["update_date"] = updateDate.toDictionary()
        }
        
        // Include only basic module info to avoid infinite recursion
        if let module = module {
            dict["module"] = [
                "name": module.name ?? "",
                "slug": module.slug ?? "",
                "description": module.description,
                "id": module.id ?? 0
            ]
        }
        
        return dict
    }
    
    // MARK: - File Writing
    
    func writeModulePage() throws {
        guard let module = self.module,
              let moduleSlug = module.slug,
              let slug = self.slug else {
            throw NSError(domain: "LearnModulePage", code: 1, userInfo: [
                NSLocalizedDescriptionKey: "Missing module or page slug"
            ])
        }
        
        let data: [[String: Any]] = [
            ["learn": toDictionary()]
        ]
        
        let filename = "apprendre/\(moduleSlug)/\(slug)/index.html"
        print("📚 Writing learning page: \(filename)")
        
        try writeFile(dataList: data, template: "learn/page.stencil", to: filename)
    }
}

// MARK: - Learn Module

/// Represents a learning module (e.g., Git, Python, Swift)
public class LearnModule {
    let filePath: String
    var id: Int?
    var name: String?
    var slug: String?
    var logo: String?
    var description: String = ""
    var disabled: Bool = false
    var modulePath: String = ""
    public var pages: [LearnModulePage] = []
    
    init(filePath: String) throws {
        self.filePath = filePath
        try processFile()
    }
    
    // MARK: - File Processing
    
    private func processFile() throws {
        // Read YAML file (module.yml)
        let fileURL = URL(fileURLWithPath: filePath)
        let yamlContent = try String(contentsOf: fileURL, encoding: .utf8)
        
        guard let data = try Yams.load(yaml: yamlContent) as? [String: Any] else {
            throw NSError(domain: "LearnModule", code: 1, userInfo: [
                NSLocalizedDescriptionKey: "Invalid YAML in module file"
            ])
        }
        
        self.id = data["id"] as? Int
        self.name = data["name"] as? String
        
        if let name = self.name {
            self.slug = slugify(name)
        }
        
        self.logo = data["logo"] as? String
        self.description = data["description"] as? String ?? ""
        self.disabled = data["disabled"] as? Bool ?? false
        
        // Module path is the directory containing module.yml
        self.modulePath = URL(fileURLWithPath: filePath).deletingLastPathComponent().path
    }
    
    // MARK: - Page Management
    
    /// Load all pages for this module
    func loadPages() throws {
        let fm = FileManager.default
        let modulePages = fm.getAllFiles(from: modulePath, withExtension: ".md")
        
        var loadedPages: [LearnModulePage] = []
        
        for pageFile in modulePages {
            let page = try LearnModulePage(filePath: pageFile.path, module: self)
            
            // Skip disabled pages
            if page.disabled {
                continue
            }
            
            loadedPages.append(page)
        }
        
        // Sort by ID
        self.pages = loadedPages.sorted { ($0.id ?? 0) < ($1.id ?? 0) }
    }
    
    // MARK: - Template Data
    
    func toDictionary() -> [String: Any] {
        var dict: [String: Any] = [
            "name": name ?? "",
            "slug": slug ?? "",
            "description": description,
            "disabled": disabled,
            "pages": pages.map { $0.toDictionary() }
        ]
        
        if let id = id {
            dict["id"] = id
        }
        
        if let logo = logo {
            dict["logo"] = logo
        }
        
        return dict
    }
    
    // MARK: - File Writing
    
    func writeTableOfContents() throws {
        guard let slug = self.slug else {
            throw NSError(domain: "LearnModule", code: 1, userInfo: [
                NSLocalizedDescriptionKey: "Missing module slug"
            ])
        }

        print("📖 Writing TOC for module: \(name ?? "Unnamed")")
        
        let data: [[String: Any]] = [
            ["module": toDictionary()]
        ]
        
        let filename = "apprendre/\(slug)/index.html"
        print("📖 Writing learning module TOC: \(filename)")
        
        try writeFile(dataList: data, template: "learn/toc.stencil", to: filename)
    }
}

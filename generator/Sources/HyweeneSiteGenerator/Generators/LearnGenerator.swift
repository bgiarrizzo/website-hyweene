import Foundation

/// Learn modules content generator
public class LearnGenerator: Generator {
    public var modules: [LearnModule] = []
    
    public init() {}
    
    // MARK: - Generator Protocol
    
    public func generate() throws {
        print("#", String(repeating: "-", count: 80))
        print("Processing learning modules...")
        
        // Discover and process all modules
        try loadModules()
        
        // Write module pages
        try writeModulePages()
        
        // Write modules list
        try writeModulesListFile()
        
        // Write sitemap
        try writeSitemap()
        
        print("✅ Learning modules generation complete!")
    }
    
    // MARK: - Module Loading
    
    private func loadModules() throws {
        let fm = FileManager.default
        let learnPath = Config.learnPath
        let moduleFiles = fm.getAllFiles(from: learnPath, withExtension: ".yml")
        
        var loadedModules: [LearnModule] = []
        
        for moduleFile in moduleFiles {
            print("📂 Loading module: \(moduleFile.path)"
            )
            let module = try LearnModule(filePath: moduleFile.path)
            
            // Skip disabled modules
            if module.disabled {
                continue
            }
            
            // Load pages for this module
            try module.loadPages()
            
            loadedModules.append(module)
        }
        
        // Sort by ID
        self.modules = loadedModules.sorted { ($0.id ?? 0) < ($1.id ?? 0) }
        print("📚 Loaded \(modules.count) learning modules")
    }
    
    // MARK: - File Writing
    
    private func writeModulePages() throws {
        for module in modules {
            // Write table of contents
            try module.writeTableOfContents()
            
            // Write individual pages
            for page in module.pages {
                try page.writeModulePage()
            }
        }
    }
    
    private func writeModulesListFile() throws {
        let data: [[String: Any]] = [
            [
                "page_title": "Table des matières - Apprendre",
                "table_of_contents": modules.map { $0.toDictionary() }
            ]
        ]
        
        let filename = "apprendre/index.html"
        print("📋 Writing modules list: \(filename)")
        
        try writeFile(dataList: data, template: "learn/list.stencil", to: filename)
    }
    
    private func writeSitemap() throws {
        let data: [[String: Any]] = [
            ["modules": modules.map { $0.toDictionary() }]
        ]
        
        let filename = "apprendre/sitemap.xml"
        print("🗺️  Writing learning sitemap: \(filename)")
        
        try writeFile(dataList: data, template: "learn/sitemap.xml", to: filename)
    }
}

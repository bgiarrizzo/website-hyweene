import Foundation

/// Build metrics produced by a full site generation run.
public struct BuildSummary: Sendable {
    public let blogPosts: Int
    public let links: Int
    public let pages: Int
    public let learningModules: Int
    public let learningPages: Int
    public let categories: Int

    public init(
        blogPosts: Int,
        links: Int,
        pages: Int,
        learningModules: Int,
        learningPages: Int,
        categories: Int
    ) {
        self.blogPosts = blogPosts
        self.links = links
        self.pages = pages
        self.learningModules = learningModules
        self.learningPages = learningPages
        self.categories = categories
    }
}

/// Build the full website and release it.
/// - Returns: A `BuildSummary` with key generation metrics.
/// - Throws: Any generation, rendering, or filesystem error.
@discardableResult
public func buildSite() throws -> BuildSummary {
    print("🚀 Site Generator Starting...")
    print("📍 Base URL: \(Config.baseURL)")
    print("📂 Release Path: \(Config.releasePath)")
    print("")

    let fm = FileManager.default

    print("#", String(repeating: "=", count: 80))
    print("# Step 1: Copying media and static files")
    print("#", String(repeating: "=", count: 80))

    print("📦 Copying media files...")
    try fm.copyDirectory(from: Config.mediaPath, to: "\(Config.releasePath)/media")

    print("📦 Copying static files...")
    try fm.copyDirectory(from: Config.staticPath, to: "\(Config.releasePath)/static")
    print("")

    // Preload the template engine once before parallel rendering starts.
    _ = try getTemplateEngine()

    print("#", String(repeating: "=", count: 80))
    print("# Step 2: Generating independent content in parallel")
    print("#", String(repeating: "=", count: 80))

    let blogGenerator = BlogGenerator()
    let linksGenerator = LinksGenerator()
    let pagesGenerator = PagesGenerator()
    let learnGenerator = LearnGenerator()
    let resumeGenerator = ResumeGenerator()

    try runConcurrently(operations: [
        { try blogGenerator.generate() },
        { try linksGenerator.generate() },
        { try pagesGenerator.generate() },
        { try learnGenerator.generate() },
        { try resumeGenerator.generate() },
    ])
    print("")

    print("#", String(repeating: "=", count: 80))
    print("# Step 3: Generating homepage")
    print("#", String(repeating: "=", count: 80))

    let homepageGenerator = HomepageGenerator(blog: blogGenerator, links: linksGenerator)
    try homepageGenerator.generate()
    print("")

    print("#", String(repeating: "=", count: 80))
    print("# Step 4: Generating sitemaps and robots")
    print("#", String(repeating: "=", count: 80))

    let sitemapGenerator = SitemapGenerator()
    try sitemapGenerator.generate()
    print("")

    print("#", String(repeating: "=", count: 80))
    print("# Step 5: Releasing site")
    print("#", String(repeating: "=", count: 80))

    print("🔗 Creating symlink...")
    try releaseSite()
    print("")

    let summary = BuildSummary(
        blogPosts: blogGenerator.posts.count,
        links: linksGenerator.links.count,
        pages: pagesGenerator.pages.count,
        learningModules: learnGenerator.modules.count,
        learningPages: learnGenerator.modules.reduce(0) { $0 + $1.pages.count },
        categories: blogGenerator.categories.count
    )

    print("#", String(repeating: "=", count: 80))
    print("# ✅ Site Generation Complete!")
    print("#", String(repeating: "=", count: 80))
    print("")
    print("📊 Statistics:")
    print("  • Blog posts: \(summary.blogPosts)")
    print("  • Links: \(summary.links)")
    print("  • Pages: \(summary.pages)")
    print("  • Learning modules: \(summary.learningModules)")
    print("  • Learning module pages: \(summary.learningPages)")
    print("  • Categories: \(summary.categories)")
    print("")
    print("🎉 Site ready at: \(Config.currentReleasePath) -> \(Config.releasePath)")

    return summary
}

import Foundation
import HyweeneSiteGenerator

print("🚀 Site Generator Starting...")
print("📍 Base URL: \(Config.baseURL)")
print("📂 Release Path: \(Config.releasePath)")
print("")

do {
    let fm = FileManager.default

    // MARK: - Step 1: Copy Media and Static Files

    print("#", String(repeating: "=", count: 80))
    print("# Step 1: Copying media and static files")
    print("#", String(repeating: "=", count: 80))

    // Copy media
    print("📦 Copying media files...")
    try fm.copyDirectory(
        from: Config.mediaPath,
        to: "\(Config.releasePath)/media"
    )

    // Copy static
    print("📦 Copying static files...")
    try fm.copyDirectory(
        from: Config.staticPath,
        to: "\(Config.releasePath)/static"
    )

    print("")

    // MARK: - Step 2: Generate Blog

    print("#", String(repeating: "=", count: 80))
    print("# Step 2: Generating Blog")
    print("#", String(repeating: "=", count: 80))

    let blogGenerator = BlogGenerator()
    try blogGenerator.generate()
    print("")

    // MARK: - Step 3: Generate Links

    print("#", String(repeating: "=", count: 80))
    print("# Step 3: Generating Links")
    print("#", String(repeating: "=", count: 80))

    let linksGenerator = LinksGenerator()
    try linksGenerator.generate()
    print("")

    // MARK: - Step 4: Generate Pages

    print("#", String(repeating: "=", count: 80))
    print("# Step 4: Generating Pages")
    print("#", String(repeating: "=", count: 80))

    let pagesGenerator = PagesGenerator()
    try pagesGenerator.generate()
    print("")

    // MARK: - Step 5: Generate Learning Modules

    print("#", String(repeating: "=", count: 80))
    print("# Step 5: Generating Learning Modules")
    print("#", String(repeating: "=", count: 80))

    let learnGenerator = LearnGenerator()
    try learnGenerator.generate()
    print("")

    // MARK: - Step 6: Generate Resume

    print("#", String(repeating: "=", count: 80))
    print("# Step 6: Generating Resume")
    print("#", String(repeating: "=", count: 80))

    let resumeGenerator = ResumeGenerator()
    try resumeGenerator.generate()
    print("")

    // MARK: - Step 7: Generate Homepage

    print("#", String(repeating: "=", count: 80))
    print("# Step 7: Generating Homepage")
    print("#", String(repeating: "=", count: 80))

    let homepageGenerator = HomepageGenerator(blog: blogGenerator, links: linksGenerator)
    try homepageGenerator.generate()
    print("")

    // MARK: - Step 8: Generate Sitemaps

    print("#", String(repeating: "=", count: 80))
    print("# Step 8: Generating Sitemaps & Robots.txt")
    print("#", String(repeating: "=", count: 80))

    let sitemapGenerator = SitemapGenerator()
    try sitemapGenerator.generate()
    print("")

    // MARK: - Step 9: Release Site

    print("#", String(repeating: "=", count: 80))
    print("# Step 9: Releasing Site")
    print("#", String(repeating: "=", count: 80))

    print("🔗 Creating symlink...")
    try releaseSite()
    print("")

    // MARK: - Success

    print("#", String(repeating: "=", count: 80))
    print("# ✅ Site Generation Complete!")
    print("#", String(repeating: "=", count: 80))
    print("")
    print("📊 Statistics:")
    print("  • Blog posts: \(blogGenerator.posts.count)")
    print("  • Links: \(linksGenerator.links.count)")
    print("  • Pages: \(pagesGenerator.pages.count)")
    print("  • Learning modules: \(learnGenerator.modules.count)")
    print("  • Learning module pages: \(learnGenerator.modules.reduce(0) { $0 + $1.pages.count })")
    print("  • Categories: \(blogGenerator.categories.count)")
    print("")
    print("🎉 Site ready at: \(Config.currentReleasePath) -> \(Config.releasePath)")

} catch {
    print("")
    print("❌ Error: \(error)")
    print("")
    exit(1)
}

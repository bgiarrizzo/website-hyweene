import Foundation

/// Domain use case that orchestrates the full blog generation pipeline.
///
/// Loads posts via `ContentRepository`, renders HTML via `TemplateRepository`,
/// and writes output via `FileRepository`. All I/O is injected, keeping the
/// business logic independently testable.
public struct GenerateBlogUseCase: Sendable {
    private let contentRepository: any ContentRepository
    private let fileRepository: any FileRepository
    private let templateRepository: any TemplateRepository

    /// - Parameters:
    ///   - contentRepository: Source of validated `BlogPostEntity` objects.
    ///   - fileRepository: Sink for rendered HTML/XML output.
    ///   - templateRepository: Renderer for Stencil templates.
    public init(
        contentRepository: any ContentRepository,
        fileRepository: any FileRepository,
        templateRepository: any TemplateRepository
    ) {
        self.contentRepository = contentRepository
        self.fileRepository = fileRepository
        self.templateRepository = templateRepository
    }

    // MARK: - Execution

    /// Run the full blog generation pipeline and return a result summary.
    ///
    /// Generates individual post pages, the post list, category pages, RSS feed,
    /// and the blog sitemap.
    ///
    /// - Returns: A `BuildBlogResult` with non-draft posts and extracted categories.
    /// - Throws: Any I/O or template-rendering error.
    @discardableResult
    public nonisolated func execute() throws -> BuildBlogResult {
        let allPosts = try contentRepository.loadBlogPosts()
        let posts = allPosts.filter { !$0.draft }
        let categories = extractCategories(from: posts)

        try writePosts(posts)
        try writePostListFile(posts: posts, categories: categories)
        try writeCategoryPages(posts: posts, categories: categories)
        try writeRSSFeed(posts: posts)
        try writeSitemap(posts: posts)

        print("✅ Blog generation complete! (\(posts.count) posts, \(categories.count) categories)")
        return BuildBlogResult(posts: posts, categories: categories)
    }

    // MARK: - Category Extraction

    private func extractCategories(from posts: [BlogPostEntity]) -> [BlogPostCategory] {
        var seen: [String: BlogPostCategory] = [:]
        for post in posts {
            seen[post.category.slug] = post.category
        }
        return Array(seen.values).sorted { $0.name < $1.name }
    }

    // MARK: - Individual Posts

    private func writePosts(_ posts: [BlogPostEntity]) throws {
        try runConcurrently(
            operations: posts.map { post in
                {
                    let context: [String: Any] = [
                        "page_title": "\(post.title) - Blog",
                        "post": post.toDictionary(),
                    ]
                    let html = try self.templateRepository.render(
                        template: "blog/single.stencil", context: context)
                    try self.fileRepository.writeFile(
                        content: html, to: "blog/\(post.path)/index.html")
                    print("✍️  Writing blog post: blog/\(post.path)/index.html")
                }
            })
    }

    // MARK: - Post List

    private func writePostListFile(
        posts: [BlogPostEntity], categories: [BlogPostCategory]
    ) throws {
        let yearGroups = groupPostsByYear(posts)
        let context: [String: Any] = [
            "page_title": "Blog",
            "posts_by_year": yearGroups,
            "categories": categories.map { $0.toDictionary() },
        ]
        let html = try templateRepository.render(template: "blog/list.stencil", context: context)
        try fileRepository.writeFile(content: html, to: "blog/index.html")
        print("📋 Writing blog post list: blog/index.html")
    }

    // MARK: - Category Pages

    private func writeCategoryPages(
        posts: [BlogPostEntity], categories: [BlogPostCategory]
    ) throws {
        let allCategoryDicts = categories.map { $0.toDictionary() }
        try runConcurrently(
            operations: categories.map { category in
                {
                    let filtered = posts.filter { $0.category.slug == category.slug }
                    let yearGroups = self.groupPostsByYear(filtered)
                    let context: [String: Any] = [
                        "page_title": "Blog - \(category.name)",
                        "posts_by_year": yearGroups,
                        "category": category.toDictionary(),
                        "categories": allCategoryDicts,
                    ]
                    let html = try self.templateRepository.render(
                        template: "blog/list.stencil", context: context)
                    try self.fileRepository.writeFile(
                        content: html,
                        to: "blog/category/\(category.slug)/index.html")
                    print("📂 Writing category page: blog/category/\(category.slug)/index.html")
                }
            })
    }

    // MARK: - RSS Feed

    private func writeRSSFeed(posts: [BlogPostEntity]) throws {
        let context: [String: Any] = [
            "posts": posts.map { $0.toDictionary() },
            "last_post": posts.first?.toDictionary() ?? [:],
        ]
        let xml = try templateRepository.render(template: "blog/feed.xml", context: context)
        try fileRepository.writeFile(content: xml, to: "blog/feed.xml")
        print("📡 Writing blog RSS feed: blog/feed.xml")
    }

    // MARK: - Sitemap

    private func writeSitemap(posts: [BlogPostEntity]) throws {
        let context: [String: Any] = [
            "posts": posts.map { $0.toDictionary() }
        ]
        let xml = try templateRepository.render(template: "blog/sitemap.xml", context: context)
        try fileRepository.writeFile(content: xml, to: "blog/sitemap.xml")
        print("🗺️  Writing blog sitemap: blog/sitemap.xml")
    }

    // MARK: - Helpers

    private func groupPostsByYear(_ posts: [BlogPostEntity]) -> [[String: Any]] {
        var byYear: [Int: [BlogPostEntity]] = [:]
        for post in posts {
            byYear[post.publishDate.year, default: []].append(post)
        }
        return byYear.keys.sorted(by: >).map { year in
            [
                "year": year,
                "posts": byYear[year]!
                    .sorted { $0.publishDate.original > $1.publishDate.original }
                    .map { $0.toDictionary() },
            ]
        }
    }
}

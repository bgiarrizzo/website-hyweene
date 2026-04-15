import Foundation
import Testing
@testable import HyweeneSiteGenerator

// MARK: - Generators Tests

@Test("BlogGenerator initializes correctly")
func blogGeneratorInitialization() {
    let generator = BlogGenerator()
    
    #expect(generator.posts.isEmpty)
    #expect(generator.categories.isEmpty)
}

@Test("LinksGenerator initializes correctly")
func linksGeneratorInitialization() {
    let generator = LinksGenerator()
    
    #expect(generator.links.isEmpty)
}

@Test("PagesGenerator initializes correctly")
func pagesGeneratorInitialization() {
    let generator = PagesGenerator()
    
    #expect(generator.pages.isEmpty)
}

@Test("LearnGenerator initializes correctly")
func learnGeneratorInitialization() {
    let generator = LearnGenerator()
    
    #expect(generator.modules.isEmpty)
}

@Test("ResumeGenerator initializes correctly")
func resumeGeneratorInitialization() {
    let generator = ResumeGenerator()
    
    #expect(generator.resume == nil)
}

@Test("SitemapGenerator initializes correctly")
func sitemapGeneratorInitialization() {
    let generator = SitemapGenerator()
    
    // Verify it initializes successfully
    #expect(type(of: generator) == SitemapGenerator.self)
}

@Test("HomepageGenerator requires blog and links generators")
func homepageGeneratorInitialization() {
    let blog = BlogGenerator()
    let links = LinksGenerator()
    let generator = HomepageGenerator(blog: blog, links: links)
    
    #expect(type(of: generator) == HomepageGenerator.self)
}

@Test("All generators conform to Generator protocol")
func generatorsConformToProtocol() {
    let generators: [any Generator] = [
        BlogGenerator(),
        LinksGenerator(),
        PagesGenerator(),
        LearnGenerator(),
        ResumeGenerator(),
        SitemapGenerator()
    ]
    
    #expect(generators.count == 6)
}

import Foundation
import Testing

@testable import HyweeneSiteGenerator

// MARK: - Configuration Tests

@Test("Config uses default values when environment is empty")
func configUsesDefaultValues() {
    #expect(!Config.scheme.isEmpty)
    #expect(["http", "https"].contains(Config.scheme))
    #expect(!Config.shortURL.isEmpty)
    #expect(Config.name == "Bruno Giarrizzo")
    #expect(Config.language == "fr-FR")
    #expect(Config.keywords.contains("Python"))
    #expect(Config.keywords.contains("Swift"))
}

@Test("Config paths are correctly composed")
func configPathsAreCorrect() {
    #expect(Config.mediaPath.contains("content"))
    #expect(Config.blogPath.contains("blog"))
    #expect(Config.learnPath.contains("learn"))
    #expect(Config.pagesPath.contains("pages"))
    #expect(Config.linksPath.contains("links"))
    #expect(Config.resumePath.contains("resume"))
}

@Test("Config author info is present")
func configAuthorInfoIsPresent() {
    #expect(!Config.name.isEmpty)
    #expect(!Config.author.isEmpty)
    #expect(Config.githubLink.starts(with: "https://"))
    #expect(Config.linkedInLink.starts(with: "https://"))
}

@Test("Config site context returns valid dictionary")
func configSiteContextIsValid() {
    let context = Config.siteContext()

    #expect(context["url"] as? String == Config.baseURL)
    #expect(context["name"] as? String == Config.name)
    #expect(context["author"] as? String == Config.author)
    #expect(context["description"] as? String == Config.description)
    #expect(context["language"] as? String == Config.language)

    let keywords = context["keywords"] as? [String]
    #expect(keywords != nil)
    #expect(keywords?.isEmpty == false)

    let colors = context["colors"] as? [String: String]
    #expect(colors != nil)
    #expect(colors?["body_background_color"] != nil)
}

@Test("Config colors are valid hex codes")
func configColorsAreValidHex() {
    let context = Config.siteContext()
    let colors = context["colors"] as? [String: String]

    #expect(colors != nil)

    for (_, color) in colors ?? [:] {
        #expect(color.starts(with: "#"))
        #expect(color.count == 7)
    }
}

@Test("Gruvbox colors are defined")
func gruvboxColorsAreDefined() {
    #expect(Gruvbox.bg == "#282828")
    #expect(Gruvbox.fg == "#fbf1c7")
    #expect(Gruvbox.red == "#fb4934")
    #expect(Gruvbox.green == "#b8bb26")
    #expect(Gruvbox.blue == "#83a598")
    #expect(Gruvbox.yellow == "#fabd2f")
}

@Test("Config release paths are properly structured")
func configReleasePathsAreStructured() {
    #expect(Config.releasesPath.hasSuffix("releases"))
    #expect(Config.releasePath.contains("/"))
    #expect(Config.currentReleasePath.hasSuffix("current"))
    #expect(!Config.releaseTimestamp.isEmpty)
}

@Test("Config URL structure is correct")
func configURLStructureIsCorrect() {
    #expect(Config.baseURL.starts(with: Config.scheme))
    #expect(Config.baseURL.contains(Config.longURL))
    #expect(Config.longURL.contains(Config.shortURL))
}

// MARK: - Configuration Tests

struct ConfigTests {
    @Test("TEST_Config_Use_default_values_when_environment_is_empty")
    func configUsesDefaultValues() {
        // Config values can be overridden by environment. Validate non-empty coherent values.
        #expect(!Config.scheme.isEmpty)
        #expect(["http", "https"].contains(Config.scheme))
        #expect(!Config.shortURL.isEmpty)
        #expect(Config.name == "Bruno Giarrizzo")
        #expect(Config.language == "fr-FR")
        #expect(Config.keywords.contains("Python"))
        #expect(Config.keywords.contains("Swift"))
    }

    @Test("TEST_Config_Paths_are_correctly_composed")
    func configPathsAreCorrect() {
        // Test that paths are correctly built from base paths
        #expect(Config.mediaPath.contains("content"))
        #expect(Config.blogPath.contains("blog"))
        #expect(Config.learnPath.contains("learn"))
    }

    @Test("TEST_Config_Author_info_is_present")
    func configAuthorInfoIsPresent() {
        #expect(!Config.name.isEmpty)
        #expect(!Config.author.isEmpty)
        #expect(Config.githubLink.starts(with: "https://"))
        #expect(Config.linkedInLink.starts(with: "https://"))
    }

    @Test("TEST_Config_site_context_returns_valid_dictionary")
    func configSiteContextIsValid() {
        let context = Config.siteContext()

        #expect(context["url"] as? String == Config.baseURL)
        #expect(context["name"] as? String == Config.name)
        #expect(context["author"] as? String == Config.author)
        #expect(context["description"] as? String == Config.description)
        #expect(context["language"] as? String == Config.language)

        let keywords = context["keywords"] as? [String]
        #expect(keywords != nil)
        #expect(keywords?.isEmpty == false)

        let colors = context["colors"] as? [String: String]
        #expect(colors != nil)
        #expect(colors?["body_background_color"] != nil)
    }

    @Test("TEST_Config_colors_are_valid_hex_codes")
    func configColorsAreValidHex() {
        let context = Config.siteContext()
        let colors = context["colors"] as? [String: String]

        #expect(colors != nil)

        for (_, color) in colors ?? [:] {
            #expect(color.starts(with: "#"))
            #expect(color.count == 7)  // #RRGGBB format
        }
    }

    @Test("TEST_Config_Gruvbox_colors_are_defined")
    func gruvboxColorsAreDefined() {
        // Verify Gruvbox palette is accessible
        #expect(Gruvbox.bg == "#282828")
        #expect(Gruvbox.fg == "#fbf1c7")
        #expect(Gruvbox.red == "#fb4934")
        #expect(Gruvbox.green == "#b8bb26")
        #expect(Gruvbox.blue == "#83a598")
        #expect(Gruvbox.yellow == "#fabd2f")
    }

}

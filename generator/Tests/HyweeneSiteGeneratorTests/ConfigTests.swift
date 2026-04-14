import Foundation
import Testing

@testable import HyweeneSiteGenerator

// MARK: - Configuration Tests

struct ConfigTests {
    @Test("TEST_Config_Use_default_values_when_environment_is_empty")
    func configUsesDefaultValues() {
        setenv("SITE_SCHEME", "", 1)
        setenv("SITE_SHORT_URL", "", 1)
        
        // When no environment variables are set, Config should use defaults
        #expect(Config.scheme == "https")
        #expect(Config.shortURL == "hyweene.fr")
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
            #expect(color.count == 7) // #RRGGBB format
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

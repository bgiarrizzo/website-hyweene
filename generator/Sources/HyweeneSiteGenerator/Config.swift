import Foundation

// MARK: - Gruvbox Color Palette
public struct Gruvbox {
    public static let bgH = "#1d2021"
    public static let bg = "#282828"
    public static let bgS = "#32302f"
    public static let bg1 = "#3c3836"
    public static let bg2 = "#504945"
    public static let bg3 = "#665c54"
    public static let bg4 = "#7c6f64"
    public static let fg = "#fbf1c7"
    public static let fg1 = "#ebdbb2"
    public static let fg2 = "#d5c4a1"
    public static let fg3 = "#bdae93"
    public static let fg4 = "#a89984"
    public static let aquaDim = "#689d6a"
    public static let aqua = "#8ec07c"
    public static let blueDim = "#458588"
    public static let blue = "#83a598"
    public static let grayDim = "#a89984"
    public static let gray = "#928374"
    public static let greenDim = "#98971a"
    public static let green = "#b8bb26"
    public static let orangeDim = "#d65d0e"
    public static let orange = "#fe8019"
    public static let purpleDim = "#b16286"
    public static let purple = "#d3869b"
    public static let redDim = "#cc2412"
    public static let red = "#fb4934"
    public static let yellowDim = "#d79921"
    public static let yellow = "#fabd2f"
}

// MARK: - Site Configuration
public struct Config {
    // URL Configuration
    public static let scheme = "https"
    public static let shortURL = "hyweene.fr"
    public static let longURL = "www.\(shortURL)"
    public static let baseURL = "\(scheme)://\(longURL)"
    
    // Paths - Updated for new structure
    public static let releaseTimestamp = DateFormatter.timestamp.string(from: Date())
    public static let releasesPath = "releases"
    public static let releasePath = "\(releasesPath)/\(releaseTimestamp)"
    public static let currentReleasePath = "build"  // Symlink name (changed from "current")
    
    public static let siteContentPath = "content"  // New: base content directory
    public static let mediaPath = "\(siteContentPath)/media"
    public static let staticPath = "\(siteContentPath)/static"
    
    public static let templatePath = "generator/Templates"  // New: templates in generator/
    
    public static let contentPath = "\(siteContentPath)/text"
    public static let blogPath = "\(contentPath)/blog"
    public static let linksPath = "\(contentPath)/links"
    public static let pagesPath = "\(contentPath)/pages"
    public static let resumePath = "\(contentPath)/resume"
    public static let learnPath = "\(contentPath)/learn"
    
    // Author Information
    public static let name = "Bruno Giarrizzo"
    public static let author = "Bruno 'Hyweene' Giarrizzo"
    public static let githubLink = "https://github.com/bgiarrizzo/"
    public static let linkedInLink = "https://www.linkedin.com/in/bruno-giarrizzo/"
    
    // Site Metadata
    public static let description = "Linuxien, Developpeur Python, Swift et DevOps"
    public static let keywords = [
        "Bruno",
        "Giarrizzo",
        "Hyweene",
        "Bruno Giarrizzo",
        "Developpeur",
        "Linuxien",
        "DevOps",
        "Ethical Hacker",
        "Python",
        "Swift",
        "FastAPI",
        "Kubernetes",
        "Terraform",
        "Helm",
        "Docker"
    ]
    public static let language = "fr-FR"
    public static let locale = "fr_FR.UTF-8"
    
    // MARK: - Color Theme (Gruvbox)
    struct Colors {
        public static let blockquoteBackgroundColor = Gruvbox.bg1
        public static let blockquoteFontColor = Gruvbox.fg1
        public static let bodyBackgroundColor = Gruvbox.bgH
        public static let bodyFontColor = Gruvbox.fg1
        public static let bodyLinkColor = Gruvbox.blueDim
        public static let codeBackgroundColor = Gruvbox.bg2
        public static let codeFontColor = Gruvbox.fg1
        public static let codeBorderColor = Gruvbox.fg4
        public static let navLinkColor = Gruvbox.greenDim
        public static let headerTitleFontColor = Gruvbox.redDim
        public static let outdatedResourceBackgroundColor = Gruvbox.bg1
        public static let outdatedResourceFontColor = Gruvbox.red
        public static let headingH1FontColor = Gruvbox.red
        public static let headingH2FontColor = Gruvbox.orange
        public static let headingH3FontColor = Gruvbox.yellow
        public static let headingH4FontColor = Gruvbox.green
        public static let headingH5FontColor = Gruvbox.blue
        public static let headingH6FontColor = Gruvbox.purple
        public static let microblogPostBorderColor = Gruvbox.fg3
        public static let microblogListHeaderBorderColor = Gruvbox.fg2
        public static let microblogPostFooterColor = Gruvbox.fg4
        
        // Convert to dictionary for template engine
        static func toDictionary() -> [String: String] {
            return [
                "blockquote_background_color": blockquoteBackgroundColor,
                "blockquote_font_color": blockquoteFontColor,
                "body_background_color": bodyBackgroundColor,
                "body_font_color": bodyFontColor,
                "body_link_color": bodyLinkColor,
                "code_background_color": codeBackgroundColor,
                "code_font_color": codeFontColor,
                "code_border_color": codeBorderColor,
                "nav_link_color": navLinkColor,
                "header_title_font_color": headerTitleFontColor,
                "outdated_resource_background_color": outdatedResourceBackgroundColor,
                "outdated_resource_font_color": outdatedResourceFontColor,
                "heading_h1_font_color": headingH1FontColor,
                "heading_h2_font_color": headingH2FontColor,
                "heading_h3_font_color": headingH3FontColor,
                "heading_h4_font_color": headingH4FontColor,
                "heading_h5_font_color": headingH5FontColor,
                "heading_h6_font_color": headingH6FontColor,
                "microblog_post_border_color": microblogPostBorderColor,
                "microblog_list_header_border_color": microblogListHeaderBorderColor,
                "microblog_post_footer_color": microblogPostFooterColor
            ]
        }
    }
    
    // MARK: - Template Context
    /// Returns the site context dictionary for templates
    static func siteContext() -> [String: Any] {
        return [
            "url": baseURL,
            "short_url": shortURL,
            "name": name,
            "author": author,
            "github_link": githubLink,
            "linkedin_link": linkedInLink,
            "description": description,
            "keywords": keywords,
            "language": language,
            "colors": Colors.toDictionary()
        ]
    }
}

// MARK: - Date Formatter Extensions
extension DateFormatter {
    public static let timestamp: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMddHHmmss"
        formatter.timeZone = TimeZone.current
        return formatter
    }()
}

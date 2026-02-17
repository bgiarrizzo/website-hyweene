import os

from pydantic_settings import BaseSettings

gruvbox = {
    "bg_h": "#1d2021",
    "bg": "#282828",
    "bg_s": "#32302f",
    "bg1": "#3c3836",
    "bg2": "#504945",
    "bg3": "#665c54",
    "bg4": "#7c6f64",
    "fg": "#fbf1c7",
    "fg1": "#ebdbb2",
    "fg2": "#d5c4a1",
    "fg3": "#bdae93",
    "fg4": "#a89984",
    "aqua-dim": "#689d6a",
    "aqua": "#8ec07c",
    "blue-dim": "#458588",
    "blue": "#83a598",
    "gray-dim": "#a89984",
    "gray": "#928374",
    "green-dim": "#98971a",
    "green": "#b8bb26",
    "orange-dim": "#d65d0e",
    "orange": "#fe8019",
    "purple-dim": "#b16286",
    "purple": "#d3869b",
    "red-dim": "#cc2412",
    "red": "#fb4934",
    "yellow-dim": "#d79921",
    "yellow": "#fabd2f",
}


class Settings(BaseSettings):
    """ """

    SCHEME: str = "https"
    SHORT_URL: str = "hyweene.fr"
    LONG_URL: str = f"www.{SHORT_URL}"
    BASE_URL: str = f"{SCHEME}://{LONG_URL}"

    BUILD_PATH: str = "build"
    MEDIA_PATH: str = "media"
    STATIC_PATH: str = "static"

    TEMPLATE_PATH: str = "templates"

    CONTENT_PATH: str = "content"
    BLOG_PATH: str = f"{CONTENT_PATH}/blog"
    LINKS_PATH: str = f"{CONTENT_PATH}/links"
    PAGES_PATH: str = f"{CONTENT_PATH}/pages"
    RESUME_PATH: str = f"{CONTENT_PATH}/resume"
    LEARN_PATH: str = f"{CONTENT_PATH}/learn"

    NAME: str = "Bruno Giarrizzo"
    AUTHOR: str = "Bruno 'Hyweene' Giarrizzo"
    GITHUB_LINK: str = "https://github.com/bgiarrizzo/"
    LINKEDIN_LINK: str = "https://www.linkedin.com/in/bruno-giarrizzo/"

    DESCRIPTION: str = "Linuxien, Developpeur Python, Swift et DevOps"
    KEYWORDS: list = [
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
        "Docker",
    ]
    LANGUAGE: str = "fr-FR"
    LOCALE: str = "fr_FR.UTF-8"

    COLORS: dict = {
        "blockquote_background_color": gruvbox.get("bg1"),
        "blockquote_font_color": gruvbox.get("fg1"),
        "body_background_color": gruvbox.get("bg_h"),
        "body_font_color": gruvbox.get("fg1"),
        "body_link_color": gruvbox.get("blue-dim"),
        "code_background_color": gruvbox.get("bg2"),
        "code_font_color": gruvbox.get("fg1"),
        "code_border_color": gruvbox.get("fg4"),
        "nav_link_color": gruvbox.get("green-dim"),
        "header_title_font_color": gruvbox.get("red-dim"),
        "outdated_resource_background_color": gruvbox.get("bg1"),
        "outdated_resource_font_color": gruvbox.get("red"),
        "heading_h1_font_color": gruvbox.get("red"),
        "heading_h2_font_color": gruvbox.get("orange"),
        "heading_h3_font_color": gruvbox.get("yellow"),
        "heading_h4_font_color": gruvbox.get("green"),
        "heading_h5_font_color": gruvbox.get("blue"),
        "heading_h6_font_color": gruvbox.get("purple"),
        "microblog_post_border_color": gruvbox.get("fg3"),
        "microblog_list_header_border_color": gruvbox.get("fg2"),
        "microblog_post_footer_color": gruvbox.get("fg4"),
    }

    def get_working_directory(self):
        """ """
        return os.getcwd()

    class Config:
        """ """

        # pylint: disable=too-few-public-methods
        case_sensitive = True


settings = Settings()

from typing import Optional

from slugify import slugify

from generators.factory import Factory
from utils.file import get_all_files_from_path, write_file
from utils.markdown import parse_markdown_file_and_convert_to_html


class Pages(Factory):
    def __init__(self, pages: list):
        self.pages = pages

    def write_sitemap(self):
        data = {"pages": self.pages}
        template_name = "page/sitemap.xml"
        filename = "sitemap-pages.xml"

        print(f"Writing pages sitemap: {filename}")
        write_file(data, template_name, filename, filetype="xml")


class Page(Factory):
    def __init__(
        self,
        file_path: str,
    ):
        self.file_path = file_path
        self.title: Optional[str] = None
        self.body: Optional[str] = None
        self.permalink: Optional[str] = None
        self.slug: Optional[str] = None
        self.summary: Optional[str] = None
        self.cover: Optional[str] = None
        self._process_file(file_path)

    def _process_file(self, file_path: str):
        data = parse_markdown_file_and_convert_to_html(file_path)
        self.title = data.get("title")
        self.body = data.get("body", "")
        self.permalink = data.get("permalink", "")
        self.slug = slugify(self.title) if self.title else None
        self.summary = data.get("summary", "")
        self.cover = data.get("cover", "")

    def write_page(self):
        template_name = "page/main.j2"
        data = {"page_title": self.title, "page": self}
        filename = f"{self.permalink}/index.html"

        if self.permalink == "":
            filename = "index.html"
            print(f"Writing page with empty permalink: {self.title}")
        else:
            print(f"Writing page: {self.slug} ...")

        write_file(data=data, template_name=template_name, filename=filename)

    def write_sitemap_xml(self):
        data = {"page": self}
        template_name = "page/sitemap.xml"
        filename = "sitemap-pages.xml"
        print(f"Writing page sitemap: {filename}")
        write_file(data, template_name, filename, filetype="xml")


def process_pages_data(pages_path):
    print("#", "-" * 80)
    print("Generating pages ...")

    pages_list = []

    page_files = get_all_files_from_path(pages_path)

    for page_file in page_files:
        page = Page(file_path=page_file)
        page.write_page()
        pages_list.append(page)

    pages = Pages(pages_list)
    pages.write_sitemap()

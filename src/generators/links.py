from typing import Optional

from slugify import slugify

from generators.factory import Factory
from utils.file import get_all_files_from_path, write_file
from utils.markdown import parse_markdown_file_and_convert_to_html
from utils.date import DateFormat


class Links(Factory):
    def __init__(self, links: list):
        self.links = links

    def write_rss_feed(self):
        data = {"links": self.links}
        template_name = "links/feed.xml"
        filename = "liens/feed.xml"

        print(f"Writing links RSS feed: {filename}")
        write_file(data, template_name, filename, filetype="xml")

    def write_sitemap(self):
        data = {"links": self.links}
        template_name = "links/sitemap.xml"
        filename = "liens/sitemap.xml"

        print(f"Writing links sitemap: {filename}")
        write_file(data, template_name, filename, filetype="xml")

    def write_link_list_file(self):
        data = {"page_title": "Liens", "all_links": self.links}
        template_name = "links/list.j2"
        filename = "liens/index.html"

        print(f"Writing link list: {filename}")
        write_file(data=data, template_name=template_name, filename=filename)
        print("#", "-" * 70)


class LinkItem(Factory):
    def __init__(
        self,
        file_path: str,
    ):
        self.file_path = file_path
        self.title: Optional[str] = None
        self.url: Optional[str] = None
        self.path: Optional[str] = None
        self.description: Optional[str] = None
        self.publish_date: Optional[DateFormat] = None
        self.update_date: Optional[DateFormat] = None
        self.body: Optional[str] = None
        self.slug: Optional[str] = None
        self._process_file()

    def _process_file(self):
        data = parse_markdown_file_and_convert_to_html(self.file_path)
        self.title = data.get("title")
        self.url = data.get("url")
        self.body = data.get("body", "")
        self.description = data.get("description", "")
        self.publish_date = DateFormat(date=data.get("publish_date", "now"))
        self.slug = slugify(self.title) if self.title else None
        self.path = f"{self.publish_date.short}-{self.slug}"

    def write_link_page(self):
        data = {"page_title": self.title, "link": self}
        template_name = "links/single.j2"
        assert self.publish_date is not None
        filename = f"liens/{self.path}/index.html"
        print(f"Writing link page: {filename}")
        write_file(data=data, template_name=template_name, filename=filename)


def process_links_data(links_path):
    print("#", "-" * 80)
    print("Generating links ...")

    links_list = []

    link_files = get_all_files_from_path(links_path)

    for link_file in link_files:
        link = LinkItem(link_file)
        link.write_link_page()
        links_list.append(link)

    links = Links(links_list)
    links.write_rss_feed()
    links.write_sitemap()
    links.write_link_list_file()

    return links

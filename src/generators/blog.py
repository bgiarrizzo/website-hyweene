from typing import Optional

import readtime
from slugify import slugify

from generators.factory import Factory
from utils.file import get_all_files_from_path, write_file
from utils.markdown import parse_markdown_file_and_convert_to_html
from utils.date import DateFormat


class Blog(Factory):
    def __init__(self, posts: list):
        self.posts = posts
        self.categories = self._get_categories()

    def _get_categories(self):
        categories = {}
        for post in self.posts:
            if post.category and post.category.slug not in categories:
                categories[post.category.slug] = post.category
        return list(categories.values())

    def write_post_list_file(self):
        data = {
            "page_title": "Blog",
            "all_posts": self.posts,
            "categories": self.categories,
        }
        template_name = "blog/list.j2"
        filename = "blog/index.html"

        print(f"Writing blog post list: {filename}")
        write_file(data=data, template_name=template_name, filename=filename)

    def write_post_list_by_category_file(self, category):
        filtered_posts = [
            post for post in self.posts if post.category.slug == category.slug
        ]
        data = {
            "page_title": f"Blog - {category.name}",
            "all_posts": filtered_posts,
            "category": category,
            "categories": self.categories,
        }
        template_name = "blog/list.j2"
        filename = f"blog/category/{category.slug}/index.html"

        print(f"Writing blog post list by category: {filename}")
        write_file(data=data, template_name=template_name, filename=filename)

    def write_rss_feed(self):
        data = {"posts": self.posts}
        template_name = "blog/feed.xml"
        filename = "blog/feed.xml"

        print(f"Writing blog RSS feed: {filename}")
        write_file(
            data=data, template_name=template_name, filename=filename, filetype="xml"
        )

    def write_sitemap(self):
        data = {"posts": self.posts}
        template_name = "blog/sitemap.xml"
        filename = "blog/sitemap.xml"

        print(f"Writing blog sitemap: {filename}")
        write_file(data, template_name, filename, filetype="xml")


class BlogPost(Factory):
    def __init__(
        self,
        file_path: str,
    ):
        self.file_path = file_path
        self.body: Optional[str] = None
        self.category: Optional["BlogPostCategory"] = None
        self.content: Optional[str] = None
        self.publish_date: Optional[DateFormat] = None
        self.slug: Optional[str] = None
        self.summary: Optional[str] = None
        self.tags: list = []
        self.title: Optional[str] = None
        self.path: Optional[str] = None
        self.reading_time: Optional[str] = None
        self.update_date: Optional[DateFormat] = None
        self.prism_needed: bool = False
        self.cover: Optional[str] = None
        self.draft: Optional[bool] = False
        self._process_file()

    def _process_file(self):
        data = parse_markdown_file_and_convert_to_html(self.file_path)
        self.title = data.get("title")
        self.body = data.get("body", "")
        category_name = data.get("category", "Uncategorized")
        self.category = BlogPostCategory(name=category_name)
        self.content = data.get("body")
        self.publish_date = DateFormat(date=data.get("publish_date", "now"))
        self.draft = data.get("draft")
        self.slug = slugify(self.title) if self.title else None
        self.summary = data.get("summary", "")
        self.tags = data.get("tags", [])
        update_date = (
            data.get("update_date")
            if data.get("update_date")
            else data.get("publish_date", "now")
        )
        self.update_date = DateFormat(date=update_date)
        self.prism_needed = data.get("prism_needed", False)
        self.cover = data.get("cover", None)
        self.reading_time = readtime.of_text(self.body).text
        self.path = f"{self.publish_date.short}-{self.slug}"

    def write_post_file(self):
        data = {"page_title": f"{self.title} - Blog", "post": self}
        template_name = "blog/single.j2"
        assert self.publish_date is not None
        filename = f"blog/{self.path}/index.html"
        print(f"Writing blog post: {filename}")
        write_file(data=data, template_name=template_name, filename=filename)


class BlogPostCategory(Factory):
    def __init__(self, name: str):
        self.name = name
        self.slug = slugify(name)


def process_blog_data(blog_path):
    print("#", "-" * 80)
    print("Processing blog data ...")

    posts = []

    post_files = get_all_files_from_path(blog_path)

    for post_file in post_files:
        post = BlogPost(file_path=post_file)
        post.write_post_file()
        posts.append(post)

    blog = Blog(posts=posts)
    blog.write_rss_feed()
    blog.write_sitemap()

    blog.write_post_list_file()

    for category in blog.categories:
        blog.write_post_list_by_category_file(category=category)

    return blog

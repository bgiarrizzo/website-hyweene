from utils.file import write_file


class Homepage:
    def __init__(self, posts: list, links: list):
        self.posts = posts
        self.links = links

    def write_homepage(self):
        data = {
            "all_posts": self.posts,
            "all_links": self.links,
        }
        template_name = "homepage.j2"
        filename = "index.html"
        print(f"Writing homepage: {filename}")
        write_file(data=data, template_name=template_name, filename=filename)


def build_homepage(posts: list, links: list):
    print("#", "-" * 80)
    print("Generating homepage ...")

    homepage = Homepage(posts, links)
    homepage.write_homepage()

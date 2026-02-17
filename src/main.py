import locale
import shutil

from config import settings
from generators.homepage import build_homepage
from generators.blog import process_blog_data
from generators.pages import process_pages_data
from generators.links import process_links_data
from generators.learn import process_learn_data
from generators.resume import process_resume_data
from generators.robotstxt import build_robots_txt
from generators.sitemapxml import build_sitemap_index_xml
from utils.collectors import collect_media_files, collect_static_files

locale.setlocale(locale.LC_ALL, settings.LOCALE)

if __name__ == "__main__":
    print("#", "-" * 100)
    print("Cleaning build folder ...")
    shutil.rmtree(settings.BUILD_PATH, ignore_errors=True)

    collect_media_files()
    collect_static_files()

    print("#", "-" * 90)
    print("Building site ...")

    blog = process_blog_data(settings.BLOG_PATH)
    links = process_links_data(settings.LINKS_PATH)

    process_pages_data(settings.PAGES_PATH)
    process_learn_data(settings.LEARN_PATH)
    process_resume_data(settings.RESUME_PATH)

    build_homepage(blog.posts, links.links)

    build_robots_txt(settings.BASE_URL)

    build_sitemap_index_xml(settings.BASE_URL)

    print("#", "-" * 90)
    print("Build completed successfully!")
    print("#", "-" * 100)

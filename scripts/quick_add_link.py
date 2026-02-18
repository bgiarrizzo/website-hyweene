#! /usr/bin/env python3

import requests
import sys

import jinja2
from bs4 import BeautifulSoup
from datetime import datetime
from slugify import slugify
from urllib.parse import urlparse


def get_url_from_args():
    """
    From sys.argv, check if there is only one argument.
    Check if the argument is an url
    return url as string
    """

    args = sys.argv[1:]

    if not args:
        print("No Url Provided for link")
        sys.exit()

    if len(args) > 1:
        print("Too much args provided")
        sys.exit()

    arg = args[0]

    parsed_url = urlparse(arg)

    if not parsed_url.hostname and not parsed_url.scheme:
        print("no url provided")
        sys.exit()

    return arg


def get_html_page(url: str):
    response = requests.get(url)
    response.encoding = "utf-8"
    if response.status_code != 200:
        raise FileNotFoundError

    return response.text


def get_link_title(html_page: str) -> str:
    soup = BeautifulSoup(html_page, "html.parser")
    soup_title = soup.find("title").string
    return str(soup_title)


def get_link_comment() -> str:
    input_comment = input("Your Comment (one line only) : ")
    return input_comment


def craft_link_filename(date: str, slug: str) -> str:
    return f"{date}-{slug}.md"


def generate_markdown_file(link_data: dict):
    templateLoader = jinja2.FileSystemLoader(searchpath="./templates/links/")
    templateEnv = jinja2.Environment(loader=templateLoader)
    TEMPLATE_FILE = "link.md.j2"
    template = templateEnv.get_template(TEMPLATE_FILE)

    outputText = template.render(link=link_data)

    with open(f"content/links/{link_data['filename']}", "w") as f:
        f.write(outputText)


def git_commit_and_push_message(filename: str):
    message = f"""
        git add content/links/{filename}
        git commit -m "add new link - {filename}"
        git push
    """

    print(
        "\nWhen you are done, run the following commands to commit and push your new link :"
    )
    print(f"\n{message}")


if __name__ == "__main__":
    link_data = {}
    link_data["url"] = get_url_from_args()

    html_page = get_html_page(url=link_data["url"])

    link_data["date"] = {}
    link_data["date"]["now"] = datetime.now()
    link_data["date"]["short"] = link_data["date"]["now"].strftime("%Y-%m-%d")
    link_data["date"]["full"] = link_data["date"]["now"].strftime(
        "%Y-%m-%dT%H:%M:%S+01:00"
    )
    link_data["title"] = get_link_title(html_page=html_page)
    link_data["slug"] = slugify(text=link_data["title"])
    link_data["filename"] = craft_link_filename(
        date=link_data["date"]["short"],
        slug=link_data["slug"],
    )
    link_data["comment"] = get_link_comment()
    link_data["date"].pop("now")

    generate_markdown_file(link_data=link_data)

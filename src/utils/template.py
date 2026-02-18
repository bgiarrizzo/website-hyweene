from datetime import datetime
from os import makedirs, path

from jinja2 import Environment, FileSystemLoader

from config import settings
from utils.date import date_older_than_six_months


def write_page(filename, content):
    makedirs(path.dirname(f"{settings.RELEASE_PATH}/{filename}"), exist_ok=True)

    with open(
        f"{settings.RELEASE_PATH}/{filename}", mode="w", encoding="utf-8"
    ) as page:
        page.write(content)


def render_template(template_name, data):
    env = Environment(
        loader=FileSystemLoader(settings.TEMPLATE_PATH),
    )
    env.filters["is_outdated"] = date_older_than_six_months
    env.globals["yearNow"] = datetime.now().year
    template = env.get_template(template_name)
    return template.render(data)


def prepare_template_data(datalist):
    data = {
        "site": {
            "url": settings.BASE_URL,
            "short_url": settings.SHORT_URL,
            "description": settings.DESCRIPTION,
            "language": settings.LANGUAGE,
            "name": settings.NAME,
            "author": settings.AUTHOR,
            "keywords": settings.KEYWORDS,
            "github_link": settings.GITHUB_LINK,
            "linkedin_link": settings.LINKEDIN_LINK,
            "colors": settings.COLORS,
        }
    }

    for item in datalist:
        data = data | item

    return data

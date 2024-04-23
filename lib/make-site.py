#!/usr/bin/env python3

import argparse
import os
import shutil
import urllib.parse

parser = argparse.ArgumentParser(description="Build site for a list of docsets")
parser.add_argument("base_url", metavar="BASE_URL", type=str)
parser.add_argument("docsets", metavar="DOCSET", type=str, nargs="*")
parser.add_argument("--dest-dir", dest="dest_dir", type=str, default="build")
parser.add_argument("--static-dir", dest="static_dir", type=str, default="static")

args = parser.parse_args()
base_url = args.base_url.removesuffix("/")
dest_dir = args.dest_dir
static_dir = args.static_dir


class Docset:
    def __init__(self, path: str) -> None:
        self.path = path
        self.dir, self.base = os.path.split(path)
        self.name, ext = os.path.splitext(self.base)
        assert ext == ".docset"

    def feed_entry(self, feed_url) -> str:
        quoted = urllib.parse.quote(feed_url, safe="")
        dash_uri = f"dash-feed://{quoted}"
        return f'<li><a href="{feed_url}"><code>{self.name}</code></a> (<a href="{dash_uri}">open in Dash</a>)</li>\n'

    def write_feed(self, base_url, dest_dir, archive_path: str, version) -> str:
        with open(f"{dest_dir}/{self.name}.xml", mode="w") as feed:
            feed.write(
                f"<entry><version>{version}</version><url>{base_url}/{archive_path}</url></entry>"
            )
        return self.feed_entry(f"{base_url}/{self.name}.xml")


def bundle_docset(dest_dir: str, docset: Docset):
    print(f"Creating archive for '{docset.path}'...")

    archive_basename = f"{dest_dir}/{docset.name}"
    archive = shutil.make_archive(archive_basename, "gztar", docset.path)

    print(f"Archive for '{docset.path}': '{archive}'")

    return archive


def make_site(dest_dir: str, template_path: str, docsets: list[Docset]):
    html = ""
    for docset in docsets:
        archive = bundle_docset(dest_dir, docset)
        html += docset.write_feed(
            base_url, dest_dir, os.path.basename(archive), "latest"
        )
    index_path = f"{dest_dir}/{os.path.basename(template_path)}"

    print(f"Writing HTML index '{index_path}' from template at '{template_path}'")
    with open(template_path, mode="r", encoding="utf-8") as template, open(
        index_path, mode="w", encoding="utf-8"
    ) as index:
        index.write(template.read().replace("<!-- @DOCSETS@ -->", html))


print(f"Copying static directory to output: '{static_dir}' → '{dest_dir}'")
dest = shutil.copytree(static_dir, dest_dir)
make_site(
    dest_dir=dest_dir,
    template_path=f"{static_dir}/index.html",
    docsets=[Docset(p) for p in args.docsets],
)

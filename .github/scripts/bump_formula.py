#!/usr/bin/env python3
"""Update Homebrew formula URLs and checksums for supported packages."""

from __future__ import annotations

import argparse
import dataclasses
import hashlib
import re
import sys
import urllib.request
from pathlib import Path


ROOT = Path(__file__).resolve().parents[2]
FORMULA_DIR = ROOT / "Formula"


@dataclasses.dataclass(frozen=True)
class Asset:
    target: str
    url: str
    sha256: str


BETAMAX_TARGETS = (
    "aarch64-apple-darwin",
    "x86_64-apple-darwin",
    "aarch64-unknown-linux-gnu",
    "x86_64-unknown-linux-gnu",
)


def download_sha256(url: str) -> str:
    digest = hashlib.sha256()
    with urllib.request.urlopen(url) as response:
        while chunk := response.read(1024 * 1024):
            digest.update(chunk)
    return digest.hexdigest()


def replace_once(text: str, pattern: str, replacement: str, description: str) -> str:
    text, count = re.subn(pattern, replacement, text, count=1)
    if count != 1:
        raise ValueError(f"expected exactly one {description}, found {count}")
    return text


def current_formula_version(text: str, package: str) -> str:
    if package == "betamax":
        match = re.search(r"/download/betamax-v(?P<version>\d+(?:\.\d+)+)/", text)
    else:
        match = re.search(r"/jk-(?P<version>\d+(?:\.\d+)+)\.crate", text)
    if not match:
        raise ValueError(f"could not determine current {package} formula version")
    return match.group("version")


def update_betamax(version: str, tag: str | None) -> bool:
    formula = FORMULA_DIR / "betamax.rb"
    text = formula.read_text()
    old_version = current_formula_version(text, "betamax")
    tag = tag or f"betamax-v{version}"

    assets = [
        Asset(
            target=target,
            url=(
                "https://github.com/joshka/betamax/releases/download/"
                f"{tag}/betamax-{version}-{target}.tgz"
            ),
            sha256=download_sha256(
                "https://github.com/joshka/betamax/releases/download/"
                f"{tag}/betamax-{version}-{target}.tgz"
            ),
        )
        for target in BETAMAX_TARGETS
    ]

    for asset in assets:
        old_url = (
            "https://github.com/joshka/betamax/releases/download/"
            f"betamax-v{old_version}/betamax-{old_version}-{asset.target}.tgz"
        )
        pattern = (
            rf'url "{re.escape(old_url)}"\n'
            r'(?P<indent>\s*)sha256 "[0-9a-f]{64}"'
        )
        replacement = f'url "{asset.url}"\n\\g<indent>sha256 "{asset.sha256}"'
        text = replace_once(text, pattern, replacement, f"Betamax {asset.target} asset")

    changed = text != formula.read_text()
    formula.write_text(text)
    return changed


def update_jk(version: str) -> bool:
    formula = FORMULA_DIR / "jk.rb"
    text = formula.read_text()
    old_version = current_formula_version(text, "jk")
    url = f"https://static.crates.io/crates/jk/jk-{version}.crate"
    sha256 = download_sha256(url)

    old_url = f"https://static.crates.io/crates/jk/jk-{old_version}.crate"
    text = replace_once(
        text,
        rf'url "{re.escape(old_url)}"',
        f'url "{url}"',
        "jk crate URL",
    )
    text = replace_once(
        text,
        r'sha256 "[0-9a-f]{64}"',
        f'sha256 "{sha256}"',
        "jk checksum",
    )

    changed = text != formula.read_text()
    formula.write_text(text)
    return changed


def parse_args(argv: list[str]) -> argparse.Namespace:
    parser = argparse.ArgumentParser()
    parser.add_argument("--package", choices=("betamax", "jk"), required=True)
    parser.add_argument("--version", required=True)
    parser.add_argument("--tag", help="Release tag for Betamax. Defaults to betamax-v<version>.")
    return parser.parse_args(argv)


def main(argv: list[str]) -> int:
    args = parse_args(argv)
    try:
        if args.package == "betamax":
            changed = update_betamax(args.version, args.tag)
        else:
            if args.tag:
                raise ValueError("--tag is only supported for betamax")
            changed = update_jk(args.version)
    except Exception as error:
        print(f"error: {error}", file=sys.stderr)
        return 1

    if changed:
        print(f"updated {args.package} formula to {args.version}")
    else:
        print(f"{args.package} formula is already at {args.version}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main(sys.argv[1:]))

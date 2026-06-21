import contextlib
import io
import importlib.util
import sys
import tempfile
import unittest
from pathlib import Path
from unittest import mock


SCRIPT = Path(__file__).resolve().parents[1] / ".github" / "scripts" / "bump_formula.py"


def load_module():
    spec = importlib.util.spec_from_file_location("bump_formula", SCRIPT)
    module = importlib.util.module_from_spec(spec)
    assert spec.loader is not None
    sys.modules[spec.name] = module
    spec.loader.exec_module(module)
    return module


class FakeResponse:
    def __init__(self, payload):
        self.payload = payload
        self.offset = 0

    def __enter__(self):
        return self

    def __exit__(self, *_args):
        return False

    def read(self, size=-1):
        if self.offset >= len(self.payload):
            return b""
        if size < 0:
            size = len(self.payload) - self.offset
        chunk = self.payload[self.offset : self.offset + size]
        self.offset += len(chunk)
        return chunk


class BumpFormulaTest(unittest.TestCase):
    def setUp(self):
        self.module = load_module()
        self.tempdir = tempfile.TemporaryDirectory()
        self.addCleanup(self.tempdir.cleanup)
        self.formula_dir = Path(self.tempdir.name) / "Formula"
        self.formula_dir.mkdir()
        self.module.FORMULA_DIR = self.formula_dir

    def test_updates_jk_crate_url_and_checksum(self):
        formula = self.formula_dir / "jk.rb"
        formula.write_text(
            '\n'.join(
                [
                    "class Jk < Formula",
                    '  url "https://static.crates.io/crates/jk/jk-0.2.2.crate"',
                    '  sha256 "4f6f73be6acb921cee52324f18d2b7b1e8325086fb4fca0f09e0ce5a1627580a"',
                    "end",
                    "",
                ]
            )
        )

        with mock.patch.object(
            self.module.urllib.request,
            "urlopen",
            return_value=FakeResponse(b"jk crate archive"),
        ):
            changed = self.module.update_jk("0.2.3")

        self.assertTrue(changed)
        text = formula.read_text()
        self.assertIn("jk-0.2.3.crate", text)
        self.assertIn(
            'sha256 "b16ff4f31558908f0405987d86f53ad9a395f59855d78fd6182a5df074038310"',
            text,
        )

    def test_updates_all_betamax_release_assets(self):
        formula = self.formula_dir / "betamax.rb"
        formula.write_text(
            "\n".join(
                [
                    "class Betamax < Formula",
                    '  url "https://github.com/joshka/betamax/releases/download/betamax-v0.1.12/betamax-0.1.12-aarch64-apple-darwin.tgz"',
                    '  sha256 "72b7912e6f949e347a702afb004ea9e688a445fc3ee157410484d8f872a174ed"',
                    '  url "https://github.com/joshka/betamax/releases/download/betamax-v0.1.12/betamax-0.1.12-x86_64-apple-darwin.tgz"',
                    '  sha256 "4760832176e9c8248d6c3ab4ec9ca78254645a71cb77a47e6017ecf1a5436055"',
                    '  url "https://github.com/joshka/betamax/releases/download/betamax-v0.1.12/betamax-0.1.12-aarch64-unknown-linux-gnu.tgz"',
                    '  sha256 "e7c055f77b9012b356f537543f98009ffc24a67c7a354e32903716b7c794d070"',
                    '  url "https://github.com/joshka/betamax/releases/download/betamax-v0.1.12/betamax-0.1.12-x86_64-unknown-linux-gnu.tgz"',
                    '  sha256 "ef7be1bbe38ac600571be6cdd757d6f582c78f137b447dd74cf7059a2fdd589d"',
                    "end",
                    "",
                ]
            )
        )

        def fake_urlopen(url):
            return FakeResponse(url.encode())

        with mock.patch.object(self.module.urllib.request, "urlopen", side_effect=fake_urlopen):
            changed = self.module.update_betamax("0.1.13", None)

        self.assertTrue(changed)
        text = formula.read_text()
        self.assertEqual(text.count("betamax-v0.1.13"), 4)
        self.assertEqual(text.count("betamax-0.1.13-"), 4)
        self.assertNotIn("betamax-v0.1.12", text)

    def test_rejects_tag_for_jk(self):
        with contextlib.redirect_stderr(io.StringIO()):
            self.assertEqual(
                self.module.main(["--package", "jk", "--version", "0.2.3", "--tag", "v0.2.3"]),
                1,
            )


if __name__ == "__main__":
    unittest.main()

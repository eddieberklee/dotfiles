#!/usr/bin/env python3
"""Tests for tmux-open-url-at-mouse."""

from __future__ import annotations

import os
import subprocess
import sys
import unittest
from pathlib import Path

SCRIPT = Path(__file__).with_name("tmux-open-url-at-mouse")


def resolve_url(hyperlink: str, line: str, x: int) -> str:
    result = subprocess.run(
        [sys.executable, str(SCRIPT), "--print", hyperlink, line, str(x)],
        check=True,
        text=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
    )
    return result.stdout.strip()


def resolve_url_from_env(hyperlink: str, line: str, x: int) -> str:
    env = os.environ.copy()
    env.update(
        {
            "TMUX_MOUSE_HYPERLINK": hyperlink,
            "TMUX_MOUSE_LINE": line,
            "TMUX_MOUSE_X": str(x),
        }
    )
    result = subprocess.run(
        [sys.executable, str(SCRIPT), "--print"],
        check=True,
        text=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        env=env,
    )
    return result.stdout.strip()


class TmuxOpenUrlAtMouseTests(unittest.TestCase):
    def test_osc8_hyperlink_wins_over_plain_text(self) -> None:
        self.assertEqual(
            resolve_url("https://target.example/path", "visible text", 3),
            "https://target.example/path",
        )

    def test_plain_url_under_mouse_is_returned(self) -> None:
        line = "open https://example.com/docs now"
        self.assertEqual(resolve_url("", line, line.index("example")), "https://example.com/docs")

    def test_trailing_sentence_punctuation_is_removed(self) -> None:
        line = "see https://example.com/docs)."
        self.assertEqual(resolve_url("", line, line.index("docs")), "https://example.com/docs")

    def test_clicking_elsewhere_on_line_returns_nothing(self) -> None:
        line = "left side https://example.com right side"
        self.assertEqual(resolve_url("", line, 1), "")

    def test_environment_arguments_preserve_empty_hyperlink(self) -> None:
        line = "open https://example.com/docs now"
        self.assertEqual(
            resolve_url_from_env("", line, line.index("example")),
            "https://example.com/docs",
        )

    def test_environment_arguments_allow_empty_line_without_usage_error(self) -> None:
        self.assertEqual(resolve_url_from_env("", "", 37), "")


if __name__ == "__main__":
    unittest.main()

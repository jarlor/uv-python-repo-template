from __future__ import annotations

import re
import sys
from pathlib import Path


_ALLOWED_TYPES = (
    "feat",
    "fix",
    "docs",
    "style",
    "refactor",
    "perf",
    "test",
    "build",
    "ci",
    "chore",
    "revert",
)

_CONVENTIONAL_RE = re.compile(
    r"^(?P<type>" + "|".join(_ALLOWED_TYPES) + r")"
    r"(?:\((?P<scope>[^)\r\n]+)\))?"
    r"(?P<breaking>!)?"
    r": (?P<subject>\S.*)$"
)


def _is_merge_commit(first_line: str) -> bool:
    return first_line.startswith("Merge ")


def _is_revert_commit(first_line: str) -> bool:
    return first_line.startswith("Revert ")


def main(argv: list[str]) -> int:
    if len(argv) != 2:
        print("Usage: check_commit_message.py <commit-msg-file>")
        return 2

    commit_msg_path = Path(argv[1])
    try:
        raw = commit_msg_path.read_text(encoding="utf-8")
    except FileNotFoundError:
        print(f"Commit message file not found: {commit_msg_path}")
        return 2

    first_line = raw.splitlines()[0].strip() if raw.strip() else ""

    if not first_line:
        print("Commit message is empty")
        return 1

    # Allow merge commits created by git.
    if _is_merge_commit(first_line) or _is_revert_commit(first_line):
        return 0

    match = _CONVENTIONAL_RE.match(first_line)
    if match:
        return 0

    allowed = ", ".join(_ALLOWED_TYPES)
    print("Invalid commit message (Conventional Commits required).")
    print("Expected: <type>(optional-scope)!?: <subject>")
    print(f"Allowed types: {allowed}")
    print(f"Got: {first_line}")
    return 1


if __name__ == "__main__":
    raise SystemExit(main(sys.argv))

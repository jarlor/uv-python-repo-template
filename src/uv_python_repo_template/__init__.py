from __future__ import annotations

from .example import Number, add_numbers


__all__ = ["Number", "add_numbers", "main"]


def main() -> None:
    """Entrypoint used by smoke tests and demo commands."""
    result = add_numbers(2, 3)
    print(f"Hello from uv_python_repo_template! 2 + 3 = {result}")

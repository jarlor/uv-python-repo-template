from __future__ import annotations

import pytest

from uv_python_repo_template import add_numbers, main


@pytest.mark.parametrize(
    "a, b, expected",
    [
        (1, 2, 3),
        (-5, 3, -2),
        (2.5, 3.5, 6.0),
        (0, 0, 0),
    ],
)
def test_add_numbers(a: float, b: float, expected: float) -> None:
    assert add_numbers(a, b) == expected


def test_add_numbers_type_error() -> None:
    with pytest.raises(TypeError):
        add_numbers("1", 2)  # type: ignore[arg-type]


def test_main_prints_demo_sum(capsys: pytest.CaptureFixture[str]) -> None:
    main()
    captured = capsys.readouterr()
    assert "2 + 3 = 5" in captured.out

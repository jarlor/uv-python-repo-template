from typing import Union

import pytest


def add_numbers(a: Union[int, float], b: Union[int, float]) -> Union[int, float]:
    if not isinstance(a, (int, float)) or not isinstance(b, (int, float)):
        raise TypeError("Inputs must be integers or floats")
    return a + b


@pytest.mark.parametrize(
    "a, b, expected",
    [
        (1, 2, 3),
        (-5, 3, -2),
        (2.5, 3.5, 6.0),
        (0, 0, 0),
    ],
)
def test_add_numbers(
    a: Union[int, float], b: Union[int, float], expected: Union[int, float]
) -> None:
    assert add_numbers(a, b) == expected


def test_add_numbers_type_error() -> None:
    with pytest.raises(TypeError):
        add_numbers("1", 2)  # type: ignore[arg-type]

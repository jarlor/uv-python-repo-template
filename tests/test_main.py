import pytest


def add_numbers(a, b):
    if not isinstance(a, (int, float)) or not isinstance(b, (int, float)):
        raise TypeError("Inputs must be integers or floats")
    return a + b


# 测试正常输入
@pytest.mark.parametrize(
    "a, b, expected",
    [
        (1, 2, 3),
        (-5, 3, -2),
        (2.5, 3.5, 6.0),
        (0, 0, 0),
    ],
)
def test_add_numbers(a, b, expected):
    assert add_numbers(a, b) == expected


def test_add_numbers_type_error():
    with pytest.raises(TypeError):
        add_numbers("1", 2)  #

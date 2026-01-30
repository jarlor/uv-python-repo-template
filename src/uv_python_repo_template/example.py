"""Example domain logic used by template tests."""

from __future__ import annotations


Number = int | float


def add_numbers(a: Number, b: Number) -> Number:
    """Add two numeric values with basic type validation."""
    if not isinstance(a, (int, float)) or not isinstance(b, (int, float)):
        raise TypeError("Inputs must be integers or floats")
    return a + b

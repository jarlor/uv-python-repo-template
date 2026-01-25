# AGENTS.md - Coding Agent Guidelines

> Guidelines for AI coding agents working in this UV Python repository template.

## Project Overview

This is a Python project template using **UV** as the package manager and **Poe the Poet** as the task runner. The project follows semantic versioning with conventional commits.

- **Python Version**: 3.10+ (see `.python-version`)
- **Package Manager**: UV (astral-sh/uv)
- **Task Runner**: Poe the Poet (poethepoet)
- **Linter**: Ruff
- **Type Checker**: mypy
- **Test Framework**: pytest
- **Formatter**: Ruff (line length: 100)

## Build/Lint/Test Commands

### Quick Reference

```bash
# Install dependencies
uv sync --all-extras

# Format code
uv run poe format

# Lint (ruff check + mypy)
uv run poe lint

# Run all tests
uv run poe test

# Lint + test (pre-push / CI)
uv run poe lint
uv run poe test

# Initialize project (install pre-commit hooks)
uv run poe init
```

### Running a Single Test

```bash
# Run a specific test file
uv run pytest tests/test_main.py -v

# Run a specific test function
uv run pytest tests/test_main.py::test_add_numbers -v

# Run tests matching a pattern
uv run pytest -k "test_add" -v

# Run with specific marker
uv run pytest -m "not slow" -v

# Run and stop on first failure
uv run pytest -x tests/
```

### Direct Tool Commands

```bash
# Ruff format (line length 100)
uv run ruff format --line-length 100

# Ruff check with auto-fix
uv run ruff check src/ --fix

# mypy type checking
uv run mypy --ignore-missing-imports --install-types --non-interactive --package src.uv_python_repo_template
```

## Code Style Guidelines

### Formatting

- **Line length**: 100 characters (enforced by ruff format)
- **Formatter**: Ruff (Black-compatible)
- **Indentation**: 4 spaces (Python standard)
- **Quotes**: Double quotes preferred (Ruff default)

### Linting Rules (Ruff)

Enabled rule sets:
- **E/W**: pycodestyle errors and warnings
- **F**: pyflakes
- **I**: isort (import sorting)
- **N**: pep8-naming
- **UP**: pyupgrade (modern Python syntax)
- **B**: flake8-bugbear (common bugs)
- **C4**: flake8-comprehensions
- **SIM**: flake8-simplify
- **RET**: flake8-return
- **ARG**: flake8-unused-arguments
- **PTH**: flake8-use-pathlib
- **ERA**: eradicate (commented-out code)
- **PL**: pylint
- **PERF**: perflint (performance)

Ignored rules:
- **E501**: line-too-long (handled by formatter)
- **PLR0913**: too-many-arguments
- **PLR2004**: magic-value-comparison

### Type Checking (mypy)

**Strict mode enabled** with comprehensive checks:
- All functions must have type annotations
- No untyped definitions allowed
- No implicit `Any` types
- Strict equality and concatenation checks
- Warns on unused configs, redundant casts, unreachable code

**Required**: Add type hints to all function signatures, including return types.

### Imports

Follow standard Python import ordering:
1. Standard library imports
2. Third-party imports
3. Local application imports

```python
import argparse
import logging
from pathlib import Path
from typing import Set, Optional

import yaml  # third-party

from my_module import helper  # local
```

### Type Annotations

- Use type hints for all function signatures (required by mypy strict mode)
- Use `Optional[T]` for nullable types
- Use `Union[T1, T2]` for multiple types
- Use `typing` module types: `Set`, `Optional`, `List`, `Dict`, `Union`
- All functions must have return type annotations (including `-> None`)

```python
from typing import Optional, Set, Union
from pathlib import Path

def get_git_remote_url() -> Optional[str]:
    """Get Git repository URL automatically"""
    ...

def parse_secrets_from_yaml(yaml_path: Path) -> Set[str]:
    """Parse used secrets from YAML file"""
    ...

def add_numbers(a: Union[int, float], b: Union[int, float]) -> Union[int, float]:
    return a + b

def main() -> None:
    print("Hello, World!")
    ...
```

### Naming Conventions

- **Functions/variables**: `snake_case`
- **Classes**: `PascalCase`
- **Constants**: `UPPER_SNAKE_CASE`
- **Private functions**: `_leading_underscore`
- **Module-level constants**: `UPPER_SNAKE_CASE`

```python
SUCCESS_LEVEL = 25
WORKFLOW_DIR = Path(".github/workflows")

class ColorFormatter(logging.Formatter):
    ...

def validate_workflow(name: str) -> bool:
    ...

def _init_install_hooks():  # private/internal
    ...
```

### Error Handling

- Use specific exception types
- Provide meaningful error messages
- Log errors appropriately

```python
try:
    with open(yaml_path, "r") as f:
        workflow_data = yaml.safe_load(f)
except yaml.YAMLError as e:
    logging.error(f"YAML parsing failed: {str(e)}")
    return set()
except Exception as e:
    logging.error(f"File read error: {str(e)}")
    return set()
```

### Docstrings

- Use triple double-quotes
- Brief one-line description for simple functions
- Multi-line for complex functions

```python
def get_git_remote_url() -> Optional[str]:
    """Get Git repository URL automatically"""
    ...
```

### Testing

- Test files in `tests/` directory
- Test file naming: `test_*.py`
- Test function naming: `test_*`
- Use `pytest.mark.parametrize` for multiple test cases
- Use `pytest.raises` for exception testing

```python
import pytest

@pytest.mark.parametrize(
    "a, b, expected",
    [
        (1, 2, 3),
        (-5, 3, -2),
        (2.5, 3.5, 6.0),
    ],
)
def test_add_numbers(a, b, expected):
    assert add_numbers(a, b) == expected

def test_add_numbers_type_error():
    with pytest.raises(TypeError):
        add_numbers("1", 2)
```

## Project Structure

```
.
├── src/
│   └── uv_python_repo_template/
│       └── __init__.py          # Main package
├── tests/
│   └── test_main.py             # Test files
├── scripts/
│   ├── init.sh                  # Project initialization
│   └── extract_release_notes.sh # Release automation
├── .github/workflows/           # CI/CD workflows
├── pyproject.toml               # Project config & poe tasks
├── .pre-commit-config.yaml      # Pre-commit hooks
└── .python-version              # Python version (3.10)
```

## Pre-commit Hooks

Pre-commit runs `uv run poe lint` on Python files before each commit. This includes:
- Ruff check with auto-fix
- mypy type checking

## Commit Convention

Follow [Conventional Commits](https://www.conventionalcommits.org):

```
<type>([scope]): <subject>
```

| Type | Version Impact | Example |
|------|----------------|---------|
| `feat` | Minor ↑ | `feat: Add user registration API` |
| `fix` | Patch ↑ | `fix: Resolve password validation` |
| `feat!` / `BREAKING CHANGE` | Major ↑ | `feat!: Remove deprecated API` |
| `docs`, `style`, `test` | None | `docs: Update API documentation` |

## Workflow Management

Workflows live in `.github/workflows` and are enabled by default.

## Release Process

**Fully Automated via GitHub Actions:**

```bash
# 1. Develop on dev branch
git checkout dev
git commit -m "feat: add new feature"
git push origin dev

# 2. Create PR to master
gh pr create --title "feat: add new feature" --base master

# 3. Merge PR
# → GitHub Actions automatically:
#    - Runs semantic-release to calculate version
#    - Updates pyproject.toml and CHANGELOG.md
#    - Creates commit on master
#    - Creates and pushes tag
#    - Triggers production deployment
```

**Key Points:**
- Completely automated - no manual version management
- Version calculated from conventional commits
- Tags created on master automatically (via `auto-release.yaml`)
- All changes go through PR review
- semantic-release runs in CI, not locally

## Key Files to Know

- `pyproject.toml` - All project config, dependencies, and poe tasks
- `.pre-commit-config.yaml` - Pre-commit hook configuration
- `.python-version` - Python version specification
- `src/uv_python_repo_template/__init__.py` - Main package entry point

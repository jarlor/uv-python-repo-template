# Features

This document provides an in-depth explanation of all features included in this template.

## Table of Contents

- [UV Package Manager](#uv-package-manager)
- [Automated Versioning](#automated-versioning)
- [Pre-commit Hooks](#pre-commit-hooks)
- [GitHub Actions Workflows](#github-actions-workflows)
- [Branch Auto-sync](#branch-auto-sync)
- [PR Templates](#pr-templates)
- [Poe Task Runner](#poe-task-runner)
- [Code Quality Tools](#code-quality-tools)

---

## UV Package Manager

[UV](https://github.com/astral-sh/uv) is a blazing-fast Python package manager written in Rust.

### Why UV?

- **10-100x faster** than pip
- **Unified tool** - replaces pip, pip-tools, pipx, poetry, pyenv, virtualenv
- **Reproducible** - lock files ensure consistent installs
- **Compatible** - works with existing pip/requirements.txt projects

### Key Commands

```bash
# Install dependencies
uv sync --all-extras

# Add a package
uv add requests

# Add a dev dependency
uv add --dev pytest

# Run a command in the virtual environment
uv run python script.py

# Run a poe task
uv run poe test
```

### Configuration

UV is configured in `pyproject.toml`:

```toml
[project]
name = "my-project"
version = "1.0.0"
requires-python = ">=3.10"

[dependency-groups]
dev = [
    "mypy>=1.15.0",
    "pytest>=8.3.4",
    "ruff>=0.9.5",
]
```

---

## Automated Versioning

Semantic versioning based on [Conventional Commits](https://www.conventionalcommits.org).

### How It Works

1. **Commit with conventional format:**
   ```bash
   git commit -m "feat: add user authentication"
   ```

2. **Run tag command:**
   ```bash
   uv run poe tag
   ```

3. **Automatic version calculation:**
   - `feat:` → Minor bump (1.2.3 → 1.3.0)
   - `fix:` → Patch bump (1.2.3 → 1.2.4)
   - `feat!:` or `BREAKING CHANGE:` → Major bump (1.2.3 → 2.0.0)

4. **Automatic updates:**
   - `CHANGELOG.md` - Generated from commit messages
   - `pyproject.toml` - Version number updated
   - Git tag created (e.g., `v1.3.0`)

### Configuration

Configured in `pyproject.toml`:

```toml
[tool.poe.tasks]
_tag_changelog = "semantic-release changelog"
_tag_version = "semantic-release version --no-push"
_tag_update_toml_version = { shell = "update-toml update --path project.version --value $(semantic-release version --print)" }
tag = { sequence = ["lint", "test", "smoke", "_tag_changelog", "_tag_update_toml_version", "_tag_version"] }

[semantic_release]
assets = ["pyproject.toml", "uv.lock"]

[semantic_release.remote]
ignore_token_for_push = true
```

### CHANGELOG Format

Generated CHANGELOG follows [Keep a Changelog](https://keepachangelog.com) format:

```markdown
## v1.3.0 (2024-01-25)

### Features

- Add user authentication ([`abc123`](link))
- Add email notifications ([`def456`](link))

### Bug Fixes

- Fix login timeout issue ([`ghi789`](link))

### Breaking Changes

- Remove deprecated API endpoints ([`jkl012`](link))
```

---

## Pre-commit Hooks

Automated checks that run before each commit.

### Installed Hooks

1. **Format (Ruff)** - Auto-formats Python code
2. **Lint (Ruff)** - Checks code quality
3. **Lint (mypy)** - Type checking
4. **Commit Message** - Validates Conventional Commits format

### Configuration

Defined in `.pre-commit-config.yaml`:

```yaml
repos:
  - repo: local
    hooks:
      - id: format
        name: Format (ruff)
        entry: uv run poe format
        language: system
        types: [python]
        stages: [pre-commit]

      - id: lint-ruff
        name: Lint (ruff)
        entry: uv run poe lint_ruff
        language: system
        types: [python]
        stages: [pre-commit]

      - id: lint-mypy
        name: Lint (mypy)
        entry: uv run poe lint_mypy
        language: system
        types: [python]
        stages: [pre-commit]

      - id: commit-msg
        name: Conventional Commit Message
        entry: uv run python scripts/check_commit_message.py
        language: system
        stages: [commit-msg]
```

### Bypassing Hooks

**Not recommended**, but if needed:

```bash
# Skip pre-commit hooks
git commit --no-verify -m "feat: emergency fix"

# Skip specific hook
SKIP=lint-mypy git commit -m "feat: add feature"
```

---

## GitHub Actions Workflows

Automated CI/CD pipelines.

### PR Gate Workflow

**File:** `.github/workflows/pr_gate.yaml`

**Triggers:** Pull requests to `dev` or `master`

**Steps:**
1. Checkout code
2. Install UV and Python
3. Install dependencies
4. Run lint checks
5. Run tests
6. Run smoke tests

**Purpose:** Ensure code quality before merging.

### Dev Deploy Workflow

**File:** `.github/workflows/dev_deploy.yaml`

**Triggers:** Push to `dev` branch

**Steps:**
1. Checkout code
2. Deploy to dev environment (TODO: implement)
3. Run health checks (TODO: implement)
4. Record deployment snapshot (TODO: implement)

**Purpose:** Auto-deploy to dev environment for testing.

### Prod Deploy Workflow

**File:** `.github/workflows/prod_deploy.yaml`

**Triggers:** Push tags matching `v*.*.*`

**Steps:**
1. Checkout code
2. Build production artifacts (TODO: implement)
3. Deploy to production (TODO: implement)
4. Monitor and rollback if needed (TODO: implement)

**Purpose:** Deploy to production on release.

### Release Workflow

**File:** `.github/workflows/release.yaml`

**Triggers:** Push tags matching `v*.*.*`

**Steps:**
1. Checkout code
2. Extract release notes from CHANGELOG
3. Create GitHub Release
4. Sync master changes to dev

**Purpose:** Create GitHub Release and sync branches.

### Sync Dev Workflow

**File:** `.github/workflows/sync_dev.yaml`

**Triggers:** Push to `master` branch

**Steps:**
1. Checkout code with full history
2. Fetch dev branch
3. Merge master into dev
4. Push updated dev branch

**Purpose:** Keep dev branch in sync with master.

---

## Branch Auto-sync

Automatically syncs master changes back to dev.

### Why Auto-sync?

**Problem:** After merging to master, dev branch is behind:

```
master: A → B → C → D (merge commit)
dev:    A → B → C
```

**Solution:** Auto-sync workflow merges master back to dev:

```
master: A → B → C → D
dev:    A → B → C → D (auto-synced)
```

### How It Works

1. **Any push to master** triggers `sync_dev.yaml`
2. Workflow fetches both branches
3. Merges master into dev with `--no-edit`
4. Pushes updated dev branch

### Configuration

```yaml
# .github/workflows/sync_dev.yaml
on:
  push:
    branches:
      - master

jobs:
  sync:
    runs-on: ubuntu-latest
    permissions:
      contents: write
    steps:
      - name: Sync master to dev
        run: |
          git fetch origin dev
          git checkout dev
          git merge origin/master --no-edit
          git push origin dev
```

### Handling Conflicts

If merge conflicts occur:
1. Workflow will fail
2. Manual resolution required:
   ```bash
   git checkout dev
   git merge master
   # Resolve conflicts
   git push origin dev
   ```

---

## PR Templates

Structured PR descriptions with checklists.

### Template Location

`.github/pull_request_template.md`

### Template Sections

1. **变更目的** - Purpose of changes
2. **影响范围** - Scope of impact
3. **测试证据** - Test evidence
4. **风险点** - Risk points
5. **回滚方案** - Rollback plan
6. **跨仓库依赖** - Cross-repo dependencies
7. **提交前自检** - Pre-submission checklist

### Example

```markdown
# 变更目的
- Add user authentication system

# 影响范围
- 后端接口（路径/方法）：POST /api/auth/login

# 测试证据（必须可复现）
- 测试命令/步骤：uv run poe test
- 结果/截图/日志链接：All tests pass

# 风险点
- Database migration required

# 回滚方案（必填）
- 回滚目标 commit/image tag：abc123
- 回滚入口/脚本：git revert abc123

# 提交前自检
- [x] PR 标题符合 Conventional Commits
- [x] 已说明风险与回滚
```

---

## Poe Task Runner

[Poe the Poet](https://poethepoet.natn.io/) - A task runner for Python projects.

### Available Tasks

```bash
# Code quality
uv run poe format          # Format code with Ruff
uv run poe lint_ruff       # Lint with Ruff
uv run poe lint_mypy       # Type check with mypy
uv run poe lint            # Run all linters

# Testing
uv run poe test            # Run pytest
uv run poe smoke           # Run smoke tests

# Release
uv run poe tag             # Create version tag

# Setup
uv run poe init -y         # Initialize project
```

### Configuration

Defined in `pyproject.toml`:

```toml
[tool.poe.tasks]
format = "ruff format"
lint_ruff = "ruff check src/"
lint_mypy = "mypy --install-types --non-interactive"
lint = { sequence = ["lint_ruff", "lint_mypy"] }
test = "pytest"
smoke = { shell = "python -c 'import uv_python_repo_template as p; p.main()'" }
tag = { sequence = ["lint", "test", "smoke", "_tag_changelog", "_tag_update_toml_version", "_tag_version"] }

[tool.poe.tasks.init]
shell = "bash scripts/init.sh ${yes:+ -y}"
args = [{ name = "yes", options = ["-y", "--yes"], type = "boolean" }]
```

### Creating Custom Tasks

Add to `pyproject.toml`:

```toml
[tool.poe.tasks]
# Simple command
hello = "echo 'Hello, World!'"

# Shell command
deploy = { shell = "docker build . && docker push myimage" }

# Sequence of tasks
ci = { sequence = ["format", "lint", "test"] }

# Task with arguments
greet = { shell = "echo 'Hello, ${name}!'" }
```

---

## Code Quality Tools

### Ruff

Fast Python linter and formatter (written in Rust).

**Configuration:** `pyproject.toml`

```toml
[tool.ruff]
line-length = 100
target-version = "py310"
src = ["src"]
```

**Commands:**
```bash
# Format code
uv run ruff format

# Check code
uv run ruff check src/

# Auto-fix issues
uv run ruff check src/ --fix
```

### mypy

Static type checker for Python.

**Configuration:** `pyproject.toml`

```toml
[tool.mypy]
python_version = "3.10"
mypy_path = ["src"]
files = ["src"]
ignore_missing_imports = true
warn_unused_configs = true
```

**Commands:**
```bash
# Type check
uv run mypy --install-types --non-interactive
```

### pytest

Testing framework.

**Configuration:** `pyproject.toml`

```toml
[tool.pytest.ini_options]
minversion = "8.0"
testpaths = ["tests"]
pythonpath = ["src"]
addopts = "--verbose --color=yes"
```

**Commands:**
```bash
# Run all tests
uv run pytest

# Run specific test file
uv run pytest tests/test_main.py

# Run with coverage
uv run pytest --cov=src
```

---

## Summary

This template provides:

- ⚡ **Fast setup** with UV
- 🤖 **Automated versioning** with semantic-release
- 🔒 **Quality gates** with pre-commit hooks
- 🚀 **CI/CD** with GitHub Actions
- 📦 **Auto-sync** between branches
- 📝 **Structured PRs** with templates
- 🛠️ **Task automation** with Poe
- ✨ **Code quality** with Ruff + mypy + pytest

All features work together to provide a production-ready development workflow.

## Next Steps

- [Getting Started](getting-started.md)
- [GitHub Setup](github-setup.md)
- [Development Workflow](development-workflow.md)

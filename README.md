# UV Python Repository Template

[![Built with UV](https://img.shields.io/badge/built%20with-uv-7966C7)](https://github.com/astral-sh/uv)
[![Conventional Commits](https://img.shields.io/badge/Conventional%20Commits-1.0.0-%23FE5196)](https://www.conventionalcommits.org)
[![Python 3.10+](https://img.shields.io/badge/python-3.10+-blue.svg)](https://www.python.org/downloads/)

[中文文档](README_zh.md) | [Documentation](docs/)

> A production-ready Python project template with automated CI/CD workflows, semantic versioning, and comprehensive quality gates.

## ✨ What You Get

- **⚡ Lightning-fast Setup** - Get started in under 2 minutes with UV
- **🤖 Automated Versioning** - Semantic versioning based on Conventional Commits
- **🔒 Quality Gates** - Pre-commit hooks + PR gates (lint, test, type check)
- **🚀 CI/CD Ready** - GitHub Actions workflows for dev/prod deployment
- **📦 Auto-sync Branches** - Master changes automatically sync to dev
- **📝 PR Templates** - Structured PR descriptions with checklists
- **🏷️ Release Automation** - Auto-generate changelogs and GitHub releases

## 🚀 Quick Start

### 1. Use This Template

Click "Use this template" on GitHub or:

```bash
git clone https://github.com/jarlor/uv-python-repo-template.git my-project
cd my-project
```

### 2. Install UV

**macOS/Linux:**
```bash
curl -LsSf https://astral.sh/uv/install.sh | sh
```

**macOS (Homebrew):**
```bash
brew install uv
```

**Windows:** See [UV installation guide](https://docs.astral.sh/uv/installation)

### 3. Initialize Project

```bash
uv run poe init -y
```

This will:
- Rename the project to match your directory name
- Set up `dev` and `master` branches
- Install pre-commit hooks
- Display post-init checklist

### 4. Start Developing

```bash
# Create a feature branch
git checkout -b feature/my-feature

# Make changes and commit
git add .
git commit -m "feat: add new feature"

# Push and create PR
git push origin feature/my-feature
```

## 📚 Documentation

| Document | Description |
|----------|-------------|
| [Getting Started](docs/getting-started.md) | Detailed setup and initialization guide |
| [GitHub Setup](docs/github-setup.md) | Configure branch protection, secrets, and Actions |
| [Development Workflow](docs/development-workflow.md) | Standard development process and best practices |
| [Features](docs/features.md) | In-depth feature explanations |

## 🎯 Key Features

### Automated Workflows

- **PR Gate** - Runs on every PR to `dev`/`master`
  - Code formatting (Ruff)
  - Linting (Ruff + mypy)
  - Unit tests (pytest)
  - Smoke tests

- **Dev Deploy** - Triggers on merge to `dev`
  - Auto-deploy to dev environment
  - Health checks
  - Rollback support

- **Prod Deploy** - Triggers on tag push
  - Build immutable artifacts
  - Deploy to production
  - Create GitHub Release
  - Auto-sync to dev branch

### Branch Strategy

```
feature/* → dev → master
              ↓      ↓
           dev env  prod env
```

**Branch Protection:**
- `master` - **Hard protection** (GitHub): Requires PR + status checks
- `dev` - **Soft protection** (local pre-push hook): Blocks direct push, allows auto-sync from master
- Direct pushes blocked, PR workflow enforced

**Why this approach?**
- Master protection is critical for production code quality
- Dev protection is flexible to allow automated master → dev sync
- No complex GitHub App setup needed for branch synchronization

### Commit Convention

Follow [Conventional Commits](https://www.conventionalcommits.org):

```
<type>(<scope>): <subject>
```

**Version Impact:**
- `feat:` → Minor version bump (v1.2.3 → v1.3.0)
- `fix:` → Patch version bump (v1.2.3 → v1.2.4)
- `feat!:` or `BREAKING CHANGE:` → Major version bump (v1.2.3 → v2.0.0)

### Release Process

```bash
# On master branch
uv run poe tag

# Push tags
git push origin master --tags
```

This automatically:
1. Calculates next version based on commits
2. Updates `CHANGELOG.md`
3. Creates git tag
4. Triggers production deployment
5. Creates GitHub Release
6. Syncs changes back to dev

## 🛠️ Available Commands

```bash
# Development
uv run poe format          # Format code with Ruff
uv run poe lint            # Run linters (Ruff + mypy)
uv run poe test            # Run tests with pytest
uv run poe smoke           # Run smoke tests

# Release
uv run poe tag             # Create version tag and update changelog

# Setup
uv run poe init -y         # Initialize project (first-time setup)
```

## 📋 Requirements

- Python 3.10+
- UV 0.5.0+
- Git

## 🤝 Contributing

This is a template repository. Feel free to fork and customize for your needs.

## 📄 License

MIT License - see [LICENSE](LICENSE) for details.

## 🙏 Acknowledgments

Original inspiration from [python-repo-template](https://github.com/GiovanniGiacometti/python-repo-template).

## 📞 Support

- [Documentation](docs/)
- [Issues](https://github.com/jarlor/uv-python-repo-template/issues)
- [Discussions](https://github.com/jarlor/uv-python-repo-template/discussions)

---

**Made with ❤️ using [UV](https://github.com/astral-sh/uv)**

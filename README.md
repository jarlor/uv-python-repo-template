# UV Python Repository Template

[![Built with UV](https://img.shields.io/badge/built%20with-uv-7966C7)](https://github.com/astral-sh/uv)
[![Conventional Commits](https://img.shields.io/badge/Conventional%20Commits-1.0.0-%23FE5196)](https://www.conventionalcommits.org)
[![Base Template](https://img.shields.io/badge/-base_template-blue?logo=github)](https://github.com/GiovanniGiacometti/python-repo-template)

[中文文档](README_zh.md)

> Python project template powered by UV with fully automated CI/CD workflows, enabling developers to focus on code

## 🚀 Core Features

- ⚡ **Blazing-fast Dependency Management** - Next-gen toolchain powered by UV
- 🤖 **Automatic Version Control** - Semantic versioning based on Conventional Commits
- 🔒 **Quality Gates** - Automated checks on every commit:
  - ✅ Code Formatting (Black)
  - ✅ Linting (Flake8)
  - ✅ Unit Testing (Pytest)
- 🛠️ **Smart Workflow Management** - Visual GitHub Actions control

## 🛠️ Environment Setup

### Prerequisites

1. Install UV:

- MacOS:
  ```bash
  brew install uv
  ```
- Linux (Debian/Ubuntu/WSL):
  ```bash
  curl -LsSf https://astral.sh/uv/install.sh | sh
  ```

> 💡 Verify installation with `uv --version` (should return 0.5.x or higher). Full installation guide
> at [UV documentation](https://docs.astral.sh/uv/installation).

2. System Support:

- ✅ Linux
- ✅ macOS
- ⚠️ Windows ([WSL supported](https://docs.astral.sh/uv/faq/#does-uv-work-on-windows))

## 🏁 Quick Start

### Initial Setup (First-time Use)

```bash
bash ./scripts/init.sh
```

The initialization script will:

1. Configure project metadata
2. Create Python virtual environment (in `.venv`)
3. Install Git Hooks (pre-commit & commit-msg)

## ✍️ Commit Convention

### Message Format

```bash
<type>([scope]): <subject>
```

#### Type Reference

| Type                  | Version Impact | Example Scenarios                                  |
|-----------------------|----------------|----------------------------------------------------|
| `feat`                | **Minor** ↑    | Add user authentication                            |
| `fix`                 | **Patch** ↑    | Fix payment timeout                                |
| `BREAKING CHANGE`     | **Major** ↑    | Remove legacy API (use `!` or body)                |
| `docs`/`style`/`test` | No impact      | Documentation updates, code formatting, test cases |

### Examples

- `feat: Add user registration API` ➔ **Minor** version bump (`v1.2.3` → `v1.3.0`)
- `fix: Resolve password validation` ➔ **Patch** version bump (`v1.2.3` → `v1.2.4`)
- `feat!: Remove deprecated API` ➔ **Major** version bump (`v1.2.3` → `v2.0.0`)
- `docs: Update API documentation` ➔ No version change
- `style: Code formatting` ➔ No version change
- `test: Add unit tests` ➔ No version change

> 💡 Use `!` in commit message or include `BREAKING CHANGE:` in body for breaking changes

## 🏷️ Version Tagging

Generate semantic version tags:

```bash
uv run poe tag
```

This command automatically:

1. Calculates version number (based on commit history)
2. Generates CHANGELOG
3. Commits tag

## 🔄 Code Push

Standard push commands:

```bash
git push origin main # Push main branch
git push --tags # Push tags
```

> 💡 Ensure tags are pushed to remote to trigger GitHub Actions workflows

## 🤖 GitHub Actions Management

### Workflow List

View available workflows:

```bash
uv run poe action list
```

Default workflows: `release`, `publish`, `lint-test`

### Workflow Control

Enable/disable workflows:

```bash
uv run poe action toggle --enable release --commit # Enable release workflow and commit
uv run poe action toggle --disable release --commit # Disable release workflow and commit
uv run poe action toggle --enable publish # Enable publish workflow
uv run poe action toggle --disable publish # Disable publish workflow
```

> ⚠️ System will prompt for required environment variables when enabling workflows

## Acknowledgments

Original inspiration and base template
from [python-repo-template](https://github.com/GiovanniGiacometti/python-repo-template).

## Collaborators

<!-- readme: collaborators,contributors -start -->
<table>
	<tbody>
		<tr>
            <td align="center">
                <a href="https://github.com/jarlor">
                    <img src="https://avatars.githubusercontent.com/u/53697817?v=4" width="100;" alt="jarlor"/>
                    <br />
                    <sub><b>Jarlor Zhang</b></sub>
                </a>
            </td>
		</tr>
	<tbody>
</table>
<!-- readme: collaborators,contributors -end -->
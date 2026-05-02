# Vibecoding Python Starter

[![Built with UV](https://img.shields.io/badge/built%20with-uv-7966C7)](https://github.com/astral-sh/uv)
[![Conventional Commits](https://img.shields.io/badge/Conventional%20Commits-1.0.0-%23FE5196)](https://www.conventionalcommits.org)
[![Python 3.10+](https://img.shields.io/badge/python-3.10+-blue.svg)](https://www.python.org/downloads/)

[Documentation](docs/)

> A minimal Python starter for vibecoding: clean uv defaults, agent-facing instructions, strict Git workflow, CI governance, and opt-in deployment.

## What You Get

- Fast setup with uv and a project rename initializer
- `AGENTS.md` so AI coding agents know the repository rules immediately
- `dev`/`main` Git model with PR and commit governance
- CI for Python quality and optional frontend builds
- Semantic-release changelog, tags, and GitHub Releases
- Optional test and production deployment workflows
- Backmerge from `main` to `dev` after semantic-release, gated by production deploy success when deployment is enabled

## Quick Start

```bash
git clone https://github.com/jarlor/uv-python-repo-template.git my-project
cd my-project
uv run poe init -y
```

The initializer renames the package to match your directory, keeps or creates `main`, creates `dev`, installs hooks, and prints the GitHub setup checklist.

Start work from `dev`:

```bash
git switch dev
git pull --ff-only origin dev
git switch -c feature/my-feature
git commit -m "feat: add new feature"
git push origin feature/my-feature
```

## Git Model

`dev` is the integration branch. `main` is the production truth branch. `test` and `staging` are environments, not branches.

```text
feature/*, fix/*, docs/*, chore/*
  -> PR to dev
  -> Squash merge
  -> CI + optional test deploy

dev
  -> PR to main
  -> Create merge commit
  -> semantic-release
  -> optional prod deploy
  -> backmerge main to dev after release, or after prod deploy success when enabled

hotfix/*
  -> branch from main
  -> PR to main
  -> Squash merge
  -> semantic-release + optional prod deploy
  -> backmerge main to dev
```

All PR titles must follow Conventional Commit format. PRs into `main` must use a release-triggering type: `feat:`, `fix:`, or `perf:`.

## Workflow Profiles

CI and governance are always on. Deployments and release automation are opt-in through GitHub Variables.

| Profile | Variables | Behavior |
| --- | --- | --- |
| `ci-only` | none | CI, PR governance, and commit governance |
| `prod-only` | `PROD_DEPLOY_ENABLED=true` | Deploy production after a released `main` build |
| `test-and-prod` | `TEST_DEPLOY_ENABLED=true`, `PROD_DEPLOY_ENABLED=true` | Deploy test from `dev`, production from released `main` |

See [CI/CD configuration](docs/en/ci-cd.md) for the exact secrets and variables.

## Workflows

- `ci.yml`: Python checks, optional frontend build, shell syntax checks
- `pr-governance.yml`: PR title rules
- `commit-governance.yml`: landed commit message rules on `dev` and `main`
- `deploy-test.yml`: optional test/staging deploy from `dev`
- `release.yml`: semantic-release and optional production deploy from `main`
- `backmerge-main-to-dev.yml`: manual recovery backmerge

## Commands

```bash
uv run poe format          # Format code with Ruff
uv run poe format-check    # Check formatting
uv run poe lint            # Ruff + mypy
uv run poe test            # pytest
uv run poe check           # format check + lint + test
uv run poe smoke           # import smoke test
uv run poe tag             # Preview the next semantic-release version
uv run poe init -y         # Initialize a new project from the template
```

## What To Keep

| Document | Description |
| --- | --- |
| [Agent guide](AGENTS.md) | First-read instructions for AI coding agents |
| [Quickstart](docs/en/quickstart.md) | Initialize a new project and configure GitHub |
| [Git workflow](docs/en/git-workflow.md) | Branch, PR, release, and backmerge rules |
| [CI/CD configuration](docs/en/ci-cd.md) | Workflow behavior, secrets, and variables |

## Requirements

- Python 3.10+
- uv 0.5.0+
- Git

## License

MIT License - see [LICENSE](LICENSE) for details.

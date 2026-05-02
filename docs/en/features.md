# Features

## Python Project Baseline

- uv-based dependency management
- Ruff formatting and linting
- mypy type checking
- pytest test runner
- poe task runner
- pre-commit and commit-msg hooks

## CI and Governance

- `ci.yml` runs Python quality checks and optional frontend builds.
- `pr-governance.yml` enforces Conventional Commit PR titles.
- `commit-governance.yml` validates landed commit subjects on `dev` and `main`.
- Shell deployment scripts are syntax-checked when present.

## Release Automation

- semantic-release calculates versions from Conventional Commit history.
- Releases run from `main`.
- No-release changes stop before deployment.
- GitHub tags and releases are created by the release workflow.

## Optional Deployments

Deployments are disabled by default:

- `deploy-test.yml` runs only when `TEST_DEPLOY_ENABLED=true`.
- `release.yml` deploys production only when `PROD_DEPLOY_ENABLED=true`.
- Projects with only a production environment can use `prod-only`.
- Projects with no servers can stay `ci-only`.

## Backmerge

After a released production deploy succeeds, `main` is merged back into `dev` with:

```text
chore(backmerge): merge main into dev
```

Manual backmerge is available for recovery through `backmerge-main-to-dev.yml`.

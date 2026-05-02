# CI/CD Configuration

## Workflows

| Workflow | Trigger | Default behavior |
| --- | --- | --- |
| `ci.yml` | PR and push to `dev`/`main` | Python checks, optional frontend build, shell syntax checks |
| `pr-governance.yml` | PR to `dev`/`main` | Validates Conventional Commit PR titles |
| `commit-governance.yml` | Push to `dev`/`main` | Validates landed first-parent commit subjects |
| `deploy-test.yml` | Push to `dev`, manual | Skipped unless `TEST_DEPLOY_ENABLED=true` |
| `release.yml` | Push to `main`, manual | Skipped unless `RELEASE_ENABLED=true`; production deploy is also opt-in |
| `backmerge-main-to-dev.yml` | Manual | Recovery workflow for `main -> dev` backmerge |

## Always-On Checks

The template assumes these checks are safe for every project:

- Python quality: `uv sync --frozen --group dev` and `uv run poe check`
- Optional frontend quality when `src/frontend/package-lock.json` exists
- Shell syntax for `scripts/cicd/*.sh` and `scripts/deploy/*.sh`
- PR and commit governance

## Optional Test Deploy

Set `TEST_DEPLOY_ENABLED=true` only when the project has a separate test or staging host.

Secrets:

- `TEST_SSH_HOST`
- `TEST_SSH_USER`
- `TEST_SSH_KEY`

Variables:

- `TEST_DEPLOY_PATH`
- `TEST_SYSTEMD_SERVICE`
- `TEST_HEALTH_URL`
- `TEST_REPOSITORY_URL`

## Optional Production Deploy

Set `PROD_DEPLOY_ENABLED=true` only when production SSH deployment is configured.

Secrets:

- `PROD_SSH_HOST`
- `PROD_SSH_USER`
- `PROD_SSH_KEY`

Variables:

- `PROD_DEPLOY_PATH`
- `PROD_SYSTEMD_SERVICE`
- `PROD_HEALTH_URL`
- `PROD_REPOSITORY_URL`

## Optional Release Automation

Set `RELEASE_ENABLED=true` only after `RELEASE_TOKEN` can push release commits and tags to `main` under the repository ruleset.

Required secret:

- `RELEASE_TOKEN`

Required variable:

- `RELEASE_ENABLED`

If release automation is disabled, `release.yml` is skipped and `main` still receives CI and commit governance.

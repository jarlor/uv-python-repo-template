# Quickstart

## Create a Project

```bash
git clone https://github.com/jarlor/uv-python-repo-template.git my-project
cd my-project
uv run poe init -y
```

The initializer renames the package, keeps or creates `main`, creates `dev`, resets version metadata, and installs local hooks.

## Configure GitHub

Set the repository default branch to `main`.

Recommended repository settings:

- protect `main` with PR-only merges
- use Squash merge for short-lived branches
- use PR title as the squash commit title
- use PR title as the create-merge-commit title
- automatically delete merged head branches

`dev` can be protected too, but it must still allow the project owner or automation to backmerge from `main` when needed.

## Start Work

```bash
git switch dev
git pull --ff-only origin dev
git switch -c feature/my-feature
git commit -m "feat: add health endpoint"
git push origin feature/my-feature
```

Open the PR to `dev`. When `dev` is verified, open a release PR from `dev` to `main`.

## Local Checks

```bash
uv run poe format-check
uv run poe lint
uv run poe test
uv run poe check
uv run poe smoke
```

## Deployment Profiles

No deployment is enabled by default.

| Profile | Required settings |
| --- | --- |
| CI only | none |
| Production only | `PROD_DEPLOY_ENABLED=true` plus `PROD_*` secrets/vars |
| Test and production | `TEST_DEPLOY_ENABLED=true` and `PROD_DEPLOY_ENABLED=true` |

Release automation is also opt-in. Configure `RELEASE_ENABLED=true` and `RELEASE_TOKEN` only after repository rules allow that token to push release commits and tags to `main`.

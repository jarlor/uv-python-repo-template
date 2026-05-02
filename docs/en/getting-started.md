# Getting Started

## 1. Create a Project

```bash
git clone https://github.com/jarlor/uv-python-repo-template.git my-project
cd my-project
uv run poe init -y
```

The initializer:

- renames the package to match the directory
- keeps or creates `main`
- creates `dev` when missing
- installs pre-commit, commit-msg, and pre-push hooks
- resets version metadata for a new project

## 2. Configure GitHub

Set the repository default branch to `main`. Protect both `dev` and `main`, and require:

- CI
- PR Governance
- Commit Governance

See [GitHub Setup](github-setup.md) for merge settings, secrets, and variables.

## 3. Start Development

```bash
git switch dev
git pull --ff-only origin dev
git switch -c feature/my-feature
```

Commit with Conventional Commit messages:

```bash
git commit -m "feat: add health endpoint"
git push origin feature/my-feature
```

Open a PR to `dev`. After `dev` is verified, open a release PR from `dev` to `main`.

## 4. Choose a Deployment Profile

No deployment is enabled by default.

| Profile | Required setting |
| --- | --- |
| CI only | none |
| Production only | `PROD_DEPLOY_ENABLED=true` plus `PROD_*` secrets/vars |
| Test and production | `TEST_DEPLOY_ENABLED=true` and `PROD_DEPLOY_ENABLED=true` |

`dev` can exist without a test server. It remains the integration branch and only deploys test/staging when explicitly enabled.

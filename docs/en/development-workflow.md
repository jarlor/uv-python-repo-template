# Development Workflow

## Daily Work

```bash
git switch dev
git pull --ff-only origin dev
git switch -c feature/your-change
```

Open PRs from short-lived branches to `dev`. Use Squash merge. PR titles must be Conventional Commit titles because the squash commit subject is used for governance and release history.

Examples:

```text
feat(api): add health endpoint
fix(config): load env file consistently
docs: document local setup
chore(ci): update workflow checks
```

## Release Work

When `dev` has been verified, open a PR from `dev` to `main`.

- Use Create merge commit.
- The PR title must start with `feat:`, `fix:`, or `perf:`.
- Merging to `main` runs semantic-release.
- Production deploy runs only when `PROD_DEPLOY_ENABLED=true`.
- Backmerge runs after semantic-release; when production deploy is enabled, it waits for deploy success.

## Hotfix Work

```bash
git switch main
git pull --ff-only origin main
git switch -c hotfix/urgent-fix
```

Open the hotfix PR to `main` and use Squash merge. Do not cherry-pick the hotfix to `dev`; use the automatic or manual `main -> dev` backmerge.

## Local Checks

```bash
uv run poe format-check
uv run poe lint
uv run poe test
uv run poe check
```

## Deployment Modes

`dev` does not require a test server. It only deploys test/staging when `TEST_DEPLOY_ENABLED=true`. `main` creates releases regardless of deployment, and deploys production only when `PROD_DEPLOY_ENABLED=true`.

# Git Workflow

This template uses two long-lived branches:

| Branch | Role | Environment |
| --- | --- | --- |
| `dev` | Integration truth | Optional test/staging deploy |
| `main` | Production truth | Optional production deploy |

`test` and `staging` are environments, not Git branches.

## Branch Rules

| Flow | Merge strategy | Notes |
| --- | --- | --- |
| short-lived branch -> `dev` | Squash merge | Use for features, fixes, docs, chores, and refactors |
| `dev` -> `main` | Create merge commit | Marks a tested release boundary |
| `hotfix/*` -> `main` | Squash merge | Use only for urgent production fixes |
| `main` -> `dev` | Backmerge with `--no-ff` | Syncs production truth back to integration |

## Standard Flow

```text
dev
  -> feature/* or fix/*
  -> PR to dev
  -> CI + PR governance
  -> Squash merge
  -> optional test deploy

dev verified
  -> PR dev to main
  -> CI + PR governance
  -> Create merge commit
  -> semantic-release
  -> optional prod deploy
  -> backmerge main to dev after release, or after prod deploy success when enabled
```

## Hotfix Flow

```text
main
  -> hotfix/*
  -> PR to main
  -> CI + PR governance
  -> Squash merge
  -> semantic-release
  -> optional prod deploy
  -> backmerge main to dev
```

Do not cherry-pick hotfixes to `dev`. Let the backmerge workflow carry production fixes back to integration. If backmerge conflicts, resolve the `main -> dev` merge manually and PR the resolution to `dev`.

## Commit Rules

All PR titles must follow Conventional Commit format:

```text
feat: add dashboard
fix(api): repair auth refresh
docs: update setup guide
chore(ci): align workflows
```

PRs into `main` must use a release-triggering type:

- `feat:`
- `fix:`
- `perf:`

Pushes to `dev` and `main` also run commit governance against first-parent landed commits. `main` accepts only `feat:`, `fix:`, `perf:`, `chore(release):`, and `chore(backmerge):`.

## GitHub Merge Settings

Set repository merge defaults so final commit subjects stay compatible with semantic-release:

- Squash merge title: PR title
- Squash merge message: PR body
- Create merge commit title: PR title
- Create merge commit message: PR body
- Automatically delete head branches: enabled

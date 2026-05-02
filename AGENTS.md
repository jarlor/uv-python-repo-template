# Agent Guide

This repository is a vibecoding starter template. Keep it small, explicit, and easy for an AI coding agent to operate from a clean clone.

## First Read

- `README.md` for the project promise and common commands.
- `docs/en/quickstart.md` for setup.
- `docs/en/git-workflow.md` for branch, PR, release, and backmerge rules.
- `docs/en/ci-cd.md` for workflow variables and deployment profiles.

## Default Workflow

- Work from short-lived branches.
- Target `dev` for normal changes.
- Target `main` only for release PRs or hotfixes.
- Use Conventional Commit titles and commit messages.
- Do not introduce a `test` branch; test/staging are environments.

## Quality Bar

Run before handing work back:

```bash
uv run poe check
```

If workflow or deploy scripts changed, also run:

```bash
bash -n scripts/cicd/*.sh scripts/init.sh scripts/pre-push.sh scripts/tag.sh
```

## Template Rules

- Keep deployment opt-in. Do not make new clones require test or production hosts.
- Keep release automation opt-in. `RELEASE_ENABLED=true` requires a working `RELEASE_TOKEN`.
- Prefer clear docs over long docs; this template is a starting point, not a product manual.
- Do not commit local environment files, generated caches, IDE files, or secrets.

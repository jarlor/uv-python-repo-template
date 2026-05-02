# GitHub Setup

## Branches

Use `main` as the default branch and keep `dev` as the integration branch.

Protect both branches:

- require pull requests before merging
- require CI and governance checks
- restrict direct pushes
- allow GitHub Actions to push release and backmerge commits

## Merge Settings

Configure merge defaults so final commit subjects match PR titles:

- Squash merge title: PR title
- Squash merge message: PR body
- Create merge commit title: PR title
- Create merge commit message: PR body
- Automatically delete head branches: enabled

## Actions Permissions

Set GitHub Actions workflow permissions to read/write so release and backmerge workflows can push tags and commits.

## Deployment Variables

Deployments are opt-in.

Test/staging:

- Secret: `TEST_SSH_HOST`
- Secret: `TEST_SSH_USER`
- Secret: `TEST_SSH_KEY`
- Variable: `TEST_DEPLOY_ENABLED`
- Variable: `TEST_DEPLOY_PATH`
- Variable: `TEST_SYSTEMD_SERVICE`
- Variable: `TEST_HEALTH_URL`
- Variable: `TEST_REPOSITORY_URL`

Production:

- Secret: `PROD_SSH_HOST`
- Secret: `PROD_SSH_USER`
- Secret: `PROD_SSH_KEY`
- Variable: `PROD_DEPLOY_ENABLED`
- Variable: `PROD_DEPLOY_PATH`
- Variable: `PROD_SYSTEMD_SERVICE`
- Variable: `PROD_HEALTH_URL`
- Variable: `PROD_REPOSITORY_URL`

Leave `TEST_DEPLOY_ENABLED` unset when the project has no test server. Leave `PROD_DEPLOY_ENABLED` unset when releases should create tags and GitHub Releases without deploying a host.

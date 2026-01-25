# GitHub Repository Setup

This guide covers the GitHub-specific configuration needed after initializing your project.

## Overview

After running `uv run poe init -y`, you need to configure your GitHub repository settings to enable:

- Branch protection rules (master only)
- Required status checks
- GitHub Actions permissions
- Secrets for deployment (if needed)

## Branch Protection Strategy

This template uses a **hybrid protection approach**:

### Master Branch: Hard Protection (GitHub)
- ✅ **Enforced on GitHub** - Cannot be bypassed
- ✅ Requires PR before merge
- ✅ Requires status checks to pass
- ✅ Prevents direct pushes from anyone

### Dev Branch: Soft Protection (Local)
- ✅ **Enforced locally** via pre-push hook
- ✅ Blocks direct push from developers
- ✅ Allows automated sync from master
- ❌ **No GitHub protection** - Keeps workflow simple

**Why this approach?**

1. **Master protection is critical** - Production code must be reviewed
2. **Dev protection is flexible** - Allows automated master → dev sync without complex GitHub App setup
3. **Developer experience** - Local hook provides immediate feedback
4. **Emergency bypass** - Developers can use `--no-verify` if needed

## 1. Branch Protection Rules

### For `master` Branch (Required)

**Branch name pattern:** `master`

**Settings to enable:**

- ✅ **Require a pull request before merging**
  - ✅ Require approvals: 1 (recommended for team projects)
  - ✅ Dismiss stale pull request approvals when new commits are pushed
  - ✅ Require review from Code Owners (optional)

- ✅ **Require status checks to pass before merging**
  - ✅ Require branches to be up to date before merging
  - **Required status checks:**
    - `pr-gate` (from PR Gate workflow)

- ✅ **Require conversation resolution before merging**

- ✅ **Require linear history** (optional, enforces squash merge)

- ✅ **Do not allow bypassing the above settings**

- ❌ **Allow force pushes** (keep disabled)

- ❌ **Allow deletions** (keep disabled)

**Additional settings:**

- ✅ **Restrict who can push to matching branches**
  - Add specific users/teams who can push (optional)

### For `dev` Branch (Not Required)

**⚠️ Do NOT set up branch protection for `dev` on GitHub.**

The `dev` branch is protected locally via pre-push hook:
- Installed automatically by `uv run poe init -y`
- Blocks direct push to `dev` branch
- Requires feature branch → PR workflow
- Allows automated sync from master

**If you accidentally set up dev protection:**
1. Go to **Settings** → **Branches**
2. Find the `dev` branch protection rule
3. Click **Delete** to remove it

## 2. GitHub Actions Permissions

Ensure GitHub Actions has the necessary permissions.

### Steps

1. Go to **Settings** → **Actions** → **General**
2. Under **Workflow permissions**, select:
   - ✅ **Read and write permissions**
   - ✅ **Allow GitHub Actions to create and approve pull requests**

**Why:** The workflows need write permissions to:
- Create releases
- Push to branches (for auto-sync)
- Update tags

## 3. Required Secrets (Optional)

If you're deploying to cloud providers or remote servers, configure these secrets.

### Steps

1. Go to **Settings** → **Secrets and variables** → **Actions**
2. Click **New repository secret**

### Common Deployment Secrets

| Secret Name | Description | Example |
|-------------|-------------|---------|
| `DOCKER_REGISTRY_URL` | Docker registry URL | `docker.io`, `ghcr.io` |
| `DOCKER_USERNAME` | Docker registry username | `myusername` |
| `DOCKER_PASSWORD` | Docker registry password/token | `ghp_xxxxx` |
| `SSH_PRIVATE_KEY` | SSH private key for deployment | `-----BEGIN RSA PRIVATE KEY-----...` |
| `DEPLOY_HOST` | Deployment server hostname | `deploy.example.com` |
| `DEPLOY_USER` | SSH user for deployment | `deploy` |
| `DEPLOY_PATH` | Deployment directory path | `/var/www/myapp` |

### Cloud Provider Secrets

**AWS:**
- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`
- `AWS_REGION`

**Google Cloud:**
- `GCP_PROJECT_ID`
- `GCP_SERVICE_ACCOUNT_KEY`

**Azure:**
- `AZURE_CREDENTIALS`
- `AZURE_SUBSCRIPTION_ID`

### Other Common Secrets

| Secret Name | Description | When Needed |
|-------------|-------------|-------------|
| `SLACK_WEBHOOK_URL` | Slack notifications | If using Slack integration |
| `SENTRY_DSN` | Sentry error tracking | If using Sentry |
| `CODECOV_TOKEN` | Code coverage reporting | If using Codecov |

## 4. Default Branch

Set the default branch to `master`.

### Steps

1. Go to **Settings** → **General**
2. Under **Default branch**, click the switch icon
3. Select `master`
4. Click **Update**

**Why:** This ensures:
- New PRs default to `master`
- Clone operations check out `master` by default
- GitHub UI shows `master` as the main branch

## 5. Repository Settings

### General Settings

**Settings** → **General**

- ✅ **Allow squash merging** (recommended)
- ❌ **Allow merge commits** (optional)
- ❌ **Allow rebase merging** (optional)

**Default commit message:**
- Select: **Pull request title**

**Why:** Squash merge keeps history clean and works well with Conventional Commits.

### Pull Requests

**Settings** → **General** → **Pull Requests**

- ✅ **Always suggest updating pull request branches**
- ✅ **Automatically delete head branches**

## 6. Collaborators and Teams

Add collaborators or teams with appropriate permissions.

### Steps

1. Go to **Settings** → **Collaborators and teams**
2. Click **Add people** or **Add teams**

### Recommended Permissions

| Role | Permissions | Who |
|------|-------------|-----|
| **Admin** | Full access | Repository owners |
| **Maintain** | Manage without destructive actions | Lead developers |
| **Write** | Push to non-protected branches | Developers |
| **Read** | View and clone | External contributors |

## 7. Webhooks (Optional)

Set up webhooks for external integrations.

### Common Integrations

- **Slack:** Notify on PR events, deployments
- **Discord:** Similar to Slack
- **Jira:** Link commits/PRs to issues
- **Sentry:** Track releases

### Steps

1. Go to **Settings** → **Webhooks**
2. Click **Add webhook**
3. Enter payload URL and select events

## 8. GitHub Pages (Optional)

If you want to host documentation:

### Steps

1. Go to **Settings** → **Pages**
2. Under **Source**, select:
   - Branch: `master` or `gh-pages`
   - Folder: `/docs` or `/` (root)
3. Click **Save**

## 9. Security Settings

### Dependabot

Enable Dependabot to keep dependencies up to date.

**Settings** → **Security** → **Code security and analysis**

- ✅ **Dependabot alerts**
- ✅ **Dependabot security updates**
- ✅ **Dependabot version updates**

Create `.github/dependabot.yml`:

```yaml
version: 2
updates:
  - package-ecosystem: "pip"
    directory: "/"
    schedule:
      interval: "weekly"
    open-pull-requests-limit: 10
```

### Code Scanning

Enable code scanning for security vulnerabilities.

**Settings** → **Security** → **Code security and analysis**

- ✅ **Code scanning**
- Select: **CodeQL analysis**

## 10. Verify Setup

After completing the setup, verify everything works:

### Test Branch Protection

1. Try to push directly to `dev`:
   ```bash
   git checkout dev
   echo "test" >> README.md
   git add README.md
   git commit -m "test: direct push"
   git push origin dev
   ```
   **Expected:** Push should be rejected

2. Create a PR instead:
   ```bash
   git checkout -b test/branch-protection
   git push origin test/branch-protection
   ```
   Create PR on GitHub → Should work

### Test PR Gate

1. Create a PR with failing tests
2. Verify PR Gate workflow runs
3. Verify merge is blocked until checks pass

### Test Auto-sync

1. Merge a PR to `master`
2. Check GitHub Actions
3. Verify `dev` branch is automatically updated

## Checklist

Use this checklist to ensure everything is configured:

- [ ] Branch protection enabled for `dev`
- [ ] Branch protection enabled for `master`
- [ ] Required status checks configured
- [ ] GitHub Actions permissions set to read/write
- [ ] Default branch set to `master`
- [ ] Squash merge enabled
- [ ] Auto-delete head branches enabled
- [ ] Secrets configured (if deploying)
- [ ] Collaborators added
- [ ] Dependabot enabled
- [ ] Verified branch protection works
- [ ] Verified PR Gate workflow works
- [ ] Verified auto-sync works

## Troubleshooting

### Issue: PR Gate not running

**Solution:** Check GitHub Actions permissions:
- Settings → Actions → General → Workflow permissions
- Ensure "Read and write permissions" is selected

### Issue: Auto-sync failing

**Solution:** Check the workflow logs:
- Actions → Sync master to dev
- Look for permission errors
- Ensure `contents: write` permission is set in workflow

### Issue: Can't push to protected branch

**Solution:** This is expected! Use the PR workflow:
1. Create a feature branch
2. Push to feature branch
3. Create PR to `dev` or `master`

### Issue: Status checks not required

**Solution:** 
1. Run the PR Gate workflow at least once
2. Go to branch protection settings
3. The status check should now appear in the list
4. Select it as required

## Next Steps

- [Learn the Development Workflow](development-workflow.md)
- [Explore Features](features.md)
- [Customize Workflows](../.github/workflows/)

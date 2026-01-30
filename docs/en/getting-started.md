# Getting Started

This guide will walk you through setting up your project using this template.

## Prerequisites

Before you begin, ensure you have:

- **Python 3.10 or higher** installed
- **Git** installed and configured
- **UV** package manager installed

### Installing UV

**macOS/Linux:**
```bash
curl -LsSf https://astral.sh/uv/install.sh | sh
```

**macOS (Homebrew):**
```bash
brew install uv
```

**Windows:**
```powershell
powershell -c "irm https://astral.sh/uv/install.ps1 | iex"
```

Verify installation:
```bash
uv --version
# Should output: uv 0.5.x or higher
```

## Step 1: Create Your Repository

### Option A: Use GitHub Template

1. Click "Use this template" button on GitHub
2. Choose a name for your repository
3. Clone your new repository:
   ```bash
   git clone https://github.com/YOUR_USERNAME/YOUR_REPO.git
   cd YOUR_REPO
   ```

### Option B: Clone and Rename

```bash
git clone https://github.com/jarlor/uv-python-repo-template.git my-project
cd my-project
rm -rf .git
git init
git remote add origin https://github.com/YOUR_USERNAME/YOUR_REPO.git
```

## Step 2: Initialize the Project

Run the initialization script:

```bash
uv run poe init -y
```

### What This Does

The `init` script performs the following actions:

1. **Renames the project** to match your directory name
   - Rewrites `pyproject.toml` metadata
   - Renames `src/uv_python_repo_template` to `src/YOUR_PROJECT_NAME` (adds `__init__.py` if missing)

2. **Sets up Git branches**
   - Renames `main` → `master` (if exists)
   - Creates `dev` branch
   - Switches to `dev` branch

3. **Installs pre-commit hooks**
   - `pre-commit`: Runs format + lint on Python files
   - `commit-msg`: Validates Conventional Commits format

4. **Displays post-init checklist**
   - GitHub settings to configure
   - Workflow TODOs
   - Required secrets

5. **Runs `uv sync`** so the virtual environment and lock files align with the freshly renamed package

### Post-Init Checklist

After running `init`, you'll see a checklist like this:

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📋 POST-INIT CHECKLIST
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🔧 WORKFLOW IMPLEMENTATION
  ☐ Implement smoke test in .github/workflows/pr_gate.yaml
  ☐ Implement deploy steps in .github/workflows/dev_deploy.yaml
  ☐ Implement deploy steps in .github/workflows/prod_deploy.yaml

🔒 GITHUB BRANCH PROTECTION (Settings → Branches)
  ☐ Protect 'master' branch (REQUIRED)
  ☐ Require pull request reviews before merge
  ☐ Require status checks to pass: "PR Gate"
  ☐ Restrict direct pushes to master
  
  ⚠️  Do NOT protect 'dev' branch on GitHub
  ℹ️  Dev is protected locally via pre-push hook

🔑 GITHUB SECRETS (Settings → Secrets and variables → Actions)
  ⚠️  Currently no deployment workflows configured
  ☐ Configure secrets when you implement deployment in:
     - .github/workflows/dev_deploy.yaml
     - .github/workflows/prod_deploy.yaml
  
  See docs/github-setup.md for common deployment secret examples
```

See [GitHub Setup Guide](github-setup.md) for detailed instructions.

## Step 3: Install Dependencies

```bash
# Install all dependencies including dev dependencies
uv sync --all-extras
```

This creates a virtual environment in `.venv` and installs:
- Project dependencies
- Development tools (ruff, mypy, pytest, etc.)
- Pre-commit hooks

## Step 4: Verify Setup

Run the following commands to verify everything is working:

```bash
# Format code
uv run poe format

# Run linters
uv run poe lint

# Run tests
uv run poe test

# Run smoke test
uv run poe smoke
```

All commands should complete successfully.

## Step 5: Make Your First Commit

```bash
# Create a feature branch
git checkout -b feature/initial-setup

# Make some changes (e.g., update README)
echo "# My Project" > README.md

# Commit with Conventional Commits format
git add README.md
git commit -m "docs: update project README"

# Push to remote
git push origin feature/initial-setup
```

The pre-commit hooks will automatically:
- Format your code with Ruff
- Run linters (Ruff + mypy)
- Validate your commit message format

## Step 6: Create Your First PR

1. Go to your repository on GitHub
2. Click "Compare & pull request"
3. Fill in the PR template
4. Wait for PR Gate workflow to pass
5. Merge the PR

## Next Steps

- [Configure GitHub Settings](github-setup.md)
- [Learn the Development Workflow](development-workflow.md)
- [Explore Features](features.md)

## Troubleshooting

### Pre-commit not found

If you see `pre-commit not found` error:

```bash
uv sync --all-extras
pre-commit install --hook-type pre-commit --hook-type commit-msg
```

### Python version mismatch

Ensure you're using Python 3.10+:

```bash
python --version
# or
python3 --version
```

Update `.python-version` if needed:

```bash
echo "3.10" > .python-version
```

### UV command not found

Ensure UV is in your PATH:

```bash
# Add to ~/.bashrc or ~/.zshrc
export PATH="$HOME/.cargo/bin:$PATH"

# Reload shell
source ~/.bashrc  # or source ~/.zshrc
```

## Common Issues

### Issue: "Branch 'main' not found"

**Solution:** The init script expects a `main` branch to rename to `master`. If you don't have one, create it first:

```bash
git checkout -b main
git push origin main
uv run poe init -y
```

### Issue: "Permission denied" when pushing

**Solution:** Ensure you have write access to the repository and your Git credentials are configured:

```bash
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
```

### Issue: Pre-commit hooks failing

**Solution:** Run the checks manually to see detailed errors:

```bash
uv run poe format
uv run poe lint
```

Fix the issues and try committing again.

## Getting Help

- Check the [Documentation](.)
- Open an [Issue](https://github.com/jarlor/uv-python-repo-template/issues)
- Start a [Discussion](https://github.com/jarlor/uv-python-repo-template/discussions)

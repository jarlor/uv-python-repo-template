#!/usr/bin/env bash

set -euo pipefail

force_run=false
reset_template=true
for arg in "$@"; do
    case "$arg" in
        -y|--yes)
            force_run=true
            ;;
        --reset|--reset-template|-r)
            reset_template=true
            ;;
        --no-reset)
            reset_template=false
            ;;
    esac
done

raw_dir_name=$(basename "$PWD")
dir_name=$(printf "%s" "$raw_dir_name" | tr '[:upper:]' '[:lower:]')
dir_name=${dir_name//[^a-z0-9_]/_}
dir_name=$(printf "%s" "$dir_name" | sed 's/_\+/_/g; s/^_//; s/_$//')

if [[ -z "$dir_name" ]]; then
    dir_name="app"
fi

if [[ "$dir_name" =~ ^[0-9] ]]; then
    dir_name="pkg_$dir_name"
fi

if [[ "$dir_name" == "uv_python_repo_template" && "$force_run" != "true" ]]; then
    echo "Refusing to run: project directory name still template default ('$dir_name')" >&2
    echo "Clone/rename the repo directory first, then re-run uv run poe init -y" >&2
    exit 2
fi

escaped_dir_name=$(printf "%s" "$dir_name" | sed 's/[\/&]/\\&/g')

if [[ ! -f "pyproject.toml" ]]; then
    echo "Error: pyproject.toml file not found" >&2
    exit 1
fi

if [[ "$force_run" != "true" ]]; then
    cat <<'EOF'
This init will:
- Keep or create a main branch
- Create dev branch (if missing)
- Create an initialization commit

Re-run with -y to proceed.
EOF
    exit 1
fi

sed -i.bak "s/uv_python_repo_template/$escaped_dir_name/g" pyproject.toml && rm pyproject.toml.bak

echo "✓ Updated pyproject.toml to use package '$dir_name'"

src_old="src/uv_python_repo_template"
src_new="src/$dir_name"
if [[ "$src_old" == "$src_new" ]]; then
    echo "Project package directory already matches '$src_new', skipping renaming"
elif [[ -d "$src_old" ]]; then
    mv "$src_old" "$src_new"
    echo "✓ Renamed package directory to '$src_new'"
else
    echo "Warning: '$src_old' directory not found, skipping renaming" >&2
fi

if [[ -d "$src_new" ]] && [[ ! -f "$src_new/__init__.py" ]]; then
    touch "$src_new/__init__.py"
fi

if [[ "$reset_template" == "true" ]]; then
    if [[ -f "CHANGELOG.md" ]]; then
        cat <<'EOF' > CHANGELOG.md
# Changelog

## [Unreleased]
- Initial release after resetting template metadata
EOF
        echo "✓ Reset CHANGELOG.md"
    else
        echo "Warning: CHANGELOG.md not found, skipping reset" >&2
    fi

    if command -v uv >/dev/null 2>&1; then
        uv run update-toml update --path project.version --value "0.1.0"
    elif command -v update-toml >/dev/null 2>&1; then
        update-toml update --path project.version --value "0.1.0"
    else
        echo "Error: update-toml command not found; install via uv or pip" >&2
        exit 1
    fi
    echo "✓ Reset pyproject.toml version to 0.1.0"
fi

if git rev-parse --git-dir > /dev/null 2>&1; then
    current_branch=$(git rev-parse --abbrev-ref HEAD)

    if ! git show-ref --verify --quiet refs/heads/main; then
        git branch main
    fi

    if ! git show-ref --verify --quiet refs/heads/dev; then
        git branch dev
    fi

    if [[ "$current_branch" == "main" ]]; then
        git checkout dev
    fi
else
    echo "Warning: git repository not found, skipping branch setup" >&2
fi

if [[ -d ".github/workflows" ]]; then
    if [[ ! -f ".github/workflows/ci.yml" ]]; then
        echo "Warning: .github/workflows/ci.yml is missing" >&2
    fi
    if [[ ! -f ".github/workflows/pr-governance.yml" ]]; then
        echo "Warning: .github/workflows/pr-governance.yml is missing" >&2
    fi
    if [[ ! -f ".github/workflows/commit-governance.yml" ]]; then
        echo "Warning: .github/workflows/commit-governance.yml is missing" >&2
    fi
    if [[ ! -f ".github/workflows/release.yml" ]]; then
        echo "Warning: .github/workflows/release.yml is missing" >&2
    fi
fi

if git remote get-url origin > /dev/null 2>&1; then
    remote_url=$(git remote get-url origin)
    echo "✓ Repository remote: $remote_url"
else
    echo "⚠️  Warning: git remote 'origin' not configured" >&2
fi

cat <<'EOF'

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📋 POST-INIT CHECKLIST
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🔧 WORKFLOW PROFILES
  ☐ Keep CI-only mode by leaving TEST_DEPLOY_ENABLED and PROD_DEPLOY_ENABLED unset
  ☐ Enable prod deploy only when production secrets and vars are configured
  ☐ Enable test deploy only when a separate test/staging server exists

🔒 GITHUB BRANCH PROTECTION (Settings → Branches)
  ☐ Protect 'dev' and 'main' branches
  ☐ Require pull request reviews before merge
  ☐ Require status checks to pass: "CI" and governance checks
  ☐ Restrict direct pushes to dev/main

🔑 GITHUB SECRETS (Settings → Secrets and variables → Actions)
  ☐ Optional test deploy: TEST_DEPLOY_ENABLED=true plus TEST_* secrets/vars
  ☐ Optional prod deploy: PROD_DEPLOY_ENABLED=true plus PROD_* secrets/vars
  
  See docs/en/ci-cd.md for common deployment secret examples

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF

git add pyproject.toml
if [[ -d "$src_new" ]]; then
    git add "$src_new"
fi
if [[ "$reset_template" == "true" && -f "CHANGELOG.md" ]]; then
    git add CHANGELOG.md
fi

if git diff --cached --quiet; then
    echo "No changes to commit"
else
    git commit -m "build: rename project to $dir_name"
fi

pre-commit install --hook-type pre-commit --hook-type commit-msg

if [[ -f "scripts/pre-push.sh" ]]; then
    cp scripts/pre-push.sh .git/hooks/pre-push
    chmod +x .git/hooks/pre-push
    echo "✓ Pre-push hook installed (blocks direct push to dev/main branches)"
fi

if command -v uv >/dev/null 2>&1; then
    echo "Running uv sync to refresh dependencies..."
    uv sync
else
    echo "Warning: 'uv' command not found; skipping uv sync" >&2
fi

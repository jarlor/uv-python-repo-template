#!/usr/bin/env bash

set -euo pipefail

force_run=false
for arg in "$@"; do
    if [[ "$arg" == "-y" ]]; then
        force_run=true
        break
    fi
done

dir_name=$(basename "$PWD")
dir_name=${dir_name//-/_}

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
- Rename branch main -> master (if present)
- Create dev branch (if missing)
- Create an initialization commit

Re-run with -y to proceed.
EOF
    exit 1
fi

sed -i.bak "s/uv_python_repo_template/$escaped_dir_name/g" pyproject.toml && rm pyproject.toml.bak

src_old="src/uv_python_repo_template"
src_new="src/$dir_name"
if [[ "$src_old" == "$src_new" ]]; then
    echo "Project package directory already matches '$src_new', skipping renaming"
elif [[ -d "$src_old" ]]; then
    mv "$src_old" "$src_new"
else
    echo "Warning: '$src_old' directory not found, skipping renaming" >&2
fi

if git rev-parse --git-dir > /dev/null 2>&1; then
    current_branch=$(git rev-parse --abbrev-ref HEAD)
    if [[ "$current_branch" == "main" ]]; then
        git branch -m master
        current_branch="master"
    fi

    if ! git show-ref --verify --quiet refs/heads/dev; then
        git branch dev
    fi

    if [[ "$current_branch" == "master" ]]; then
        git checkout dev
    fi
else
    echo "Warning: git repository not found, skipping branch setup" >&2
fi

if [[ -d ".github/workflows" ]]; then
    if [[ ! -f ".github/workflows/pr_gate.yaml" ]]; then
        echo "Warning: .github/workflows/pr_gate.yaml is missing" >&2
    fi
    if [[ ! -f ".github/workflows/dev_deploy.yaml" ]]; then
        echo "Warning: .github/workflows/dev_deploy.yaml is missing" >&2
    fi
    if [[ ! -f ".github/workflows/prod_deploy.yaml" ]]; then
        echo "Warning: .github/workflows/prod_deploy.yaml is missing" >&2
    fi
    if [[ ! -f ".github/workflows/release.yaml" ]]; then
        echo "Warning: .github/workflows/release.yaml is missing" >&2
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

🔧 WORKFLOW IMPLEMENTATION
  ☐ Implement smoke test in .github/workflows/pr_gate.yaml
  ☐ Implement deploy steps in .github/workflows/dev_deploy.yaml
  ☐ Implement deploy steps in .github/workflows/prod_deploy.yaml

🔒 GITHUB BRANCH PROTECTION (Settings → Branches)
  ☐ Protect 'dev' and 'master' branches
  ☐ Require pull request reviews before merge
  ☐ Require status checks to pass: "PR Gate"
  ☐ Restrict direct pushes to dev/master

🔑 GITHUB SECRETS (Settings → Secrets and variables → Actions)
  Required for ECS deployment:
  ☐ AWS_REGION
  ☐ AWS_ROLE_TO_ASSUME (OIDC role ARN)
  ☐ ECR_REGISTRY
  ☐ ECR_REPOSITORY
  ☐ ECS_CLUSTER
  ☐ ECS_SERVICE_WEB
  ☐ ECS_SERVICE_WORKER

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF

git add pyproject.toml
if [[ -d "$src_new" ]]; then
    git add "$src_new"
fi

if git diff --cached --quiet; then
    echo "No changes to commit"
else
    git commit -m "build: rename project to $dir_name"
fi

pre-commit install --hook-type pre-commit --hook-type commit-msg

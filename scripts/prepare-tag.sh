#!/usr/bin/env bash

set -euo pipefail

MODE="release"
VERSION="auto"
USE_SEMANTIC_RELEASE_CHANGELOG=false

while [[ $# -gt 0 ]]; do
    case $1 in
        --release)
            MODE="release"
            shift
            ;;
        --hotfix)
            MODE="hotfix"
            shift
            ;;
        *)
            if [[ "$1" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
                VERSION="$1"
                shift
            else
                echo "Error: Invalid argument '$1'"
                echo ""
                echo "Usage:"
                echo "  bash scripts/prepare-tag.sh [--release|--hotfix] [version]"
                echo ""
                echo "Examples:"
                echo "  bash scripts/prepare-tag.sh                    # Release, auto version"
                echo "  bash scripts/prepare-tag.sh --release          # Release, auto version"
                echo "  bash scripts/prepare-tag.sh 1.6.0              # Release, manual version"
                echo "  bash scripts/prepare-tag.sh --release 1.6.0    # Release, manual version"
                echo "  bash scripts/prepare-tag.sh --hotfix 1.5.2     # Hotfix, manual version"
                exit 1
            fi
            ;;
    esac
done

if [[ "$MODE" == "hotfix" ]] && [[ "$VERSION" == "auto" ]]; then
    echo "❌ Error: Hotfix mode requires a version number"
    echo ""
    echo "Usage:"
    echo "  bash scripts/prepare-tag.sh --hotfix 1.5.2"
    exit 1
fi

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
if [[ "$MODE" == "hotfix" ]]; then
    echo "🚨 Preparing HOTFIX release v${VERSION}"
else
    echo "📦 Preparing RELEASE"
fi
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

CURRENT_BRANCH=$(git branch --show-current)

if [[ "$MODE" == "hotfix" ]]; then
    if [ "$CURRENT_BRANCH" != "master" ]; then
        echo "❌ Error: Hotfix must be created from 'master' branch"
        echo "Current branch: $CURRENT_BRANCH"
        echo ""
        echo "Please run:"
        echo "  git checkout master"
        echo "  git pull origin master"
        echo "  uv run poe prepare-tag --hotfix $VERSION"
        exit 1
    fi
    
    echo "🔧 Hotfix mode: creating from master"
else
    if [ "$CURRENT_BRANCH" != "dev" ]; then
        echo "⚠️  Warning: You are on branch '$CURRENT_BRANCH', not 'dev'"
        echo "Releases are typically created from 'dev' branch."
        read -p "Continue anyway? (y/N) " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            exit 1
        fi
    fi
    
    echo "📦 Release mode: creating from $CURRENT_BRANCH"
fi

echo ""

if ! git diff-index --quiet HEAD --; then
    echo "❌ Error: You have uncommitted changes"
    git status --short
    exit 1
fi

if [[ "$VERSION" == "auto" ]]; then
    echo "🔍 Calculating next version using semantic-release..."
    echo ""
    
    echo "Running quality checks..."
    uv run poe lint
    uv run poe test
    uv run poe smoke
    echo ""
    
    NEXT_VERSION=$(uv run semantic-release version --print 2>&1 | tail -1)
    CURRENT_VERSION=$(grep '^version = ' pyproject.toml | cut -d'"' -f2)
    
    if [[ -z "$NEXT_VERSION" ]] || [[ "$NEXT_VERSION" == "$CURRENT_VERSION" ]] || [[ "$NEXT_VERSION" == *"isn't in any release groups"* ]]; then
        echo ""
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        echo "⚠️  No new version to release"
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        echo ""
        echo "Current version: $CURRENT_VERSION"
        echo ""
        echo "Possible reasons:"
        echo "  - No feat/fix commits since last release"
        echo "  - Only docs/style/test commits (don't trigger version bump)"
        echo "  - Branch 'dev' not configured in semantic-release"
        echo ""
        echo "Options:"
        echo "  1. Manual release:  uv run poe prepare-tag 1.6.0"
        echo "  2. Hotfix release:  uv run poe prepare-tag --hotfix 1.5.2"
        echo ""
        exit 1
    fi
    
    VERSION="$NEXT_VERSION"
    USE_SEMANTIC_RELEASE_CHANGELOG=true
    echo "✅ Next version: $VERSION"
    echo ""
    
else
    if [[ "$MODE" == "hotfix" ]]; then
        echo "🚨 Using hotfix version: $VERSION"
    else
        echo "📌 Using manual version: $VERSION"
    fi
    echo ""
fi
    
    VERSION="$NEXT_VERSION"
    echo "✅ Next version: $VERSION"
    echo ""
    
else
    if [[ "$MODE" == "hotfix" ]]; then
        echo "🚨 Using hotfix version: $VERSION"
    else
        echo "📌 Using manual version: $VERSION"
    fi
    echo ""
fi

if [[ "$MODE" == "hotfix" ]]; then
    BRANCH="hotfix/v${VERSION}"
else
    BRANCH="release/v${VERSION}"
fi

TAG="v${VERSION}"

if git show-ref --verify --quiet "refs/heads/$BRANCH"; then
    echo "❌ Error: Branch $BRANCH already exists"
    exit 1
fi

if git rev-parse "$TAG" >/dev/null 2>&1; then
    echo "❌ Error: Tag $TAG already exists"
    exit 1
fi

echo "1. Creating branch $BRANCH..."
git checkout -b "$BRANCH"

echo "2. Updating pyproject.toml..."
sed -i.bak "s/^version = .*/version = \"$VERSION\"/" pyproject.toml
rm -f pyproject.toml.bak
echo "   ✓ Updated version to $VERSION"

echo "3. Updating CHANGELOG.md..."
TODAY=$(date +%Y-%m-%d)

if [[ "$MODE" == "hotfix" ]]; then
    TEMP_FILE=$(mktemp)
    awk -v version="$VERSION" -v date="$TODAY" '
    /^## Unreleased/ {
        print $0
        print ""
        print ""
        print "## v" version " (" date ") - HOTFIX"
        print ""
        print "### Bug Fixes"
        print ""
        print "- TODO: Describe the critical fix"
        next
    }
    { print }
    ' CHANGELOG.md > "$TEMP_FILE"
    mv "$TEMP_FILE" CHANGELOG.md
    echo "   ✓ Added v$VERSION (HOTFIX) section"
    echo "   ⚠️  Please edit CHANGELOG.md to describe the fix"
    
elif [[ "$USE_SEMANTIC_RELEASE_CHANGELOG" == "true" ]]; then
    uv run semantic-release changelog
    echo "   ✓ Generated CHANGELOG using semantic-release"
    
else
    TEMP_FILE=$(mktemp)
    awk -v version="$VERSION" -v date="$TODAY" '
    /^## Unreleased/ {
        print $0
        print ""
        print ""
        print "## v" version " (" date ")"
        next
    }
    { print }
    ' CHANGELOG.md > "$TEMP_FILE"
    mv "$TEMP_FILE" CHANGELOG.md
    echo "   ✓ Moved Unreleased to v$VERSION ($TODAY)"
fi

echo ""
echo "4. Committing changes..."
git add pyproject.toml CHANGELOG.md uv.lock

if [[ "$MODE" == "hotfix" ]]; then
    git commit -m "chore: hotfix v${VERSION}"
else
    git commit -m "chore: release v${VERSION}"
fi

echo ""
echo "5. Pushing branch to remote..."
git push origin "$BRANCH"
echo "   ✓ Pushed $BRANCH to origin"

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✓ $(echo $MODE | tr '[:lower:]' '[:upper:]') branch prepared and pushed!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "Branch: $BRANCH"
echo "Version: $VERSION"
echo "Tag (will be created automatically): $TAG"
echo ""

if [[ "$MODE" == "hotfix" ]]; then
    echo "⚠️  HOTFIX CHECKLIST:"
    echo "  1. Edit CHANGELOG.md to describe the critical fix"
    echo "  2. Review all changes carefully"
    echo "  3. Ensure the fix is minimal and focused"
    echo ""
fi

echo "Next steps:"
echo "  1. Review the changes:"
echo "     git show HEAD"
if [[ "$MODE" == "hotfix" ]]; then
    echo "     git diff HEAD~1 CHANGELOG.md  # Edit if needed"
fi
echo ""
echo "  2. Create PR:"
if [[ "$MODE" == "hotfix" ]]; then
    echo "     gh pr create --title \"fix: critical issue (v${VERSION})\" --base master"
else
    echo "     gh pr create --title \"chore: release v${VERSION}\" --base master"
fi
echo ""
echo "  3. After PR is merged, tag v${VERSION} will be created automatically"
echo ""

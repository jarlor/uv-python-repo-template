#!/usr/bin/env bash

set -euo pipefail

VERSION="${1:-auto}"

if [[ "$VERSION" == "auto" ]]; then
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "🚀 Preparing Release (Automatic Versioning)"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    
    echo "1. Running quality checks..."
    uv run poe lint
    uv run poe test
    uv run poe smoke
    echo "   ✓ All checks passed"
    
    echo ""
    echo "2. Calculating next version..."
    NEXT_VERSION=$(uv run semantic-release version --print)
    CURRENT_VERSION=$(grep '^version = ' pyproject.toml | cut -d'"' -f2)
    
    if [[ "$NEXT_VERSION" == "$CURRENT_VERSION" ]]; then
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
        echo ""
        echo "To create a manual version:"
        echo "  uv run poe tag --version X.Y.Z"
        echo ""
        exit 1
    fi
    
    echo "   ✓ Next version: $NEXT_VERSION"
    
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "✓ Pre-release checks passed!"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo "Next steps:"
    echo "  1. Create a release PR from dev to main with a release-triggering title:"
    echo "     gh pr create --title \"feat: release v$NEXT_VERSION\" --base main --head dev"
    echo ""
    echo "  2. After the PR is merged, GitHub Actions will:"
    echo "     - Run semantic-release version"
    echo "     - Update pyproject.toml, CHANGELOG.md, uv.lock"
    echo "     - Create tag v$NEXT_VERSION"
    echo "     - Create GitHub Release"
    echo "     - Deploy prod only when PROD_DEPLOY_ENABLED=true"
    echo "     - Backmerge main to dev after a successful prod deploy"
    echo ""
else
    if [[ ! "$VERSION" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
        echo "Error: Version must be in format X.Y.Z (e.g., 1.5.0)"
        exit 1
    fi
    
    TAG="v${VERSION}"
    
    if git rev-parse "$TAG" >/dev/null 2>&1; then
        echo "Error: Tag $TAG already exists"
        exit 1
    fi
    
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "🚀 Preparing Manual Release: $TAG"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    
    echo "1. Running quality checks..."
    uv run poe lint
    uv run poe test
    uv run poe smoke
    echo "   ✓ All checks passed"
    
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "✓ Pre-release checks passed!"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo "Next steps:"
    echo "  1. Manually update files on a branch based on dev:"
    echo "     - pyproject.toml (version = \"$VERSION\")"
    echo "     - CHANGELOG.md (add release notes)"
    echo ""
    echo "  2. Commit changes:"
    echo "     git add pyproject.toml CHANGELOG.md"
    echo "     git commit -m \"chore: release v$VERSION\""
    echo ""
    echo "  3. Merge through dev, then create a release PR from dev to main:"
    echo "     gh pr create --title \"feat: release v$VERSION\" --base main --head dev"
    echo ""
    echo "  4. After the PR is merged, GitHub Actions will:"
    echo "     - Create tag v$VERSION"
    echo "     - Create GitHub Release"
    echo "     - Deploy prod only when PROD_DEPLOY_ENABLED=true"
    echo ""
fi

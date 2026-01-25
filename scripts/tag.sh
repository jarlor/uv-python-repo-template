#!/usr/bin/env bash

set -euo pipefail

VERSION="${1:-auto}"

if [[ "$VERSION" == "auto" ]]; then
    echo "Using automatic versioning (semantic-release)..."
    echo ""
    
    uv run poe lint
    uv run poe test
    uv run poe smoke
    
    semantic-release changelog
    
    NEXT_VERSION=$(semantic-release version --print)
    if [[ "$NEXT_VERSION" == "$(cat pyproject.toml | grep '^version = ' | cut -d'"' -f2)" ]]; then
        echo ""
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        echo "⚠️  No new version to release"
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        echo ""
        echo "Current version: $NEXT_VERSION"
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
    
    update-toml update --path project.version --value "$NEXT_VERSION"
    semantic-release version --no-push
    
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "✓ Release v$NEXT_VERSION created successfully!"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo "Next steps:"
    echo "  git push origin master --tags"
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
    
    echo "Creating manual release: $TAG"
    echo ""
    
    echo "1. Running quality checks..."
    uv run poe lint
    uv run poe test
    uv run poe smoke
    echo "   ✓ All checks passed"
    
    echo ""
    echo "2. Updating pyproject.toml version..."
    update-toml update --path project.version --value "$VERSION"
    echo "   ✓ Updated to $VERSION"
    
    echo ""
    echo "3. Updating CHANGELOG.md..."
    TODAY=$(date +%Y-%m-%d)
    
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
    
    echo ""
    echo "4. Committing changes..."
    git add pyproject.toml CHANGELOG.md uv.lock
    git commit -m "$VERSION" || echo "   (no changes to commit)"
    
    echo ""
    echo "5. Creating git tag..."
    git tag -a "$TAG" -m "$VERSION"
    echo "   ✓ Created tag $TAG"
    
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "✓ Release $TAG created successfully!"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo "Next steps:"
    echo "  1. Review the changes:"
    echo "     git show $TAG"
    echo ""
    echo "  2. Push to remote:"
    echo "     git push origin master --tags"
    echo ""
fi

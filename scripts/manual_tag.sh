#!/usr/bin/env bash

set -euo pipefail

VERSION="${1:-}"

if [[ -z "$VERSION" ]]; then
    echo "Error: Version is required"
    echo "Usage: uv run poe tag --version X.Y.Z"
    exit 1
fi

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

echo "1. Updating pyproject.toml version..."
update-toml update --path project.version --value "$VERSION"
echo "   ✓ Updated to $VERSION"

echo ""
echo "2. Updating CHANGELOG.md..."
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
echo "3. Committing changes..."
git add pyproject.toml CHANGELOG.md uv.lock
git commit -m "$VERSION" || echo "   (no changes to commit)"

echo ""
echo "4. Creating git tag..."
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

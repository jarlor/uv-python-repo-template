#!/usr/bin/env bash

set -euo pipefail

current_branch=$(git symbolic-ref --short HEAD 2>/dev/null || echo "")

if [[ "$current_branch" == "dev" || "$current_branch" == "main" ]]; then
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "Direct push to '$current_branch' is not allowed."
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo "Please use the PR workflow:"
    echo ""
    echo "  1. Create a short-lived branch:"
    echo "     git checkout -b feature/my-feature"
    echo ""
    echo "  2. Push that branch:"
    echo "     git push origin feature/my-feature"
    echo ""
    echo "  3. Create a Pull Request on GitHub:"
    echo "     feature/my-feature -> dev"
    echo "     dev -> main for releases"
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo "To bypass this check (emergency only):"
    echo "  git push --no-verify origin $current_branch"
    echo ""
    exit 1
fi

exit 0

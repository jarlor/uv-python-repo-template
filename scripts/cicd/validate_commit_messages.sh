#!/usr/bin/env bash
set -euo pipefail

TARGET_BRANCH="${TARGET_BRANCH:?TARGET_BRANCH is required}"
COMMIT_RANGE="${COMMIT_RANGE:-HEAD^..HEAD}"

conventional_regex='^(feat|fix|perf|docs|refactor|test|chore|ci|build|style|revert)(\([A-Za-z0-9._/-]+\))?!?: .+'
main_release_regex='^(feat|fix|perf)(\([A-Za-z0-9._/-]+\))?!?: .+'
main_allowed_chore_regex='^chore\((release|backmerge)\): .+'

if [[ "$COMMIT_RANGE" =~ ^0{40}\.\. ]]; then
  COMMIT_RANGE="${COMMIT_RANGE#*..}^..${COMMIT_RANGE#*..}"
fi

if ! commits="$(git rev-list --first-parent --reverse "$COMMIT_RANGE" 2>/dev/null)"; then
  echo "Invalid COMMIT_RANGE: $COMMIT_RANGE" >&2
  exit 1
fi

if [[ -z "$commits" ]]; then
  echo "No commits to validate for range: $COMMIT_RANGE"
  exit 0
fi

invalid=0
while IFS= read -r sha; do
  if [[ -z "$sha" ]]; then
    continue
  fi

  subject="$(git log -1 --format=%s "$sha")"
  if [[ "$TARGET_BRANCH" == "main" ]]; then
    if [[ "$subject" =~ $main_release_regex || "$subject" =~ $main_allowed_chore_regex ]]; then
      echo "ok $sha $subject"
      continue
    fi
  else
    if [[ "$subject" =~ $conventional_regex ]]; then
      echo "ok $sha $subject"
      continue
    fi
  fi

  echo "invalid $sha $subject" >&2
  invalid=1
done <<< "$commits"

if [[ "$invalid" -ne 0 ]]; then
  cat >&2 <<'EOF'
Commit message governance failed.

For PRs into dev, use Squash merge with a Conventional Commit title, for example:
  feat(api): add health endpoint

For dev -> main or hotfix -> main PRs, use a release-triggering title:
  feat(...): ...
  fix(...): ...
  perf(...): ...
EOF
  exit 1
fi

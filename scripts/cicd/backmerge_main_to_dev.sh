#!/usr/bin/env bash
set -euo pipefail

MAIN_BRANCH="${MAIN_BRANCH:-main}"
DEV_BRANCH="${DEV_BRANCH:-dev}"
REMOTE_NAME="${REMOTE_NAME:-origin}"

git fetch "$REMOTE_NAME" "$MAIN_BRANCH"

if git ls-remote --exit-code --heads "$REMOTE_NAME" "$DEV_BRANCH" >/dev/null 2>&1; then
  git fetch "$REMOTE_NAME" "$DEV_BRANCH"
  git checkout -B "$DEV_BRANCH" "$REMOTE_NAME/$DEV_BRANCH"
  git merge --no-ff -m "chore(backmerge): merge main into dev" "$REMOTE_NAME/$MAIN_BRANCH"
else
  git checkout -B "$DEV_BRANCH" "$REMOTE_NAME/$MAIN_BRANCH"
fi

git push "$REMOTE_NAME" "$DEV_BRANCH"

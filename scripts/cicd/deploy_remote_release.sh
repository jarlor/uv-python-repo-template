#!/usr/bin/env bash
set -euo pipefail

HOST=""
USER_NAME=""
SSH_KEY=""
DEPLOY_PATH=""
DEPLOY_BRANCH=""
SYSTEMD_SERVICE=""
HEALTH_URL=""
REPOSITORY_URL=""

usage() {
  cat <<'EOF'
Usage: deploy_remote_release.sh --host HOST --user USER --key KEY --deploy-path PATH --branch BRANCH --service SERVICE --health-url URL [--repository-url URL]
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --host)
      HOST="$2"
      shift 2
      ;;
    --user)
      USER_NAME="$2"
      shift 2
      ;;
    --key)
      SSH_KEY="$2"
      shift 2
      ;;
    --deploy-path)
      DEPLOY_PATH="$2"
      shift 2
      ;;
    --branch)
      DEPLOY_BRANCH="$2"
      shift 2
      ;;
    --service)
      SYSTEMD_SERVICE="$2"
      shift 2
      ;;
    --health-url)
      HEALTH_URL="$2"
      shift 2
      ;;
    --repository-url)
      REPOSITORY_URL="$2"
      shift 2
      ;;
    --help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown argument: $1" >&2
      usage >&2
      exit 2
      ;;
  esac
done

for required in HOST USER_NAME SSH_KEY DEPLOY_PATH DEPLOY_BRANCH SYSTEMD_SERVICE HEALTH_URL; do
  if [[ -z "${!required}" ]]; then
    echo "$required is required" >&2
    usage >&2
    exit 2
  fi
done

mkdir -p ~/.ssh
key_file=~/.ssh/deploy_key
printf '%s\n' "$SSH_KEY" | tr -d '\r' > "$key_file"
chmod 600 "$key_file"

ssh \
  -i "$key_file" \
  -o BatchMode=yes \
  -o StrictHostKeyChecking=accept-new \
  -o ConnectTimeout=30 \
  -o ConnectionAttempts=2 \
  -o ServerAliveInterval=15 \
  -o ServerAliveCountMax=4 \
  "${USER_NAME}@${HOST}" \
  "DEPLOY_PATH='${DEPLOY_PATH}' DEPLOY_BRANCH='${DEPLOY_BRANCH}' SYSTEMD_SERVICE='${SYSTEMD_SERVICE}' HEALTH_URL='${HEALTH_URL}' REPOSITORY_URL='${REPOSITORY_URL}' timeout 20m bash -s" <<'ENDSSH'
set -euo pipefail

if [[ ! -d "$DEPLOY_PATH/.git" ]]; then
  if [[ -z "$REPOSITORY_URL" ]]; then
    echo "REPOSITORY_URL is required when DEPLOY_PATH is not an existing git checkout." >&2
    exit 1
  fi
  rm -rf "$DEPLOY_PATH"
  git clone --branch "$DEPLOY_BRANCH" "$REPOSITORY_URL" "$DEPLOY_PATH"
fi

cd "$DEPLOY_PATH"
if [[ -n "$REPOSITORY_URL" ]]; then
  git remote set-url origin "$REPOSITORY_URL"
fi
git fetch origin "$DEPLOY_BRANCH"
git checkout -f "$DEPLOY_BRANCH"
git reset --hard "origin/$DEPLOY_BRANCH"

if command -v uv >/dev/null 2>&1; then
  uv sync --frozen --no-dev
else
  echo "uv executable not found on remote host" >&2
  exit 1
fi

if [[ -f "src/frontend/package-lock.json" ]]; then
  npm --prefix src/frontend ci --omit=dev --no-audit --no-fund
  npm --prefix src/frontend run build
fi

sudo systemctl restart "$SYSTEMD_SERVICE"
sleep 5
curl -sf --max-time 10 "$HEALTH_URL" >/dev/null
ENDSSH

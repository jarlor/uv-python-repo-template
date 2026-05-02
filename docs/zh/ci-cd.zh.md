# CI/CD 配置

## Workflows

| Workflow | 触发 | 默认行为 |
| --- | --- | --- |
| `ci.yml` | PR 和 push 到 `dev`/`main` | Python 检查、可选前端构建、shell 语法检查 |
| `pr-governance.yml` | PR 到 `dev`/`main` | 校验 PR title 的 Conventional Commit 格式 |
| `commit-governance.yml` | push 到 `dev`/`main` | 校验 first-parent 上真实落地的 commit subject |
| `deploy-test.yml` | push 到 `dev`、手动触发 | 未设置 `TEST_DEPLOY_ENABLED=true` 时跳过 |
| `release.yml` | push 到 `main`、手动触发 | 未设置 `RELEASE_ENABLED=true` 时跳过；生产部署也需要显式开启 |
| `backmerge-main-to-dev.yml` | 手动触发 | 用于故障恢复的 `main -> dev` backmerge |

## 默认检查

这些检查适合所有项目默认启用：

- Python quality：`uv sync --frozen --group dev` 和 `uv run poe check`
- 当存在 `src/frontend/package-lock.json` 时运行可选前端检查
- 检查 `scripts/cicd/*.sh` 和 `scripts/deploy/*.sh` 的 shell 语法
- PR 和 commit governance

## 可选测试环境部署

只有项目有独立测试/预发主机时才设置 `TEST_DEPLOY_ENABLED=true`。

Secrets:

- `TEST_SSH_HOST`
- `TEST_SSH_USER`
- `TEST_SSH_KEY`

Variables:

- `TEST_DEPLOY_PATH`
- `TEST_SYSTEMD_SERVICE`
- `TEST_HEALTH_URL`
- `TEST_REPOSITORY_URL`

## 可选生产部署

只有生产 SSH 部署配置完成后才设置 `PROD_DEPLOY_ENABLED=true`。

Secrets:

- `PROD_SSH_HOST`
- `PROD_SSH_USER`
- `PROD_SSH_KEY`

Variables:

- `PROD_DEPLOY_PATH`
- `PROD_SYSTEMD_SERVICE`
- `PROD_HEALTH_URL`
- `PROD_REPOSITORY_URL`

## 可选 release 自动化

只有 `RELEASE_TOKEN` 被仓库 ruleset 允许向 `main` 推 release commit 和 tag 后，才设置 `RELEASE_ENABLED=true`。

必需 Secret:

- `RELEASE_TOKEN`

必需 Variable:

- `RELEASE_ENABLED`

release 自动化关闭时，`release.yml` 会跳过，`main` 仍然运行 CI 和 commit governance。

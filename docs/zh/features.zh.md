# 功能特性

## Python 项目基线

- uv 依赖管理
- Ruff 格式化和 lint
- mypy 类型检查
- pytest 测试
- poe 任务入口
- pre-commit 和 commit-msg hooks

## CI 和治理

- `ci.yml` 运行 Python 质量检查和可选前端构建。
- `pr-governance.yml` 校验 PR title 的 Conventional Commit 格式。
- `commit-governance.yml` 校验 `dev` 和 `main` 上真实落地的 commit subject。
- 存在部署脚本时，会检查 shell 语法。

## 发版自动化

- semantic-release 根据 Conventional Commit 历史计算版本。
- 发版从 `main` 运行。
- 没有新版本时不会部署。
- GitHub tag 和 Release 由 release workflow 创建。
- 未配置 `RELEASE_ENABLED=true` 和 `RELEASE_TOKEN` 前，自动发版保持关闭。

## 可选部署

部署默认关闭：

- `deploy-test.yml` 仅在 `TEST_DEPLOY_ENABLED=true` 时运行。
- `release.yml` 仅在 `PROD_DEPLOY_ENABLED=true` 时部署生产。
- 只有生产环境的项目可以使用 `prod-only`。
- 没有服务器的项目可以保持 `ci-only`。

## Backmerge

生产发版部署成功后，`main` 会用以下 commit message 合并回 `dev`：

```text
chore(backmerge): merge main into dev
```

故障恢复时可以手动运行 `backmerge-main-to-dev.yml`。

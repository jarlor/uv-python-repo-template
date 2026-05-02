# 开发流程

## 日常开发

```bash
git switch dev
git pull --ff-only origin dev
git switch -c feature/your-change
```

短分支向 `dev` 开 PR，使用 Squash merge。PR title 必须符合 Conventional Commit，因为 squash commit subject 会用于治理和发版历史。

示例：

```text
feat(api): add health endpoint
fix(config): load env file consistently
docs: document local setup
chore(ci): update workflow checks
```

## 发布

`dev` 验证完成后，从 `dev` 向 `main` 开 PR。

- 使用 Create merge commit。
- PR title 必须以 `feat:`、`fix:` 或 `perf:` 开头。
- 合入 `main` 后运行 semantic-release。
- 仅当 `PROD_DEPLOY_ENABLED=true` 时部署生产。
- semantic-release 成功后执行 backmerge；启用生产部署时需等待部署成功。

## Hotfix

```bash
git switch main
git pull --ff-only origin main
git switch -c hotfix/urgent-fix
```

hotfix PR 直接进入 `main`，使用 Squash merge。不要手动 cherry-pick 到 `dev`，用自动或手动 `main -> dev` backmerge。

## 本地检查

```bash
uv run poe format-check
uv run poe lint
uv run poe test
uv run poe check
```

## 部署模式

`dev` 不要求一定有测试服务器。只有 `TEST_DEPLOY_ENABLED=true` 时才部署 test/staging。`main` 无论是否部署都会执行 release 判断；只有 `PROD_DEPLOY_ENABLED=true` 时才部署生产。

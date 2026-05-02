# 快速开始

## 创建项目

```bash
git clone https://github.com/jarlor/uv-python-repo-template.git my-project
cd my-project
uv run poe init -y
```

初始化脚本会重命名包名，保留或创建 `main`，创建 `dev`，重置版本元数据，并安装本地 hooks。

## 配置 GitHub

将仓库默认分支设置为 `main`。

推荐仓库设置：

- 保护 `main`，要求 PR 合并
- 短分支使用 Squash merge
- Squash merge title 使用 PR title
- Create merge commit title 使用 PR title
- 自动删除已合并的 head branch

`dev` 也可以保护，但必须仍允许项目 owner 或自动化在需要时从 `main` backmerge。

## 开始开发

```bash
git switch dev
git pull --ff-only origin dev
git switch -c feature/my-feature
git commit -m "feat: add health endpoint"
git push origin feature/my-feature
```

先向 `dev` 开 PR。`dev` 验证完成后，再从 `dev` 向 `main` 开发布 PR。

## 本地检查

```bash
uv run poe format-check
uv run poe lint
uv run poe test
uv run poe check
uv run poe smoke
```

## 部署 Profile

默认不启用任何部署。

| Profile | 必需配置 |
| --- | --- |
| 只跑 CI | 无 |
| 只有生产 | `PROD_DEPLOY_ENABLED=true` 以及 `PROD_*` secrets/vars |
| 测试和生产 | `TEST_DEPLOY_ENABLED=true` 和 `PROD_DEPLOY_ENABLED=true` |

release 自动化也需要显式开启。只有当仓库规则允许某个 token 向 `main` 推 release commit 和 tag 后，才配置 `RELEASE_ENABLED=true` 和 `RELEASE_TOKEN`。

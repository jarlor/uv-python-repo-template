# 快速开始

## 1. 创建项目

```bash
git clone https://github.com/jarlor/uv-python-repo-template.git my-project
cd my-project
uv run poe init -y
```

初始化脚本会：

- 将包名改成当前目录名
- 保留或创建 `main`
- 缺少 `dev` 时创建 `dev`
- 安装 pre-commit、commit-msg 和 pre-push hooks
- 为新项目重置版本元数据

## 2. 配置 GitHub

将仓库默认分支设置为 `main`。保护 `dev` 和 `main`，并要求以下检查通过：

- CI
- PR Governance
- Commit Governance

merge 设置、secrets 和 variables 见 [GitHub 设置](github-setup.zh.md)。

## 3. 开始开发

```bash
git switch dev
git pull --ff-only origin dev
git switch -c feature/my-feature
```

使用 Conventional Commit 提交：

```bash
git commit -m "feat: add health endpoint"
git push origin feature/my-feature
```

先向 `dev` 开 PR。`dev` 验证完成后，再从 `dev` 向 `main` 开发布 PR。

## 4. 选择部署 Profile

默认不启用任何部署。

| Profile | 必需配置 |
| --- | --- |
| 只跑 CI | 无 |
| 只有生产 | `PROD_DEPLOY_ENABLED=true` 以及 `PROD_*` secrets/vars |
| 测试和生产 | `TEST_DEPLOY_ENABLED=true` 和 `PROD_DEPLOY_ENABLED=true` |

没有测试服务器也可以保留 `dev`。它仍然是集成分支，只有显式开启时才部署 test/staging。

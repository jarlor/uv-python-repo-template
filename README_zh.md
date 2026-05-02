# UV Python 项目模板

[![Built with UV](https://img.shields.io/badge/built%20with-uv-7966C7)](https://github.com/astral-sh/uv)
[![Conventional Commits](https://img.shields.io/badge/Conventional%20Commits-1.0.0-%23FE5196)](https://www.conventionalcommits.org)
[![Python 3.10+](https://img.shields.io/badge/python-3.10+-blue.svg)](https://www.python.org/downloads/)

[English](README.md) | [文档](docs/)

> 基于 uv 的生产项目模板，内置 GitHub Actions、语义化发版、Git 治理，以及可选启用的测试/生产部署流程。

## 开箱能力

- 使用 uv 快速初始化并重命名项目
- `dev`/`main` 双长期分支模型
- PR title 和落地 commit 双重治理
- Python CI 和可选前端构建
- semantic-release 自动生成 changelog、tag 和 GitHub Release
- 测试环境和生产环境部署均为显式 opt-in
- semantic-release 成功后自动 `main -> dev` backmerge；启用生产部署时需等部署成功

## 快速开始

```bash
git clone https://github.com/jarlor/uv-python-repo-template.git my-project
cd my-project
uv run poe init -y
```

初始化会把包名改成当前目录名，保留或创建 `main`，创建 `dev`，安装 hooks，并输出 GitHub 配置清单。

日常开发从 `dev` 拉短分支：

```bash
git switch dev
git pull --ff-only origin dev
git switch -c feature/my-feature
git commit -m "feat: add new feature"
git push origin feature/my-feature
```

## Git 模型

`dev` 是集成分支，`main` 是生产事实分支。`test`/`staging` 是环境，不是 Git 分支。

```text
feature/*, fix/*, docs/*, chore/*
  -> PR 到 dev
  -> Squash merge
  -> CI + 可选测试环境部署

dev
  -> PR 到 main
  -> Create merge commit
  -> semantic-release
  -> 可选生产部署
  -> release 成功后 backmerge main 到 dev；启用生产部署时需等部署成功

hotfix/*
  -> 从 main 拉分支
  -> PR 到 main
  -> Squash merge
  -> semantic-release + 可选生产部署
  -> backmerge main 到 dev
```

所有 PR title 必须符合 Conventional Commit。进入 `main` 的 PR title 必须使用会触发发版的类型：`feat:`、`fix:` 或 `perf:`。

## 部署 Profile

CI 和 Git 治理默认启用。部署能力通过 GitHub Variables 显式开启。

| Profile | Variables | 行为 |
| --- | --- | --- |
| `ci-only` | 无 | 只跑 CI、治理和 semantic-release |
| `prod-only` | `PROD_DEPLOY_ENABLED=true` | `main` 发版后部署生产 |
| `test-and-prod` | `TEST_DEPLOY_ENABLED=true`, `PROD_DEPLOY_ENABLED=true` | `dev` 部署测试，`main` 发版后部署生产 |

常用部署配置：

| 环境 | Secrets | Variables |
| --- | --- | --- |
| 测试 | `TEST_SSH_HOST`, `TEST_SSH_USER`, `TEST_SSH_KEY` | `TEST_DEPLOY_ENABLED`, `TEST_DEPLOY_PATH`, `TEST_SYSTEMD_SERVICE`, `TEST_HEALTH_URL`, `TEST_REPOSITORY_URL` |
| 生产 | `PROD_SSH_HOST`, `PROD_SSH_USER`, `PROD_SSH_KEY` | `PROD_DEPLOY_ENABLED`, `PROD_DEPLOY_PATH`, `PROD_SYSTEMD_SERVICE`, `PROD_HEALTH_URL`, `PROD_REPOSITORY_URL` |

## Workflows

- `ci.yml`：Python 检查、可选前端构建、shell 语法检查
- `pr-governance.yml`：PR title 规则
- `commit-governance.yml`：`dev`/`main` 落地 commit 规则
- `deploy-test.yml`：从 `dev` 可选部署测试/预发环境
- `release.yml`：从 `main` semantic-release，并可选部署生产
- `backmerge-main-to-dev.yml`：手动应急 backmerge

## 常用命令

```bash
uv run poe format          # 使用 Ruff 格式化代码
uv run poe format-check    # 检查格式
uv run poe lint            # Ruff + mypy
uv run poe test            # pytest
uv run poe check           # 格式检查 + lint + test
uv run poe smoke           # import 冒烟测试
uv run poe tag             # 预览下一次 semantic-release 版本
uv run poe init -y         # 初始化新项目
```

## 文档

| 文档 | 说明 |
| --- | --- |
| [Git 工作流](docs/zh/git-workflow.zh.md) | 分支、PR、发版和 backmerge 规则 |
| [GitHub 设置](docs/zh/github-setup.zh.md) | 分支保护、merge 设置、secrets 和 variables |
| [开发流程](docs/zh/development-workflow.zh.md) | 日常功能、发版和 hotfix 流程 |
| [功能特性](docs/zh/features.zh.md) | 模板能力和 workflow 概览 |

## 环境要求

- Python 3.10+
- uv 0.5.0+
- Git

## 许可证

MIT License - 详见 [LICENSE](LICENSE)

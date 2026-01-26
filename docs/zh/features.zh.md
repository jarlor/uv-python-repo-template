# 功能特性

本文档深入介绍此模板包含的所有功能。

## 目录

- [UV 包管理器](#uv-包管理器)
- [自动版本控制](#自动版本控制)
- [Pre-commit Hooks](#pre-commit-hooks)
- [GitHub Actions Workflows](#github-actions-workflows)
- [分支自动同步](#分支自动同步)
- [PR 模板](#pr-模板)
- [Poe 任务运行器](#poe-任务运行器)
- [代码质量工具](#代码质量工具)

---

## UV 包管理器

[UV](https://github.com/astral-sh/uv) 是用 Rust 编写的极速 Python 包管理器。

### 为什么选择 UV？

- **10-100 倍更快** 比 pip
- **统一工具** - 替代 pip、pip-tools、pipx、poetry、pyenv、virtualenv
- **可重现** - lock 文件确保一致的安装
- **兼容** - 与现有 pip/requirements.txt 项目兼容

### 关键命令

```bash
# 安装依赖
uv sync --all-extras

# 添加包
uv add requests

# 添加开发依赖
uv add --dev pytest

# 在虚拟环境中运行命令
uv run python script.py

# 运行 poe 任务
uv run poe test
```

### 配置

UV 在 `pyproject.toml` 中配置：

```toml
[project]
name = "my-project"
version = "1.0.0"
requires-python = ">=3.10"

[dependency-groups]
dev = [
    "mypy>=1.15.0",
    "pytest>=8.3.4",
    "ruff>=0.9.5",
]
```

---

## 自动版本控制

基于 [Conventional Commits](https://www.conventionalcommits.org) 的语义化版本控制。

### 工作原理

1. **使用约定格式提交：**
   ```bash
   git commit -m "feat: add user authentication"
   ```

2. **运行 tag 命令：**
   ```bash
   uv run poe tag
   ```

3. **自动版本计算：**
   - `feat:` → Minor 升级 (1.2.3 → 1.3.0)
   - `fix:` → Patch 升级 (1.2.3 → 1.2.4)
   - `feat!:` 或 `BREAKING CHANGE:` → Major 升级 (1.2.3 → 2.0.0)

4. **自动更新：**
   - `CHANGELOG.md` - 从提交消息生成
   - `pyproject.toml` - 版本号更新
   - Git tag 创建（例如，`v1.3.0`）

### 配置

在 `pyproject.toml` 中配置：

```toml
[tool.poe.tasks]
tag = { sequence = ["lint", "test", "smoke", "_tag_changelog", "_tag_update_toml_version", "_tag_version"] }

[semantic_release]
assets = ["pyproject.toml", "uv.lock"]

[semantic_release.remote]
ignore_token_for_push = true
```

---

## Pre-commit Hooks

每次提交前运行的自动检查。

### 已安装的 Hooks

1. **Format (Ruff)** - 自动格式化 Python 代码
2. **Lint (Ruff)** - 检查代码质量
3. **Lint (mypy)** - 类型检查
4. **Commit Message** - 验证 Conventional Commits 格式

### 配置

在 `.pre-commit-config.yaml` 中定义：

```yaml
repos:
  - repo: local
    hooks:
      - id: format
        name: Format (ruff)
        entry: uv run poe format
        language: system
        types: [python]
        stages: [pre-commit]

      - id: commit-msg
        name: Conventional Commit Message
        entry: uv run python scripts/check_commit_message.py
        language: system
        stages: [commit-msg]
```

---

## GitHub Actions Workflows

自动化 CI/CD 流水线。

### PR Gate Workflow

**文件：** `.github/workflows/pr_gate.yaml`

**触发：** Pull requests 到 `dev` 或 `master`

**步骤：**
1. Checkout 代码
2. 安装 UV 和 Python
3. 安装依赖
4. 运行 lint 检查
5. 运行测试
6. 运行 smoke 测试

**目的：** 确保合并前的代码质量。

### Dev Deploy Workflow

**文件：** `.github/workflows/dev_deploy.yaml`

**触发：** 推送到 `dev` 分支

**目的：** 自动部署到 dev 环境进行测试。

### Prod Deploy Workflow

**文件：** `.github/workflows/prod_deploy.yaml`

**触发：** 推送匹配 `v*.*.*` 的 tags

**目的：** 发版时部署到生产环境。

### Release Workflow

**文件：** `.github/workflows/release.yaml`

**触发：** 推送匹配 `v*.*.*` 的 tags

**步骤：**
1. Checkout 代码
2. 从 CHANGELOG 提取发版说明
3. 创建 GitHub Release
4. 将 master 更改同步到 dev

**目的：** 创建 GitHub Release 并同步分支。

### Sync Dev Workflow

**文件：** `.github/workflows/sync_dev.yaml`

**触发：** 推送到 `master` 分支

**步骤：**
1. Checkout 完整历史的代码
2. Fetch dev 分支
3. 将 master 合并到 dev
4. 推送更新的 dev 分支

**目的：** 保持 dev 分支与 master 同步。

---

## 分支自动同步

自动将 master 更改同步回 dev。

### 为什么需要自动同步？

**问题：** 合并到 master 后，dev 分支落后：

```
master: A → B → C → D (merge commit)
dev:    A → B → C
```

**解决方案：** 自动同步 workflow 将 master 合并回 dev：

```
master: A → B → C → D
dev:    A → B → C → D (自动同步)
```

### 工作原理

1. **任何推送到 master** 触发 `sync_dev.yaml`
2. Workflow fetch 两个分支
3. 使用 `--no-edit` 将 master 合并到 dev
4. 推送更新的 dev 分支

---

## PR 模板

带检查清单的结构化 PR 描述。

### 模板位置

`.github/pull_request_template.md`

### 模板部分

1. **变更目的** - 更改的目的
2. **影响范围** - 影响范围
3. **测试证据** - 测试证据
4. **风险点** - 风险点
5. **回滚方案** - 回滚计划
6. **跨仓库依赖** - 跨仓库依赖
7. **提交前自检** - 提交前检查清单

---

## Poe 任务运行器

[Poe the Poet](https://poethepoet.natn.io/) - Python 项目的任务运行器。

### 可用任务

```bash
# 代码质量
uv run poe format          # 使用 Ruff 格式化代码
uv run poe lint_ruff       # 使用 Ruff lint
uv run poe lint_mypy       # 使用 mypy 类型检查
uv run poe lint            # 运行所有 linters

# 测试
uv run poe test            # 运行 pytest
uv run poe smoke           # 运行 smoke 测试

# 发版
uv run poe tag             # 创建版本 tag

# 设置
uv run poe init -y         # 初始化项目
```

### 配置

在 `pyproject.toml` 中定义：

```toml
[tool.poe.tasks]
format = "ruff format"
lint_ruff = "ruff check src/"
lint_mypy = "mypy --install-types --non-interactive"
lint = { sequence = ["lint_ruff", "lint_mypy"] }
test = "pytest"
```

---

## 代码质量工具

### Ruff

快速的 Python linter 和 formatter（用 Rust 编写）。

**配置：** `pyproject.toml`

```toml
[tool.ruff]
line-length = 100
target-version = "py310"
src = ["src"]
```

**命令：**
```bash
# 格式化代码
uv run ruff format

# 检查代码
uv run ruff check src/

# 自动修复问题
uv run ruff check src/ --fix
```

### mypy

Python 的静态类型检查器。

**配置：** `pyproject.toml`

```toml
[tool.mypy]
python_version = "3.10"
mypy_path = ["src"]
files = ["src"]
ignore_missing_imports = true
```

### pytest

测试框架。

**配置：** `pyproject.toml`

```toml
[tool.pytest.ini_options]
minversion = "8.0"
testpaths = ["tests"]
pythonpath = ["src"]
addopts = "--verbose --color=yes"
```

---

## 总结

此模板提供：

- ⚡ **快速设置** 使用 UV
- 🤖 **自动版本控制** 使用 semantic-release
- 🔒 **质量门禁** 使用 pre-commit hooks
- 🚀 **CI/CD** 使用 GitHub Actions
- 📦 **分支自动同步**
- 📝 **结构化 PRs** 使用模板
- 🛠️ **任务自动化** 使用 Poe
- ✨ **代码质量** 使用 Ruff + mypy + pytest

所有功能协同工作，提供生产就绪的开发工作流。

## 下一步

- [快速开始](getting-started.zh.md)
- [GitHub 设置](github-setup.zh.md)
- [开发流程](development-workflow.zh.md)

# 快速开始

本指南将引导你使用此模板设置项目。

## 前置要求

开始之前，请确保你已安装：

- **Python 3.10 或更高版本**
- **Git** 并已配置
- **UV** 包管理器

### 安装 UV

**macOS/Linux:**
```bash
curl -LsSf https://astral.sh/uv/install.sh | sh
```

**macOS (Homebrew):**
```bash
brew install uv
```

**Windows:**
```powershell
powershell -c "irm https://astral.sh/uv/install.ps1 | iex"
```

验证安装：
```bash
uv --version
# 应输出：uv 0.5.x 或更高版本
```

## 步骤 1：创建你的仓库

### 方案 A：使用 GitHub 模板

1. 在 GitHub 上点击 "Use this template" 按钮
2. 为你的仓库选择一个名称
3. 克隆你的新仓库：
   ```bash
   git clone https://github.com/YOUR_USERNAME/YOUR_REPO.git
   cd YOUR_REPO
   ```

### 方案 B：克隆并重命名

```bash
git clone https://github.com/jarlor/uv-python-repo-template.git my-project
cd my-project
rm -rf .git
git init
git remote add origin https://github.com/YOUR_USERNAME/YOUR_REPO.git
```

## 步骤 2：初始化项目

运行初始化脚本：

```bash
uv run poe init -y
```

### 这会做什么

`init` 脚本执行以下操作：

1. **重命名项目** 以匹配你的目录名
   - 更新 `pyproject.toml`
   - 重命名 `src/uv_python_repo_template` 为 `src/YOUR_PROJECT_NAME`

2. **设置 Git 分支**
   - 重命名 `main` → `master`（如果存在）
   - 创建 `dev` 分支
   - 切换到 `dev` 分支

3. **安装 pre-commit hooks**
   - `pre-commit`: 在 Python 文件上运行 format + lint
   - `commit-msg`: 验证 Conventional Commits 格式

4. **显示初始化后检查清单**
   - 需要配置的 GitHub 设置
   - Workflow 待办事项
   - 必需的 secrets

### 初始化后检查清单

运行 `init` 后，你会看到类似这样的检查清单：

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📋 初始化后检查清单
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🔧 WORKFLOW 实现
  ☐ 在 .github/workflows/pr_gate.yaml 中实现 smoke test
  ☐ 在 .github/workflows/dev_deploy.yaml 中实现部署步骤
  ☐ 在 .github/workflows/prod_deploy.yaml 中实现部署步骤

🔒 GITHUB 分支保护 (Settings → Branches)
  ☐ 保护 'master' 分支（必需）
  ☐ 合并前需要 pull request 审查
  ☐ 需要状态检查通过："PR Gate"
  ☐ 限制直接推送到 master
  
  ⚠️  不要在 GitHub 上保护 'dev' 分支
  ℹ️  Dev 通过本地 pre-push hook 保护

🔑 GITHUB SECRETS (Settings → Secrets and variables → Actions)
  ⚠️  当前未配置部署 workflows
  ☐ 实现部署时需配置 secrets：
     - .github/workflows/dev_deploy.yaml
     - .github/workflows/prod_deploy.yaml
  
  常见部署 secrets 示例请参见 docs/github-setup.zh.md
```

详细说明请参见 [GitHub 设置指南](github-setup.zh.md)。

## 步骤 3：安装依赖

```bash
# 安装所有依赖，包括开发依赖
uv sync --all-extras
```

这会在 `.venv` 中创建虚拟环境并安装：
- 项目依赖
- 开发工具（ruff、mypy、pytest 等）
- Pre-commit hooks

## 步骤 4：验证设置

运行以下命令验证一切正常：

```bash
# 格式化代码
uv run poe format

# 运行 linters
uv run poe lint

# 运行测试
uv run poe test

# 运行 smoke test
uv run poe smoke
```

所有命令都应成功完成。

## 步骤 5：进行第一次提交

```bash
# 创建 feature 分支
git checkout -b feature/initial-setup

# 做一些修改（例如，更新 README）
echo "# My Project" > README.md

# 使用 Conventional Commits 格式提交
git add README.md
git commit -m "docs: update project README"

# 推送到远程
git push origin feature/initial-setup
```

pre-commit hooks 会自动：
- 使用 Ruff 格式化你的代码
- 运行 linters（Ruff + mypy）
- 验证你的提交信息格式

## 步骤 6：创建你的第一个 PR

1. 在 GitHub 上访问你的仓库
2. 点击 "Compare & pull request"
3. 填写 PR 模板
4. 等待 PR Gate workflow 通过
5. 合并 PR

## 下一步

- [配置 GitHub 设置](github-setup.zh.md)
- [学习开发流程](development-workflow.zh.md)
- [探索功能特性](features.zh.md)

## 故障排除

### Pre-commit not found

如果看到 `pre-commit not found` 错误：

```bash
uv sync --all-extras
pre-commit install --hook-type pre-commit --hook-type commit-msg
```

### Python 版本不匹配

确保你使用的是 Python 3.10+：

```bash
python --version
# 或
python3 --version
```

如需要，更新 `.python-version`：

```bash
echo "3.10" > .python-version
```

### UV 命令未找到

确保 UV 在你的 PATH 中：

```bash
# 添加到 ~/.bashrc 或 ~/.zshrc
export PATH="$HOME/.cargo/bin:$PATH"

# 重新加载 shell
source ~/.bashrc  # 或 source ~/.zshrc
```

## 常见问题

### 问题："Branch 'main' not found"

**解决方案：** init 脚本期望有一个 `main` 分支来重命名为 `master`。如果没有，先创建它：

```bash
git checkout -b main
git push origin main
uv run poe init -y
```

### 问题：推送时 "Permission denied"

**解决方案：** 确保你有仓库的写权限，并且 Git 凭据已配置：

```bash
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
```

### 问题：Pre-commit hooks 失败

**解决方案：** 手动运行检查以查看详细错误：

```bash
uv run poe format
uv run poe lint
```

修复问题后再次尝试提交。

## 获取帮助

- 查看[文档](.)
- 提交 [Issue](https://github.com/jarlor/uv-python-repo-template/issues)
- 发起 [Discussion](https://github.com/jarlor/uv-python-repo-template/discussions)

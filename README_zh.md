# UV Python 项目模板

[![Built with UV](https://img.shields.io/badge/built%20with-uv-7966C7)](https://github.com/astral-sh/uv)
[![Conventional Commits](https://img.shields.io/badge/Conventional%20Commits-1.0.0-%23FE5196)](https://www.conventionalcommits.org)
[![Python 3.10+](https://img.shields.io/badge/python-3.10+-blue.svg)](https://www.python.org/downloads/)

[English](README.md) | [文档](docs/)

> 生产就绪的 Python 项目模板，包含自动化 CI/CD 工作流、语义化版本控制和完善的质量门禁。

## ✨ 开箱即用

- **⚡ 极速启动** - 使用 UV 在 2 分钟内完成初始化
- **🤖 自动版本管理** - 基于 Conventional Commits 的语义化版本控制
- **🔒 质量门禁** - Pre-commit hooks + PR 门禁（lint、test、类型检查）
- **🚀 CI/CD 就绪** - GitHub Actions 工作流支持 dev/prod 部署
- **📦 分支自动同步** - Master 改动自动同步到 dev
- **📝 PR 模板** - 结构化的 PR 描述和检查清单
- **🏷️ 发版自动化** - 自动生成 changelog 和 GitHub Release

## 🚀 快速开始

### 1. 使用此模板

在 GitHub 点击 "Use this template" 或：

```bash
git clone https://github.com/jarlor/uv-python-repo-template.git my-project
cd my-project
```

### 2. 安装 UV

**macOS/Linux:**
```bash
curl -LsSf https://astral.sh/uv/install.sh | sh
```

**macOS (Homebrew):**
```bash
brew install uv
```

**Windows:** 参考 [UV 安装指南](https://docs.astral.sh/uv/installation)

### 3. 初始化项目

```bash
uv run poe init -y
```

这将会：
- 将项目重命名为你的目录名
- 设置 `dev` 和 `master` 分支
- 安装 pre-commit hooks
- 显示初始化后的检查清单

### 4. 开始开发

```bash
# 创建 feature 分支
git checkout -b feature/my-feature

# 修改代码并提交
git add .
git commit -m "feat: 添加新功能"

# 推送并创建 PR
git push origin feature/my-feature
```

## 📚 文档

| 文档 | 说明 |
|------|------|
| [快速开始](docs/getting-started.zh.md) | 详细的设置和初始化指南 |
| [GitHub 设置](docs/github-setup.zh.md) | 配置分支保护、Secrets 和 Actions |
| [开发流程](docs/development-workflow.zh.md) | 标准开发流程和最佳实践 |
| [功能特性](docs/features.zh.md) | 深入的功能说明 |

## 🎯 核心功能

### 自动化工作流

- **PR Gate** - 每个 PR 到 `dev`/`master` 时运行
  - 代码格式化（Ruff）
  - 代码检查（Ruff + mypy）
  - 单元测试（pytest）
  - 冒烟测试

- **Dev Deploy** - 合并到 `dev` 时触发
  - 自动部署到 dev 环境
  - 健康检查
  - 回滚支持

- **Prod Deploy** - 推送 tag 时触发
  - 构建不可变制品
  - 部署到生产环境
  - 创建 GitHub Release
  - 自动同步到 dev 分支

### 分支策略

```
feature/* → dev → master
              ↓      ↓
           dev 环境  生产环境
```

- `dev` - 集成分支（自动部署到 dev 环境）
- `master` - 生产分支（打 tag 时部署）
- 禁止直接推送到 `dev`/`master`（仅允许 PR）

### 提交规范

遵循 [Conventional Commits](https://www.conventionalcommits.org)：

```
<类型>(<范围>): <主题>
```

**版本影响：**
- `feat:` → 次版本号升级（v1.2.3 → v1.3.0）
- `fix:` → 补丁版本号升级（v1.2.3 → v1.2.4）
- `feat!:` 或 `BREAKING CHANGE:` → 主版本号升级（v1.2.3 → v2.0.0）

### 发版流程

```bash
# 在 master 分支
uv run poe tag

# 推送 tags
git push origin master --tags
```

这将自动：
1. 根据提交历史计算下一个版本
2. 更新 `CHANGELOG.md`
3. 创建 git tag
4. 触发生产环境部署
5. 创建 GitHub Release
6. 将改动同步回 dev

## 🛠️ 可用命令

```bash
# 开发
uv run poe format          # 使用 Ruff 格式化代码
uv run poe lint            # 运行 linters（Ruff + mypy）
uv run poe test            # 使用 pytest 运行测试
uv run poe smoke           # 运行冒烟测试

# 发版
uv run poe tag             # 创建版本 tag 并更新 changelog

# 设置
uv run poe init -y         # 初始化项目（首次设置）
```

## 📋 环境要求

- Python 3.10+
- UV 0.5.0+
- Git

## 🤝 贡献

这是一个模板仓库。欢迎 fork 并根据你的需求自定义。

## 📄 许可证

MIT License - 详见 [LICENSE](LICENSE)

## 🙏 致谢

灵感来源于 [python-repo-template](https://github.com/GiovanniGiacometti/python-repo-template)。

## 📞 支持

- [文档](docs/)
- [Issues](https://github.com/jarlor/uv-python-repo-template/issues)
- [Discussions](https://github.com/jarlor/uv-python-repo-template/discussions)

---

**使用 [UV](https://github.com/astral-sh/uv) 构建，用 ❤️ 制作**

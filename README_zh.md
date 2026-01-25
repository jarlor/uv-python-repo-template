# UV Python Repository Template

[![Built with UV](https://img.shields.io/badge/built%20with-uv-7966C7)](https://github.com/astral-sh/uv)
[![Conventional Commits](https://img.shields.io/badge/Conventional%20Commits-1.0.0-%23FE5196)](https://www.conventionalcommits.org)
[![Base Template](https://img.shields.io/badge/-base_template-blue?logo=github)](https://github.com/GiovanniGiacometti/python-repo-template)

[English Document](README.md)
> 基于 UV 的 Python 项目模板，全自动化的 CI/CD 工作流，让开发者专注于代码本身

## 🚀 核心特性

- ⚡ **极速依赖管理** - 基于 UV 的下一代包管理工具链
- 🤖 **全自动版本管理** - 基于 Conventional Commits 的语义化版本控制
- 🔒 **强质量门禁** - 每次提交自动触发：
  - ✅ 代码格式化（Black）
  - ✅ Lint 检查（Flake8）
  - ✅ 单元测试（Pytest）
- 🛠️ **智能工作流管理** - 可视化 GitHub Actions 工作流控制

## 🛠️ 环境准备

### 前置要求

1. 安装 UV：

- MacOS：
  ```bash
  brew install uv
  ```
- Linux（Debian / Ubuntu / WSL）：
  ```bash
  curl -LsSf https://astral.sh/uv/install.sh | sh
  ```

> 💡 验证安装可以运行`uv --version` 应返回 0.5.x
> 或更高版本。详细安装指南可以参考 [UV 官方文档](https://docs.astral.sh/uv/installation)。

2. 系统支持：

- ✅ Linux
- ✅ macOS
- ⚠️ Windows（[WSL 可用](https://docs.astral.sh/uv/faq/#does-uv-work-on-windows)）

## 🏁 快速开始

### 项目初始化（首次使用）

```bash
uv run poe init -- -y
```

初始化脚本将完成：

1. 项目元数据配置
2. Python 虚拟环境创建（位于 `.venv`）
3. Git Hook 安装：
   - `pre-commit`: 提交前格式化和检查代码
   - `commit-msg`: 验证提交信息格式
   - `pre-push`: 阻止直接推送到 `dev` 分支（要求使用 PR 流程）

注意：init 会做分支/工作流初始化，需要加 `-y` 才会继续执行。

## ✍️ 提交规范

### 提交格式说明

```bash
<类型>([作用域]): <主题>
```

#### 类型对照表

| 类型                    | 版本影响      | 示例场景                   |
|-----------------------|-----------|------------------------|
| `feat`                | **次版本** ↑ | 新增用户认证模块               |
| `fix`                 | **补丁** ↑  | 修复支付接口超时问题             |
| `BREAKING CHANGE`     | **主版本** ↑ | 移除旧版 API（需加 `!` 或正文说明） |
| `docs`/`style`/`test` | 无影响       | 文档更新、代码格式化、测试用例添加      |

### 提交示例

- `feat: 添加用户注册接口` ➔ 触发**次版本号**升级（`v1.2.3` → `v1.3.0`）
- `fix: 修复密码验证逻辑` ➔ 触发**补丁号**升级（`v1.2.3` → `v1.2.4`）
- `feat!: 移除旧版API` ➔ 触发**主版本号**升级（`v1.2.3` → `v2.0.0`）
- `docs: 更新API文档格式` ➔ 无版本变更
- `style: 代码格式化` ➔ 无版本变更
- `test: 添加单元测试` ➔ 无版本变更

> 💡 通过提交信息中的 `!` 或正文包含 `BREAKING CHANGE:` 显式声明破坏性变更

## 🏷️ 版本标签管理

生成语义化版本标签：

```bash
uv run poe tag
```

该命令自动完成：

1. 版本号计算（基于提交历史）
2. CHANGELOG 生成
3. 标签提交

## 🔄 代码推送

常规推送即可，参考命令如下：

```bash
git push origin main # 推送主分支
git push --tags # 推送标签
```

> 💡 如果本地产生标签，确保推送标签到远程仓库才能触发 GitHub Actions 工作流

## 🤖 GitHub Actions

工作流位于 `.github/workflows`，默认启用。需要调整时，可修改触发条件或重命名文件禁用。

### 致谢

感谢[python-repo-template
](https://github.com/GiovanniGiacometti/python-repo-template)提供的基础模板及灵感。

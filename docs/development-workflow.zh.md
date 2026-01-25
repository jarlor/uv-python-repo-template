# 开发流程

本指南描述使用此模板的项目的标准开发流程。

## 分支策略

```
feature/* → dev → master
              ↓      ↓
           dev 环境  生产环境
```

### 分支角色

| 分支 | 用途 | 自动部署 | 受保护 |
|------|------|---------|--------|
| `master` | 生产代码 | 推送 tag 时 | ✅ 是 |
| `dev` | 集成/预发布 | 合并时 | ✅ 是 |
| `feature/*` | 新功能 | 否 | ❌ 否 |
| `fix/*` | Bug 修复 | 否 | ❌ 否 |
| `hotfix/*` | 紧急修复 | 否 | ❌ 否 |

### 分支命名

- `feature/add-user-auth` - 新功能
- `fix/login-timeout` - Bug 修复
- `hotfix/critical-security-patch` - 紧急修复
- `docs/update-readme` - 文档更改
- `refactor/cleanup-utils` - 代码重构
- `test/add-integration-tests` - 测试添加

## 标准开发流程

### 1. 开始新工作

```bash
# 确保 dev 是最新的
git checkout dev
git pull origin dev

# 创建 feature 分支
git checkout -b feature/my-feature
```

### 2. 开发和提交

```bash
# 做出更改
vim src/my_module.py

# 本地运行检查
uv run poe format  # 格式化代码
uv run poe lint    # 运行 linters
uv run poe test    # 运行测试

# 使用 Conventional Commits 提交
git add src/my_module.py
git commit -m "feat: add user authentication"
```

**提交消息格式：**

```
<类型>(<范围>): <主题>

[可选正文]

[可选页脚]
```

**类型：**
- `feat`: 新功能
- `fix`: Bug 修复
- `docs`: 文档更改
- `style`: 代码样式更改（格式化等）
- `refactor`: 代码重构
- `perf`: 性能改进
- `test`: 添加或更新测试
- `build`: 构建系统更改
- `ci`: CI/CD 更改
- `chore`: 其他更改（依赖等）

**示例：**

```bash
# 简单功能
git commit -m "feat: add user login endpoint"

# 带范围的 Bug 修复
git commit -m "fix(auth): resolve token expiration issue"

# 破坏性更改
git commit -m "feat!: remove deprecated API endpoints"

# 带正文
git commit -m "feat: add email notifications

实现以下的电子邮件通知：
- 用户注册
- 密码重置
- 账户更新

Closes #123"
```

### 3. 推送并创建 PR

```bash
# 推送 feature 分支
git push origin feature/my-feature

# 在 GitHub 上创建 PR
# 使用提供的链接或访问 GitHub UI
```

### 4. 填写 PR 模板

PR 模板会自动填充。填写所有部分：

```markdown
# 变更目的
- 添加用户认证系统

# 影响范围
- 前端页面/路由：/login, /register
- 后端接口（路径/方法）：POST /api/auth/login, POST /api/auth/register
- DB 迁移：是（添加 users 表）

# 测试证据（必须可复现）
- 测试命令/步骤：
  1. uv run poe test
  2. 手动测试：curl -X POST http://localhost:8000/api/auth/login
- 结果/截图/日志链接：
  - 所有测试通过
  - 截图：[链接]

# 风险点
- 需要数据库迁移
- 现有用户需要重新注册

# 回滚方案（必填）
- 回滚目标 commit/image tag：abc123
- 回滚入口/脚本：git revert abc123
- 回滚后验证点：登录页面返回旧版本

# 跨仓库依赖
- 需要配合的仓库与事项：前端仓库需要更新登录表单

# 提交前自检
- [x] PR 标题符合 Conventional Commits
- [x] 已说明风险与回滚
- [x] 证据完整且可复现
- [x] 遵守 `dev`/`master` 仅 PR 合并规则
```

### 5. 等待 PR Gate

PR Gate workflow 会自动运行：

1. **格式检查** - Ruff format
2. **Lint 检查** - Ruff + mypy
3. **测试** - pytest
4. **Smoke 测试** - 基本功能检查

**所有检查必须通过才能合并。**

### 6. 处理审查意见

```bash
# 做出请求的更改
vim src/my_module.py

# 提交更改
git add src/my_module.py
git commit -m "fix: address review comments"

# 推送更新
git push origin feature/my-feature
```

PR Gate 会自动再次运行。

### 7. 合并 PR

一旦批准且所有检查通过：

1. 在 GitHub 上点击 "Squash and merge"
2. 确认提交消息遵循 Conventional Commits
3. 删除 feature 分支（如果配置了会自动删除）

**结果：** 更改现在在 `dev` 中并自动部署到 dev 环境。

## 发版流程

### 何时发版

- 每周发版（推荐）
- 重要功能后
- 关键 bug 修复

### 发版步骤

#### 1. 创建 Release PR (dev → master)

```bash
# 确保 dev 是最新的
git checkout dev
git pull origin dev

# 在 GitHub 上创建 PR: dev → master
```

填写 PR 模板，包括：
- 自上次发版以来的更改摘要
- 破坏性更改（如有）
- 迁移步骤（如有）

#### 2. 等待 PR Gate

与 feature PR 相同的检查。

#### 3. 合并到 Master

一旦批准：
1. Squash and merge
2. Master 现在有最新代码

#### 4. 创建版本 Tag

```bash
# 在 master 分支
git checkout master
git pull origin master

# 创建 tag（自动计算版本）
uv run poe tag

# 推送 tag
git push origin master --tags
```

**会发生什么：**
1. `semantic-release` 根据提交计算下一个版本
2. 更新 `CHANGELOG.md`
3. 更新 `pyproject.toml` 中的版本
4. 创建 git tag（例如，`v1.4.0`）
5. 提交更改

#### 5. 自动部署

推送 tag 会触发：

1. **Prod Deploy Workflow**
   - 构建生产制品
   - 部署到生产环境
   - 监控健康状况

2. **Release Workflow**
   - 从 CHANGELOG 提取发版说明
   - 创建 GitHub Release

3. **Sync Workflow**
   - 自动将 master 更改同步回 dev

## Hotfix 流程

对于无法等待正常发版周期的关键生产问题。

### 1. 创建 Hotfix 分支

```bash
# 从 master（生产代码）
git checkout master
git pull origin master

# 创建 hotfix 分支
git checkout -b hotfix/critical-security-patch
```

### 2. 修复和测试

```bash
# 做出最小更改
vim src/security.py

# 彻底测试
uv run poe test

# 提交
git commit -m "fix: patch critical security vulnerability"
```

### 3. 创建 PR 到 Master

```bash
# 推送 hotfix
git push origin hotfix/critical-security-patch

# 创建 PR: hotfix/* → master
```

**重要：** Hotfixes 直接进入 master，绕过 dev。

### 4. 部署 Hotfix

```bash
# PR 合并后
git checkout master
git pull origin master

# 创建 hotfix tag
uv run poe tag

# 推送 tag（触发部署）
git push origin master --tags
```

### 5. 回灌到 Dev

```bash
# 将 master 合并回 dev
git checkout dev
git merge master
git push origin dev
```

或等待自动同步 workflow 处理。

## 常见场景

### 场景 1：并行的多个功能

```bash
# 开发者 A
git checkout -b feature/user-auth

# 开发者 B
git checkout -b feature/payment-integration

# 两者独立工作
# 两者都创建 PR 到 dev
# 两者都合并到 dev
# 两者都部署到 dev 环境
```

### 场景 2：功能依赖另一个

```bash
# 等待第一个功能合并到 dev
# 然后从 dev 创建你的 feature 分支

git checkout dev
git pull origin dev
git checkout -b feature/depends-on-auth
```

### 场景 3：长期运行的功能

```bash
# 保持 feature 分支与 dev 同步
git checkout feature/long-running
git merge dev
git push origin feature/long-running

# 或 rebase（如果没有其他人在该分支上工作）
git rebase dev
git push origin feature/long-running --force-with-lease
```

### 场景 4：回滚生产

```bash
# 找到最后一个好的 tag
git tag -l

# 回退到之前的版本
git checkout master
git revert <bad-commit-sha>
git push origin master

# 或部署之前的 tag
# （取决于你的部署系统）
```

## 最佳实践

### 提交

- ✅ 做出小而专注的提交
- ✅ 编写清晰的提交消息
- ✅ 遵循 Conventional Commits 格式
- ✅ 提交可工作的代码（测试通过）
- ❌ 不要提交注释掉的代码
- ❌ 不要提交调试语句
- ❌ 不要提交 secrets 或凭据

### Pull Requests

- ✅ 保持 PR 小（< 400 行更改）
- ✅ 完整填写 PR 模板
- ✅ 为 UI 更改添加截图
- ✅ 链接相关 issues
- ✅ 向相关人员请求审查
- ❌ 不要合并自己的 PR（除非单人项目）
- ❌ 不要在审查开始后强制推送

### 分支

- ✅ 合并后删除分支
- ✅ 保持 feature 分支短期（< 1 周）
- ✅ 定期与 dev 同步
- ❌ 不要直接推送到 dev/master
- ❌ 不要 rebase 共享分支

### 测试

- ✅ 推送前在本地运行测试
- ✅ 为新功能添加测试
- ✅ 为 bug 修复更新测试
- ✅ 测试边界情况
- ❌ 不要跳过测试
- ❌ 不要提交失败的测试

## 故障排除

### 问题：Pre-commit hooks 失败

```bash
# 手动运行检查
uv run poe format
uv run poe lint

# 修复问题并重试
git commit -m "feat: my feature"
```

### 问题：合并冲突

```bash
# 用最新的 dev 更新你的分支
git checkout feature/my-feature
git fetch origin
git merge origin/dev

# 解决冲突
vim conflicted-file.py

# 标记为已解决
git add conflicted-file.py
git commit -m "merge: resolve conflicts with dev"
```

### 问题：错误的提交消息

```bash
# 修改最后一次提交（如果未推送）
git commit --amend -m "feat: correct message"

# 如果已推送，创建新提交
git commit --allow-empty -m "docs: fix previous commit message"
```

### 问题：意外提交到 dev

```bash
# 从当前状态创建新分支
git branch feature/accidental-commit

# 将 dev 重置到 origin
git checkout dev
git reset --hard origin/dev

# 继续在 feature 分支上工作
git checkout feature/accidental-commit
```

## 下一步

- [探索功能特性](features.zh.md)
- [GitHub 设置指南](github-setup.zh.md)
- [自定义 Workflows](.github/workflows/)

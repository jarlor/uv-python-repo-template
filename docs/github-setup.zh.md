# GitHub 仓库设置

本指南介绍运行 `uv run poe init -y` 后需要的 GitHub 特定配置。

## 概述

初始化项目后，你需要配置 GitHub 仓库设置以启用：

- 分支保护规则（仅 master）
- 必需的状态检查
- GitHub Actions 权限
- 部署所需的 Secrets（如需要）

## 分支保护策略

本模板使用**混合保护方式**：

### Master 分支：硬保护（GitHub）
- ✅ **在 GitHub 上强制执行** - 无法绕过
- ✅ 合并前需要 PR
- ✅ 需要状态检查通过
- ✅ 阻止任何人直接推送

### Dev 分支：软保护（本地）
- ✅ **通过 pre-push hook 在本地强制执行**
- ✅ 阻止开发者直接推送
- ✅ 允许从 master 自动同步
- ❌ **无 GitHub 保护** - 保持工作流简单

**为什么采用这种方式？**

1. **Master 保护至关重要** - 生产代码必须经过审查
2. **Dev 保护更灵活** - 允许 master → dev 自动同步，无需复杂的 GitHub App 配置
3. **开发者体验** - 本地 hook 提供即时反馈
4. **紧急绕过** - 开发者可以使用 `--no-verify` 绕过（如需要）

## 1. 分支保护规则

### 对于 `master` 分支（必需）

**分支名称模式：** `master`

**要启用的设置：**

- ✅ **合并前需要 pull request**
  - ✅ 需要审批数：1（团队项目推荐）
  - ✅ 推送新提交时取消过时的 pull request 审批
  - ✅ 需要 Code Owners 审查（可选）

- ✅ **合并前需要状态检查通过**
  - ✅ 合并前需要分支是最新的
  - **必需的状态检查：**
    - `pr-gate`（来自 PR Gate workflow）

- ✅ **合并前需要解决对话**

- ✅ **需要线性历史**（可选，强制 squash merge）

- ✅ **不允许绕过上述设置**

- ❌ **允许强制推送**（保持禁用）

- ❌ **允许删除**（保持禁用）

**额外设置：**

- ✅ **限制谁可以推送到匹配的分支**
  - 添加可以推送的特定用户/团队（可选）

### 对于 `dev` 分支（不需要）

**⚠️ 不要在 GitHub 上为 `dev` 分支设置保护规则。**

`dev` 分支通过本地 pre-push hook 保护：
- 由 `uv run poe init -y` 自动安装
- 阻止直接推送到 `dev` 分支
- 要求使用 feature 分支 → PR 工作流
- 允许从 master 自动同步

**如果你不小心设置了 dev 保护：**
1. 访问 **Settings** → **Branches**
2. 找到 `dev` 分支保护规则
3. 点击 **Delete** 删除它

## 2. GitHub Actions 权限

确保 GitHub Actions 具有必要的权限。

### 步骤

1. 访问 **Settings** → **Actions** → **General**
2. 在 **Workflow permissions** 下，选择：
   - ✅ **读写权限**
   - ✅ **允许 GitHub Actions 创建和批准 pull requests**

**原因：** workflows 需要写权限来：
- 创建 releases
- 推送到分支（用于自动同步）
- 更新 tags

## 3. 必需的 Secrets（可选）

如果你要部署到云提供商或远程服务器，请配置这些 secrets。

### 步骤

1. 访问 **Settings** → **Secrets and variables** → **Actions**
2. 点击 **New repository secret**

### 常见部署 Secrets

| Secret 名称 | 说明 | 示例 |
|-------------|------|------|
| `DOCKER_REGISTRY_URL` | Docker registry URL | `docker.io`、`ghcr.io` |
| `DOCKER_USERNAME` | Docker registry 用户名 | `myusername` |
| `DOCKER_PASSWORD` | Docker registry 密码/token | `ghp_xxxxx` |
| `SSH_PRIVATE_KEY` | 用于部署的 SSH 私钥 | `-----BEGIN RSA PRIVATE KEY-----...` |
| `DEPLOY_HOST` | 部署服务器主机名 | `deploy.example.com` |
| `DEPLOY_USER` | 部署用的 SSH 用户 | `deploy` |
| `DEPLOY_PATH` | 部署目录路径 | `/var/www/myapp` |

### 云提供商 Secrets

**AWS:**
- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`
- `AWS_REGION`

**Google Cloud:**
- `GCP_PROJECT_ID`
- `GCP_SERVICE_ACCOUNT_KEY`

**Azure:**
- `AZURE_CREDENTIALS`
- `AZURE_SUBSCRIPTION_ID`

### 其他常见 Secrets

| Secret 名称 | 说明 | 何时需要 |
|-------------|------|----------|
| `SLACK_WEBHOOK_URL` | Slack 通知 | 如果使用 Slack 集成 |
| `SENTRY_DSN` | Sentry 错误追踪 | 如果使用 Sentry |
| `CODECOV_TOKEN` | 代码覆盖率报告 | 如果使用 Codecov |

## 4. 默认分支

将默认分支设置为 `master`。

### 步骤

1. 访问 **Settings** → **General**
2. 在 **Default branch** 下，点击切换图标
3. 选择 `master`
4. 点击 **Update**

**原因：** 这确保：
- 新 PR 默认指向 `master`
- 克隆操作检出 `master`
- GitHub UI 显示 `master` 为主分支

## 5. 仓库设置

### 通用设置

**Settings** → **General**

- ✅ **允许 squash merging**（推荐）
- ❌ **允许 merge commits**（可选）
- ❌ **允许 rebase merging**（可选）

**默认提交消息：**
- 选择：**Pull request title**

**原因：** Squash merge 保持历史清晰，与 Conventional Commits 配合良好。

### Pull Requests

**Settings** → **General** → **Pull Requests**

- ✅ **始终建议更新 pull request 分支**
- ✅ **自动删除 head 分支**

## 6. 协作者和团队

添加具有适当权限的协作者或团队。

### 步骤

1. 访问 **Settings** → **Collaborators and teams**
2. 点击 **Add people** 或 **Add teams**

### 推荐权限

| 角色 | 权限 | 谁 |
|------|------|-----|
| **Admin** | 完全访问 | 仓库所有者 |
| **Maintain** | 管理但无破坏性操作 | 主要开发者 |
| **Write** | 推送到非保护分支 | 开发者 |
| **Read** | 查看和克隆 | 外部贡献者 |

## 7. Webhooks（可选）

为外部集成设置 webhooks。

### 常见集成

- **Slack:** PR 事件、部署通知
- **Discord:** 类似 Slack
- **Jira:** 将 commits/PRs 链接到 issues
- **Sentry:** 追踪 releases

### 步骤

1. 访问 **Settings** → **Webhooks**
2. 点击 **Add webhook**
3. 输入 payload URL 并选择事件

## 8. GitHub Pages（可选）

如果你想托管文档：

### 步骤

1. 访问 **Settings** → **Pages**
2. 在 **Source** 下，选择：
   - Branch: `master` 或 `gh-pages`
   - Folder: `/docs` 或 `/`（根目录）
3. 点击 **Save**

## 9. 安全设置

### Dependabot

启用 Dependabot 以保持依赖最新。

**Settings** → **Security** → **Code security and analysis**

- ✅ **Dependabot alerts**
- ✅ **Dependabot security updates**
- ✅ **Dependabot version updates**

创建 `.github/dependabot.yml`：

```yaml
version: 2
updates:
  - package-ecosystem: "pip"
    directory: "/"
    schedule:
      interval: "weekly"
    open-pull-requests-limit: 10
```

### 代码扫描

启用代码扫描以发现安全漏洞。

**Settings** → **Security** → **Code security and analysis**

- ✅ **Code scanning**
- 选择：**CodeQL analysis**

## 10. 验证设置

完成设置后，验证一切正常：

### 测试分支保护

1. 尝试直接推送到 `dev`：
   ```bash
   git checkout dev
   echo "test" >> README.md
   git add README.md
   git commit -m "test: direct push"
   git push origin dev
   ```
   **预期：** 推送应被拒绝

2. 改为创建 PR：
   ```bash
   git checkout -b test/branch-protection
   git push origin test/branch-protection
   ```
   在 GitHub 上创建 PR → 应该可以

### 测试 PR Gate

1. 创建一个测试失败的 PR
2. 验证 PR Gate workflow 运行
3. 验证在检查通过前合并被阻止

### 测试自动同步

1. 合并 PR 到 `master`
2. 检查 GitHub Actions
3. 验证 `dev` 分支自动更新

## 检查清单

使用此检查清单确保一切已配置：

- [ ] 为 `dev` 启用分支保护
- [ ] 为 `master` 启用分支保护
- [ ] 配置必需的状态检查
- [ ] GitHub Actions 权限设置为读/写
- [ ] 默认分支设置为 `master`
- [ ] 启用 squash merge
- [ ] 启用自动删除 head 分支
- [ ] 配置 Secrets（如果部署）
- [ ] 添加协作者
- [ ] 启用 Dependabot
- [ ] 验证分支保护有效
- [ ] 验证 PR Gate workflow 有效
- [ ] 验证自动同步有效

## 故障排除

### 问题：PR Gate 未运行

**解决方案：** 检查 GitHub Actions 权限：
- Settings → Actions → General → Workflow permissions
- 确保选择了"读写权限"

### 问题：自动同步失败

**解决方案：** 检查 workflow 日志：
- Actions → Sync master to dev
- 查找权限错误
- 确保 workflow 中设置了 `contents: write` 权限

### 问题：无法推送到受保护分支

**解决方案：** 这是预期的！使用 PR 工作流：
1. 创建 feature 分支
2. 推送到 feature 分支
3. 创建 PR 到 `dev` 或 `master`

### 问题：状态检查未要求

**解决方案：** 
1. 至少运行一次 PR Gate workflow
2. 访问分支保护设置
3. 状态检查现在应该出现在列表中
4. 选择它作为必需

## 下一步

- [学习开发流程](development-workflow.zh.md)
- [探索功能特性](features.zh.md)
- [自定义 Workflows](../.github/workflows/)

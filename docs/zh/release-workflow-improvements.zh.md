# 发布流程改进文档

> 使用 semantic-release 实现自动 CHANGELOG 生成和简化发布流程的改进文档

## 概述

本文档描述了对发布流程的改进，通过利用 `python-semantic-release` 实现自动 CHANGELOG 生成和简化的发布流程。

## 问题陈述

### 之前存在的问题

1. **空的 CHANGELOG 条目**：`semantic-release changelog` 命令不生成内容，因为它只对已存在的 tags 有效
2. **手动更新 CHANGELOG**：需要手动编辑或导致空的版本条目
3. **复杂的本地工作流**：`tag.sh` 脚本在本地修改多个文件，增加出错可能性
4. **Pre-commit hook 失败**：`pyproject.toml` 和 `uv.lock` 之间的版本不匹配导致提交失败
5. **流程不一致**：版本管理在本地脚本和 CI 之间分散

### 根本原因

1. **缺少配置**：`pyproject.toml` 缺少 `[semantic_release.changelog]` 配置
2. **错误的命令使用**：使用 `semantic-release changelog` 而不是 `semantic-release version`
3. **时机问题**：在 tags 存在之前尝试生成 changelog
4. **锁文件同步**：`uv.lock` 在 git 操作前未更新

## 解决方案架构

### 设计原则

1. **关注点分离**：本地测试 vs. CI 自动化
2. **单一数据源**：所有版本操作在 CI 中进行
3. **利用 Conventional Commits**：从提交消息自动生成 CHANGELOG
4. **快速失败**：本地验证，CI 执行

### 新工作流

```
开发者本地                      GitHub Actions CI
─────────────────              ─────────────────
                                   
1. 运行测试                       
   uv run poe tag                  
   ↓                               
   ✓ lint/test/smoke               
   ✓ 计算下一个版本                
   ✓ 显示操作指引                  
                                   
2. 创建 release 分支              
   git checkout -b release/v1.7.0  
   git push origin release/v1.7.0  
                                   
3. 创建 PR                        
   gh pr create                    
   ↓                               
                                   4. PR 合并到 master
                                      ↓
                                   5. semantic-release version
                                      - 计算版本
                                      - 更新 pyproject.toml
                                      - 生成 CHANGELOG.md
                                      - 更新 uv.lock
                                      - 创建 commit
                                      - 创建 tag
                                      - 推送到远程
                                      ↓
                                   6. 创建 GitHub Release
                                      ↓
                                   7. 同步 master → dev
```

## 实现细节

### 1. 配置变更

**文件**: `pyproject.toml`

```toml
[semantic_release]
assets = ["pyproject.toml", "uv.lock"]

[semantic_release.changelog]
changelog_file = "CHANGELOG.md"  # 启用 CHANGELOG 生成
exclude_commit_patterns = []

[semantic_release.changelog.environment]
block_start_string = "{%"
block_end_string = "%}"
variable_start_string = "{{"
variable_end_string = "}}"

[semantic_release.branches.main]
match = "master"
prerelease = false

[semantic_release.branches.dev]
match = "dev"
prerelease = false

[semantic_release.branches.release]
match = "release/.+"
prerelease = false

[semantic_release.remote]
ignore_token_for_push = true
```

**关键变更**:
- 添加 `[semantic_release.changelog]` 部分以启用 CHANGELOG 生成
- 配置 `changelog_file = "CHANGELOG.md"`（之前为空/缺失）
- 添加 Jinja2 渲染的模板环境配置

### 2. 简化本地脚本

**文件**: `scripts/tag.sh`

**之前**:
```bash
# 复杂的工作流，包含文件修改
semantic-release changelog  # 不起作用
update-toml update --path project.version --value "$NEXT_VERSION"
semantic-release version --no-commit  # 破坏 pyproject.toml
git add pyproject.toml CHANGELOG.md uv.lock
git commit -m "chore: release v$NEXT_VERSION"
```

**之后**:
```bash
# 简单的验证工作流
uv run poe lint
uv run poe test
uv run poe smoke
NEXT_VERSION=$(uv run semantic-release version --print)
# 显示指引，不修改文件
```

**优势**:
- ✅ 本地不修改文件
- ✅ 执行更快（无 git 操作）
- ✅ 更清晰的分离：本地验证，CI 执行
- ✅ 减少出错可能性

### 3. 增强的 CI 工作流

**文件**: `.github/workflows/release-on-pr.yaml`

**之前**:
```yaml
- name: Extract version from pyproject.toml
  run: VERSION=$(grep '^version = ' pyproject.toml | cut -d'"' -f2)

- name: Create and push tag
  run: |
    git tag -a "$TAG" -m "Release $VERSION"
    git push origin "$TAG"

- name: Extract Release Notes
  run: bash scripts/extract_release_notes.sh > release_notes.md
```

**之后**:
```yaml
- name: Run semantic-release
  run: |
    uv run semantic-release version --no-vcs-release
    VERSION=$(git describe --tags --abbrev=0 | sed 's/^v//')

- name: Extract Release Notes
  run: bash scripts/extract_release_notes.sh > release_notes.md

- name: Create GitHub Release
  uses: softprops/action-gh-release@v2
```

**优势**:
- ✅ 自动版本计算
- ✅ 自动生成包含详细提交历史的 CHANGELOG
- ✅ 自动更新文件（pyproject.toml, CHANGELOG.md, uv.lock）
- ✅ 单个命令处理整个发布准备

## CHANGELOG 格式

### 之前（手动）

```markdown
## v1.7.0 (2026-01-26)


## v1.6.0 (2026-01-25)
```

空条目需要手动填写。

### 之后（自动）

```markdown
## v1.7.0 (2026-01-26)

### Features

- merge GitHub Release creation into release-on-pr workflow (#29)
- add semantic-release support for release/* branches (#27)
- implement manual release with auto-tag on PR merge (#26)

### Bug Fixes

- include uv.lock in release commits to prevent pre-commit hook failure (#28)
- make semantic-release branch behavior explicit (#21)

### BREAKING CHANGES

- None
```

从 conventional commits 自动生成详细的、分类的条目。

## 优势

### 对开发者

1. **更简单的本地工作流**
   - 运行 `uv run poe tag` 进行验证
   - 创建分支和 PR
   - 无需手动编辑文件

2. **更好的可见性**
   - 详细的 CHANGELOG 准确显示变更内容
   - 自动分类（feat/fix/breaking）
   - 链接到 PRs 和 commits

3. **减少错误**
   - 无需手动更新版本
   - 无需手动编辑 CHANGELOG
   - 本地无 git 操作错误

### 对项目

1. **专业的文档**
   - 一致的 CHANGELOG 格式
   - 完整的发布历史
   - 易于理解的变更

2. **自动化**
   - 从 commits 计算版本
   - 从 commits 生成 CHANGELOG
   - 创建 tag 和 release

3. **合规性**
   - 强制使用 conventional commits
   - 语义化版本控制
   - 完整的审计跟踪

## 迁移指南

### 对于现有的 Release 分支

如果你有使用旧工作流创建的 `release/*` 分支：

1. **丢弃本地更改**（如果有未提交的修改）
2. **在 master 上 rebase** 以获取新工作流
3. **重新运行验证**：`uv run poe tag`
4. **照常推送并创建 PR**

### 对于新发布

只需遵循新工作流：

```bash
# 1. 验证
uv run poe tag

# 2. 创建分支
git checkout -b release/v1.7.0

# 3. 推送并创建 PR
git push origin release/v1.7.0
gh pr create --title "chore: release v1.7.0" --base master

# 4. 合并 PR → CI 处理一切
```

## 故障排除

### 问题："No new version to release"

**原因**：自上次发布以来没有 feat/fix commits

**解决方案**：
- 检查提交历史：`git log v1.6.0..HEAD --oneline`
- 确保 commits 遵循 conventional 格式
- 或使用手动版本：`uv run poe tag --version 1.7.0`

### 问题：CHANGELOG 未生成

**原因**：缺少 `[semantic_release.changelog]` 配置

**解决方案**：验证 `pyproject.toml` 包含：
```toml
[semantic_release.changelog]
changelog_file = "CHANGELOG.md"
```

### 问题：Pre-commit hook 失败

**原因**：版本不匹配或文件修改

**解决方案**：
- 确保本地不修改文件
- 让 CI 处理所有文件更新
- 如需要，运行 `uv sync` 更新锁文件

## 技术细节

### semantic-release 命令

| 命令 | 用途 | 何时使用 |
|------|------|----------|
| `version --print` | 计算下一个版本 | 本地验证 |
| `version` | 完整发布工作流 | CI 自动化 |
| `version --no-vcs-release` | 不集成 VCS 的发布 | 单独创建 release 时 |
| `changelog` | 重新生成 CHANGELOG | 仅手动更新 |

### 工作流触发器

| 事件 | 工作流 | 操作 |
|------|--------|------|
| PR 到 `dev`/`master` | `pr_gate.yaml` | 运行测试 |
| 合并到 `dev` | `dev_deploy.yaml` | 部署到 dev |
| 合并 `release/*` 到 `master` | `release-on-pr.yaml` | 创建 release |
| Tag push | `prod_deploy.yaml` | 部署到 prod |

## 参考资料

- [python-semantic-release 文档](https://python-semantic-release.readthedocs.io/)
- [Conventional Commits](https://www.conventionalcommits.org/)
- [语义化版本控制](https://semver.org/)

## 更新日志

- **2026-01-26**：工作流改进的初始文档
- **2026-01-26**：添加 semantic-release 集成
- **2026-01-26**：简化本地工作流
- **2026-01-26**：增强 CI 自动化

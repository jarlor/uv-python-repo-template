# Git 工作流

本模板使用两个长期分支：

| 分支 | 职责 | 环境 |
| --- | --- | --- |
| `dev` | 集成事实 | 可选部署测试/预发环境 |
| `main` | 生产事实 | 可选部署生产环境 |

`test` 和 `staging` 是环境，不是 Git 分支。

## 分支规则

| 流向 | Merge 方式 | 说明 |
| --- | --- | --- |
| 短分支 -> `dev` | Squash merge | 功能、修复、文档、维护和重构 |
| `dev` -> `main` | Create merge commit | 保留一批测试通过改动的发布边界 |
| `hotfix/*` -> `main` | Squash merge | 只用于紧急生产修复 |
| `main` -> `dev` | `--no-ff` backmerge | 把生产事实状态同步回集成分支 |

## 标准流程

```text
dev
  -> feature/* 或 fix/*
  -> PR 到 dev
  -> CI + PR governance
  -> Squash merge
  -> 可选测试环境部署

dev 验证通过
  -> PR dev 到 main
  -> CI + PR governance
  -> Create merge commit
  -> semantic-release
  -> 可选生产部署
  -> release 成功后 backmerge main 到 dev；启用生产部署时需等部署成功
```

## Hotfix 流程

```text
main
  -> hotfix/*
  -> PR 到 main
  -> CI + PR governance
  -> Squash merge
  -> semantic-release
  -> 可选生产部署
  -> backmerge main 到 dev
```

Hotfix 合入 `main` 后不要手动 cherry-pick 到 `dev`。优先让 backmerge workflow 把生产修复带回 `dev`。如果 backmerge 冲突，人工解决 `main -> dev` 合并冲突，再 PR 回 `dev`。

## Commit 规则

所有 PR title 必须符合 Conventional Commit：

```text
feat: add dashboard
fix(api): repair auth refresh
docs: update setup guide
chore(ci): align workflows
```

进入 `main` 的 PR title 必须使用会触发发版的类型：

- `feat:`
- `fix:`
- `perf:`

push 到 `dev` 和 `main` 后还会校验 first-parent 上真实落地的 commit。`main` 只接受 `feat:`、`fix:`、`perf:`、`chore(release):` 和 `chore(backmerge):`。

## GitHub Merge 设置

设置仓库默认 merge 行为，确保最终 commit subject 能被 semantic-release 正确识别：

- Squash merge title: PR title
- Squash merge message: PR body
- Create merge commit title: PR title
- Create merge commit message: PR body
- Automatically delete head branches: enabled

# GitHub 设置

## 分支

默认分支使用 `main`，`dev` 作为集成分支。

保护两个分支：

- 要求 PR 合并
- 要求 CI 和 governance checks 通过
- 限制直接 push
- 允许 GitHub Actions 推送 release 和 backmerge commit

## Merge 设置

配置默认 merge 行为，确保最终 commit subject 和 PR title 一致：

- Squash merge title: PR title
- Squash merge message: PR body
- Create merge commit title: PR title
- Create merge commit message: PR body
- Automatically delete head branches: enabled

## Actions 权限

GitHub Actions workflow permissions 设置为 read/write，让 release 和 backmerge workflow 可以推送 tag 和 commit。

## 部署 Variables

部署默认关闭，需要显式启用。

测试/预发：

- Secret: `TEST_SSH_HOST`
- Secret: `TEST_SSH_USER`
- Secret: `TEST_SSH_KEY`
- Variable: `TEST_DEPLOY_ENABLED`
- Variable: `TEST_DEPLOY_PATH`
- Variable: `TEST_SYSTEMD_SERVICE`
- Variable: `TEST_HEALTH_URL`
- Variable: `TEST_REPOSITORY_URL`

生产：

- Secret: `PROD_SSH_HOST`
- Secret: `PROD_SSH_USER`
- Secret: `PROD_SSH_KEY`
- Variable: `PROD_DEPLOY_ENABLED`
- Variable: `PROD_DEPLOY_PATH`
- Variable: `PROD_SYSTEMD_SERVICE`
- Variable: `PROD_HEALTH_URL`
- Variable: `PROD_REPOSITORY_URL`

项目没有测试服务器时，不设置 `TEST_DEPLOY_ENABLED`。只想发 tag 和 GitHub Release、不部署主机时，不设置 `PROD_DEPLOY_ENABLED`。

semantic-release：

- Secret: `RELEASE_TOKEN`
- Variable: `RELEASE_ENABLED`

`RELEASE_TOKEN` 必须被仓库 ruleset 允许向 `main` 推 release commit 和 tag。在 bypass 或权限模型配置好之前，不要设置 `RELEASE_ENABLED`。

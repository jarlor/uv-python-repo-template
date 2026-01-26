# Documentation

This directory contains comprehensive documentation for the UV Python Repository Template.

## Structure

```
docs/
├── en/          # English documentation
│   ├── getting-started.md
│   ├── github-setup.md
│   ├── development-workflow.md
│   ├── features.md
│   └── release-workflow-improvements.md
└── zh/          # Chinese documentation (中文文档)
    ├── getting-started.zh.md
    ├── github-setup.zh.md
    ├── development-workflow.zh.md
    ├── features.zh.md
    └── release-workflow-improvements.zh.md
```

## Quick Links

### English

- [Getting Started](en/getting-started.md) - Initial setup and project initialization
- [GitHub Setup](en/github-setup.md) - Configure branch protection, secrets, and Actions
- [Development Workflow](en/development-workflow.md) - Standard development process and best practices
- [Features](en/features.md) - In-depth feature explanations
- [Release Workflow Improvements](en/release-workflow-improvements.md) - Recent improvements to release process

### 中文

- [快速开始](zh/getting-started.zh.md) - 初始设置和项目初始化
- [GitHub 配置](zh/github-setup.zh.md) - 配置分支保护、密钥和 Actions
- [开发工作流](zh/development-workflow.zh.md) - 标准开发流程和最佳实践
- [功能特性](zh/features.zh.md) - 深入的功能说明
- [发布流程改进](zh/release-workflow-improvements.zh.md) - 发布流程的最新改进

## Recent Updates

### 2026-01-26: Release Workflow Improvements

Major improvements to the release workflow:

- **Automatic CHANGELOG Generation**: Using `python-semantic-release` to generate detailed changelogs from conventional commits
- **Simplified Local Workflow**: `uv run poe tag` now only runs tests, no file modifications
- **Enhanced CI Automation**: All version management happens in GitHub Actions
- **Better Documentation**: Detailed commit history with automatic categorization (feat/fix/breaking)

See [Release Workflow Improvements](en/release-workflow-improvements.md) for details.

### 2026-01-26: Documentation Reorganization

- Organized documentation into language-specific directories (`en/` and `zh/`)
- Added comprehensive release workflow improvement documentation
- Updated README and AGENTS.md with new release process

## Contributing

When adding new documentation:

1. Create both English and Chinese versions
2. Place English docs in `docs/en/`
3. Place Chinese docs in `docs/zh/` with `.zh.md` extension
4. Update this README with links to new documents
5. Follow the existing documentation structure and style

## Feedback

If you find any issues or have suggestions for improving the documentation, please:

- Open an issue on GitHub
- Submit a pull request with improvements
- Contact the maintainers

---

**Last Updated**: 2026-01-26

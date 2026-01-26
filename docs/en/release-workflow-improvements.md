# Release Workflow Improvements

> Documentation of recent improvements to the release workflow using semantic-release

## Overview

This document describes the improvements made to the release workflow to leverage `python-semantic-release` for automatic CHANGELOG generation and streamlined release process.

## Problem Statement

### Previous Issues

1. **Empty CHANGELOG entries**: The `semantic-release changelog` command didn't generate content because it only works with existing tags
2. **Manual CHANGELOG updates**: Required manual editing or resulted in empty version entries
3. **Complex local workflow**: `tag.sh` script modified multiple files locally, increasing error potential
4. **Pre-commit hook failures**: Version mismatches between `pyproject.toml` and `uv.lock` caused commit failures
5. **Inconsistent process**: Version management split between local scripts and CI

### Root Causes

1. **Missing configuration**: `pyproject.toml` lacked `[semantic_release.changelog]` configuration
2. **Wrong command usage**: Using `semantic-release changelog` instead of `semantic-release version`
3. **Timing issues**: Trying to generate changelog before tags existed
4. **Lock file sync**: `uv.lock` not updated before git operations

## Solution Architecture

### Design Principles

1. **Separation of Concerns**: Local testing vs. CI automation
2. **Single Source of Truth**: All version operations in CI
3. **Leverage Conventional Commits**: Automatic CHANGELOG generation from commit messages
4. **Fail Fast**: Validate locally, execute in CI

### New Workflow

```
Developer Local                    GitHub Actions CI
─────────────────                  ─────────────────
                                   
1. Run tests                       
   uv run poe tag                  
   ↓                               
   ✓ lint/test/smoke               
   ✓ Calculate next version        
   ✓ Show instructions             
                                   
2. Create release branch           
   git checkout -b release/v1.7.0  
   git push origin release/v1.7.0  
                                   
3. Create PR                       
   gh pr create                    
   ↓                               
                                   4. PR merged to master
                                      ↓
                                   5. semantic-release version
                                      - Calculate version
                                      - Update pyproject.toml
                                      - Generate CHANGELOG.md
                                      - Update uv.lock
                                      - Create commit
                                      - Create tag
                                      - Push to remote
                                      ↓
                                   6. Create GitHub Release
                                      ↓
                                   7. Sync master → dev
```

## Implementation Details

### 1. Configuration Changes

**File**: `pyproject.toml`

```toml
[semantic_release]
assets = ["pyproject.toml", "uv.lock"]

[semantic_release.changelog]
changelog_file = "CHANGELOG.md"  # Enable CHANGELOG generation
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

**Key Changes**:
- Added `[semantic_release.changelog]` section to enable CHANGELOG generation
- Configured `changelog_file = "CHANGELOG.md"` (was empty/missing before)
- Added template environment configuration for Jinja2 rendering

### 2. Simplified Local Script

**File**: `scripts/tag.sh`

**Before**:
```bash
# Complex workflow with file modifications
semantic-release changelog  # Didn't work
update-toml update --path project.version --value "$NEXT_VERSION"
semantic-release version --no-commit  # Broke pyproject.toml
git add pyproject.toml CHANGELOG.md uv.lock
git commit -m "chore: release v$NEXT_VERSION"
```

**After**:
```bash
# Simple validation workflow
uv run poe lint
uv run poe test
uv run poe smoke
NEXT_VERSION=$(uv run semantic-release version --print)
# Show instructions, don't modify files
```

**Benefits**:
- ✅ No file modifications locally
- ✅ Faster execution (no git operations)
- ✅ Clearer separation: validate locally, execute in CI
- ✅ Reduced error potential

### 3. Enhanced CI Workflow

**File**: `.github/workflows/release-on-pr.yaml`

**Before**:
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

**After**:
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

**Benefits**:
- ✅ Automatic version calculation
- ✅ Automatic CHANGELOG generation with detailed commit history
- ✅ Automatic file updates (pyproject.toml, CHANGELOG.md, uv.lock)
- ✅ Single command handles entire release preparation

## CHANGELOG Format

### Before (Manual)

```markdown
## v1.7.0 (2026-01-26)


## v1.6.0 (2026-01-25)
```

Empty entries requiring manual filling.

### After (Automatic)

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

Detailed, categorized entries automatically generated from conventional commits.

## Benefits

### For Developers

1. **Simpler Local Workflow**
   - Run `uv run poe tag` to validate
   - Create branch and PR
   - No manual file editing

2. **Better Visibility**
   - Detailed CHANGELOG shows exactly what changed
   - Automatic categorization (feat/fix/breaking)
   - Links to PRs and commits

3. **Reduced Errors**
   - No manual version updates
   - No manual CHANGELOG editing
   - No git operation errors locally

### For Project

1. **Professional Documentation**
   - Consistent CHANGELOG format
   - Complete release history
   - Easy to understand changes

2. **Automation**
   - Version calculation from commits
   - CHANGELOG generation from commits
   - Tag and release creation

3. **Compliance**
   - Enforces conventional commits
   - Semantic versioning
   - Complete audit trail

## Migration Guide

### For Existing Release Branches

If you have an existing `release/*` branch created with the old workflow:

1. **Discard local changes** (if any uncommitted modifications)
2. **Rebase on master** to get the new workflow
3. **Re-run validation**: `uv run poe tag`
4. **Push and create PR** as usual

### For New Releases

Simply follow the new workflow:

```bash
# 1. Validate
uv run poe tag

# 2. Create branch
git checkout -b release/v1.7.0

# 3. Push and create PR
git push origin release/v1.7.0
gh pr create --title "chore: release v1.7.0" --base master

# 4. Merge PR → CI handles everything
```

## Troubleshooting

### Issue: "No new version to release"

**Cause**: No feat/fix commits since last release

**Solution**: 
- Check commit history: `git log v1.6.0..HEAD --oneline`
- Ensure commits follow conventional format
- Or use manual version: `uv run poe tag --version 1.7.0`

### Issue: CHANGELOG not generated

**Cause**: Missing `[semantic_release.changelog]` configuration

**Solution**: Verify `pyproject.toml` has:
```toml
[semantic_release.changelog]
changelog_file = "CHANGELOG.md"
```

### Issue: Pre-commit hook fails

**Cause**: Version mismatch or file modifications

**Solution**: 
- Ensure you're not modifying files locally
- Let CI handle all file updates
- If needed, run `uv sync` to update lock file

## Technical Details

### semantic-release Commands

| Command | Purpose | When to Use |
|---------|---------|-------------|
| `version --print` | Calculate next version | Local validation |
| `version` | Full release workflow | CI automation |
| `version --no-vcs-release` | Release without VCS integration | When creating release separately |
| `changelog` | Regenerate CHANGELOG | Manual updates only |

### Workflow Triggers

| Event | Workflow | Action |
|-------|----------|--------|
| PR to `dev`/`master` | `pr_gate.yaml` | Run tests |
| Merge to `dev` | `dev_deploy.yaml` | Deploy to dev |
| Merge `release/*` to `master` | `release-on-pr.yaml` | Create release |
| Tag push | `prod_deploy.yaml` | Deploy to prod |

## References

- [python-semantic-release Documentation](https://python-semantic-release.readthedocs.io/)
- [Conventional Commits](https://www.conventionalcommits.org/)
- [Semantic Versioning](https://semver.org/)

## Changelog

- **2026-01-26**: Initial documentation of workflow improvements
- **2026-01-26**: Added semantic-release integration
- **2026-01-26**: Simplified local workflow
- **2026-01-26**: Enhanced CI automation

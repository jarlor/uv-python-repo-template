# CHANGELOG


## Unreleased


## v1.6.0 (2026-01-25)


## v1.5.1 (2026-01-25)

### Chores

- Release v1.5.0 ([#14](https://github.com/jarlor/uv-python-repo-template/pull/14),
  [`3c8b3d7`](https://github.com/jarlor/uv-python-repo-template/commit/3c8b3d7d0996f7cf6458bc9ce947f843b0704e0e))

1.5.0

### Documentation

- Manually update CHANGELOG for PR #10 and #11
  ([#12](https://github.com/jarlor/uv-python-repo-template/pull/12),
  [`85b2cef`](https://github.com/jarlor/uv-python-repo-template/commit/85b2cefe829ba30d823a4c8cccf9ccdcc8c078a5))

Add missing changelog entries for: - feat: pre-push hook for dev branch protection (#11) - docs:
  comprehensive documentation restructure (#10)

These PRs were merged with non-conventional commit titles, so semantic-release didn't pick them up
  automatically.

### Refactoring

- Enhance ruff and mypy configurations (#15)
  ([#16](https://github.com/jarlor/uv-python-repo-template/pull/16),
  [`8a6c621`](https://github.com/jarlor/uv-python-repo-template/commit/8a6c6211407215b7ef1e3409f497fd2d95ee64a2))

- Remove unused [project.scripts] section - Add comprehensive ruff lint rules (E, W, F, I, N, UP, B,
  C4, SIM, RET, ARG, PTH, ERA, PL, PERF) - Enable mypy strict mode with full type checking - Add
  type annotations to all functions (src and tests) - Update AGENTS.md with detailed linting and
  type checking guidelines

- Merge tag and tag-manual into unified command
  ([#13](https://github.com/jarlor/uv-python-repo-template/pull/13),
  [`d3dbfce`](https://github.com/jarlor/uv-python-repo-template/commit/d3dbfce863d9875e8f5407d335f2e3f246e5c7c1))

* feat: add manual version tagging support

- Add scripts/manual_tag.sh for manual version creation - Add 'uv run poe tag-manual --version
  X.Y.Z' command - Automatically updates pyproject.toml and CHANGELOG.md - Creates git tag with
  specified version - Update README with manual tagging instructions

Use cases: - When semantic-release refuses to create new version - When only documentation changes
  were made - When specific version number is needed

* refactor: merge tag and tag-manual into unified command

- Replace separate tag/tag-manual with single 'tag' command - Auto mode: uv run poe tag (default,
  uses semantic-release) - Manual mode: uv run poe tag --version X.Y.Z - Simplifies user experience
  with single command - Includes quality checks in both modes


## v1.4.0 (2026-01-25)

### Features

- Add independent sync workflow for all master pushes
  ([`1a7c995`](https://github.com/jarlor/uv-python-repo-template/commit/1a7c995aa632c6588534f20c416183f0722a5425))


## v1.3.4 (2026-01-25)

### Bug Fixes

- Allow semantic-release version commits in commit-msg hook
  ([`cce3ea0`](https://github.com/jarlor/uv-python-repo-template/commit/cce3ea0386217211ff74755c54d08d78f18a4240))

- Remove .venv deletion from initialization script
  ([`1a45520`](https://github.com/jarlor/uv-python-repo-template/commit/1a4552097de2d5a791ca2f2e10fcf625115d589d))

### Build System

- Rename project to uv_python_repo_template
  ([`a88bd33`](https://github.com/jarlor/uv-python-repo-template/commit/a88bd332eb8347b35cc870c9f4d04be0fee0795d))

### Continuous Integration

- Sync PR template to master via standard flow
  ([`12926a1`](https://github.com/jarlor/uv-python-repo-template/commit/12926a1b70dd02bdb662afd6e8a0d99c5dcc5274))

- Sync PR template to master via standard flow
  ([#1](https://github.com/jarlor/uv-python-repo-template/pull/1),
  [`cb9e12a`](https://github.com/jarlor/uv-python-repo-template/commit/cb9e12ab7aa3258e2f295d60a4f069b74033659d))

### Documentation

- Add PR template to default branch for GitHub template loading
  ([`e16ea68`](https://github.com/jarlor/uv-python-repo-template/commit/e16ea6833ad22ce347a67a9d5c2cb19201063dd7))

### Features

- Auto-sync master to dev after release creation
  ([`fb11546`](https://github.com/jarlor/uv-python-repo-template/commit/fb11546f6bc7b8e6c976d5b218333ae62f6f67eb))


## v1.3.3 (2025-04-08)

### Bug Fixes

- Add conflict check for mutually exclusive workflows 'release' and 'publish'
  ([`e0ff4d1`](https://github.com/jarlor/uv-python-repo-template/commit/e0ff4d16a67d7bf17dd5449965ff4a59eac4de00))

- Include 'uv.lock' in semantic release assets
  ([`8916029`](https://github.com/jarlor/uv-python-repo-template/commit/89160297f6faffcdbba10dc9e55c7253dfe3c06d))


## v1.3.2 (2025-04-07)

### Bug Fixes

- Adjust ruff format line length to 100 characters
  ([`a5a88a1`](https://github.com/jarlor/uv-python-repo-template/commit/a5a88a1cfaa0d40c21b7a88f27cd0bb242e380bf))


## v1.3.1 (2025-04-07)

### Bug Fixes

- Update pre-commit hook entry to use 'poe lint' for code formatting
  ([`e7444f5`](https://github.com/jarlor/uv-python-repo-template/commit/e7444f5a50bde0603885acb6e095258fba991224))

- Update ruff check command to target src/ directory
  ([`2f37392`](https://github.com/jarlor/uv-python-repo-template/commit/2f373927e594627af335c188c1d66ae3e64bcc9c))

### Documentation

- **contributor**: Contrib-readme-action has updated readme
  ([`5b74a4c`](https://github.com/jarlor/uv-python-repo-template/commit/5b74a4c3f092c38b46418c63ada363449ab5efd3))


## v1.3.0 (2025-04-03)

### Features

- Add collaborators section to README
  ([`29c5cfb`](https://github.com/jarlor/uv-python-repo-template/commit/29c5cfbfc262b27cdc9a1bf018665b6b409cde19))


## v1.2.0 (2025-04-03)

### Features

- Add GitHub Actions workflow to automate contributors list in README
  ([`37bd4a8`](https://github.com/jarlor/uv-python-repo-template/commit/37bd4a8a88add95d119d4cf70c52e404bd768047))


## v1.1.0 (2025-04-03)

### Features

- Add make_latest option to publish and release workflows
  ([`f22c271`](https://github.com/jarlor/uv-python-repo-template/commit/f22c2716435c250fb178097a9f9212034c198497))

- Update pre-commit hooks and task sequences for validation
  ([`3beef69`](https://github.com/jarlor/uv-python-repo-template/commit/3beef69b5c791210512c9cc0a5082308aa4d2fff))


## v1.0.0 (2025-04-03)

### Chores

- Rename init_linux.sh to init.sh and update changelog for CI changes
  ([`125ca99`](https://github.com/jarlor/uv-python-repo-template/commit/125ca99744bd1d9f781efa22988755c45f41c878))

- Update .gitignore to include .pre-commit.log
  ([`78d8223`](https://github.com/jarlor/uv-python-repo-template/commit/78d8223e985f3c4a71a23e0cfe99bd08d1727b29))

### Continuous Integration

- Disable workflow lint_test
  ([`a017b2d`](https://github.com/jarlor/uv-python-repo-template/commit/a017b2d65da939edf1a5c47aa7df72a76230ffe4))

### Features

- Modify task sequences in pyproject.toml
  ([`c73925e`](https://github.com/jarlor/uv-python-repo-template/commit/c73925e36294b947cbd4dd38fe9e97d274e9f8e3))


## v0.24.0 (2025-04-03)

### Features

- Update commit message format for workflow actions and add unreleased section to changelog
  ([`fc032c0`](https://github.com/jarlor/uv-python-repo-template/commit/fc032c0e9b42c3498cc63c4e3c422f9a0e95bcf3))


## v0.23.0 (2025-04-03)

### Build System

- Update initialization script to add changes and commit with project name
  ([`b8b8d92`](https://github.com/jarlor/uv-python-repo-template/commit/b8b8d920c758c0fdfbfc85e6528ee5f90e34cdcc))

### Features

- Implement workflow management and secret validation
  ([`5109744`](https://github.com/jarlor/uv-python-repo-template/commit/51097442c2fc5dc79bd195331f35f159cc55890d))


## v0.22.2 (2025-04-03)

### Bug Fixes

- Clean up comments and formatting in test cases
  ([`9f95d05`](https://github.com/jarlor/uv-python-repo-template/commit/9f95d05f2ce373e2a8ce76301c6f7e4ba472e291))

- Update pre-commit hook entry to use lint instead of format
  ([`8c903ad`](https://github.com/jarlor/uv-python-repo-template/commit/8c903ad44817800cb84f03d27eeea5cd44de5b08))


## v0.22.1 (2025-04-03)

### Bug Fixes

- Delete old .git directory before reinitializing
  ([`666f4ec`](https://github.com/jarlor/uv-python-repo-template/commit/666f4ec2597722afe9653898711ae90cda5a45ed))


## v0.22.0 (2025-04-03)

### Features

- Update release workflow to extract release notes and improve tagging
  ([`bdf94b1`](https://github.com/jarlor/uv-python-repo-template/commit/bdf94b144fa09c6a94ecb853ad09e2012717c08a))


## v0.21.2 (2025-04-02)

### Bug Fixes

- Redirect output of release notes extraction to a file
  ([`96386cf`](https://github.com/jarlor/uv-python-repo-template/commit/96386cfd4cd0a2763d10b0c2030dddb056ff930e))


## v0.21.1 (2025-04-02)

### Bug Fixes

- Correct script name for extracting release notes
  ([`60c4a7b`](https://github.com/jarlor/uv-python-repo-template/commit/60c4a7b9ea445dfc2f28cee20d22a8a69ae7a816))


## v0.21.0 (2025-04-02)

### Features

- Rename changelog step and add script to extract release notes
  ([`58bcc3e`](https://github.com/jarlor/uv-python-repo-template/commit/58bcc3e55cfb317d847d425e0b36f16b7f561a5d))


## v0.20.0 (2025-04-02)

### Features

- Add tag parameters to release changelog builder action
  ([`9dfc635`](https://github.com/jarlor/uv-python-repo-template/commit/9dfc63535a768bbb9189a344742c2397c00fa2eb))


## v0.19.0 (2025-04-02)

### Features

- Update release action to include files and use ACTION_GITHUB_TOKEN
  ([`b81b71e`](https://github.com/jarlor/uv-python-repo-template/commit/b81b71e7db3612545c087c396f3cb6b5832e6c7e))


## v0.18.0 (2025-04-02)

### Features

- Rename job for GitHub release and update steps for changelog generation
  ([`4ff94f7`](https://github.com/jarlor/uv-python-repo-template/commit/4ff94f7aa342f207f3d56c486645be1e844262d8))


## v0.17.0 (2025-04-02)

### Features

- Rename step for updating release draft in workflow
  ([`3362c5c`](https://github.com/jarlor/uv-python-repo-template/commit/3362c5c9b89dfa500f203e1ff9570b8c8596f67f))


## v0.16.0 (2025-04-02)

### Features

- Update release workflow to use release drafter and adjust file paths for GitHub releases
  ([`34be480`](https://github.com/jarlor/uv-python-repo-template/commit/34be480828e9882c21ea79648180f3e849735bc7))


## v0.15.0 (2025-04-02)

### Features

- Update release workflow to use ACTION_GITHUB_TOKEN and add release drafter configuration
  ([`f0678d5`](https://github.com/jarlor/uv-python-repo-template/commit/f0678d5f1d1330dfb957048dd04b560fed3b8084))


## v0.14.0 (2025-04-02)

### Features

- Update release workflow to remove main branch trigger and use ACTION_GITHUB_TOKEN
  ([`7b7345c`](https://github.com/jarlor/uv-python-repo-template/commit/7b7345c9546d3a1e8d019baee6af30f920202840))


## v0.13.0 (2025-04-02)

### Features

- Update release workflow to support version tags without patch numbers
  ([`6c343ec`](https://github.com/jarlor/uv-python-repo-template/commit/6c343ec43036c49297f926d658b35f6bfae15043))


## v0.12.0 (2025-04-02)

### Features

- Update release workflow to trigger on pushes to the main branch
  ([`7717994`](https://github.com/jarlor/uv-python-repo-template/commit/771799424578eec518424ba2c3796d87f475dbec))


## v0.11.0 (2025-04-02)

### Features

- Rename release workflow from Publish to PyPI to Release to GitHub
  ([`ec92aea`](https://github.com/jarlor/uv-python-repo-template/commit/ec92aeaaacfd10dd7fff080e330b41d565071158))


## v0.10.0 (2025-04-02)

### Features

- Add semantic_release configuration for asset management in pyproject.toml
  ([`59a4c46`](https://github.com/jarlor/uv-python-repo-template/commit/59a4c466f6d996e9a033e34b2e52161f84c3cf7e))


## v0.9.0 (2025-04-02)

### Features

- Rename lint_test.yaml to lint_test.yaml.template and update publish workflow for versioning and
  release
  ([`c2af494`](https://github.com/jarlor/uv-python-repo-template/commit/c2af494a3530935f66835c9ca6f718814025cd78))

- Update lint_test.yaml to remove Python 3.x from version matrix
  ([`3cca2f1`](https://github.com/jarlor/uv-python-repo-template/commit/3cca2f14139dfe8fc13af10d1e06833acb22f756))


## v0.8.0 (2025-04-02)

### Features

- Update CHANGELOG for upcoming release and adjust semantic-release tasks
  ([`4ca5d45`](https://github.com/jarlor/uv-python-repo-template/commit/4ca5d459ec8bf9f3c66582900d46c6600beba07f))

- Update CHANGELOG for upcoming release and bump version to 0.8.0 in pyproject.toml
  ([`9e7974a`](https://github.com/jarlor/uv-python-repo-template/commit/9e7974a6a07def1a65617b473c2c78e04d72106d))

- Update CHANGELOG for v0.7.0 and modify semantic-release tasks in pyproject.toml
  ([`4df01c4`](https://github.com/jarlor/uv-python-repo-template/commit/4df01c44cb7daed8e7f595a6e8fb98f0e78b997f))


## v0.7.0 (2025-04-02)

### Features

- Rename publish.yaml to publish.yaml.template
  ([`88b2a1d`](https://github.com/jarlor/uv-python-repo-template/commit/88b2a1dc647b0a1005328d7c31576c97b025a48d))


## v0.6.0 (2025-04-01)

### Features

- Remove outdated README content and streamline project description
  ([`fdc01e2`](https://github.com/jarlor/uv-python-repo-template/commit/fdc01e20df3a67f5eecd2815c837056882089c85))


## v0.5.0 (2025-04-01)

### Features

- Update publish.yaml to specify main branch for push events and use python-version-file for Python
  setup
  ([`dce0ee2`](https://github.com/jarlor/uv-python-repo-template/commit/dce0ee284813db6bdb8dc2e3c9820f5bcd4a8b6b))


## v0.4.0 (2025-04-01)

### Features

- Downgrade required Python version from 3.12 to 3.10 in pyproject.toml and update .python-version
  ([`6bb2ffd`](https://github.com/jarlor/uv-python-repo-template/commit/6bb2ffd4aeece1e1b11111a44ffb9e7cc44c786b))


## v0.3.0 (2025-04-01)

### Documentation

- Adjust pyproject.toml
  ([`e8ac10d`](https://github.com/jarlor/uv-python-repo-template/commit/e8ac10d20c848378b74eb6fb75d2012d88f1d86b))

### Features

- Add unit tests for add_numbers function and update mypy linting path
  ([`eafe694`](https://github.com/jarlor/uv-python-repo-template/commit/eafe6945af5fd9732f18a02a79a63b704dc47d51))

- Rename main-lint-test.yaml to lint_test.yaml and update linting steps
  ([`ecdc74f`](https://github.com/jarlor/uv-python-repo-template/commit/ecdc74f24429b9b14a8962fa3e4e06aab9486bdc))

- Update init script and add main function to tests
  ([`b81bb5f`](https://github.com/jarlor/uv-python-repo-template/commit/b81bb5f7946f362125fdc4c44ec808566b0c539b))

- Update init script to rename directory and remove .venv directory
  ([`3a4e197`](https://github.com/jarlor/uv-python-repo-template/commit/3a4e197e47cccbe7d3e95108d12b06a6752888c9))


## v0.2.0 (2025-04-01)

### Features

- Add new func
  ([`deb6b23`](https://github.com/jarlor/uv-python-repo-template/commit/deb6b23b93300759b3123cad8060ca836b80dfd2))


## v0.0.0 (2025-04-01)


## v0.1.0 (2025-04-01)

### Features

- Add python-semantic-release
  ([`a3e0b60`](https://github.com/jarlor/uv-python-repo-template/commit/a3e0b60189f1da97a2b517a3c4344a06b00df4bb))

### Refactoring

- Adjust init_linux.sh
  ([`0d6eb30`](https://github.com/jarlor/uv-python-repo-template/commit/0d6eb30d2b508c4ecad429da892eb8ab173cae7a))

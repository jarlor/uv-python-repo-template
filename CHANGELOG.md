# CHANGELOG


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

#!/bin/bash

dir_name=$(basename "$PWD") # get the current directory name
# replace - to _
dir_name=$(echo "$dir_name" | sed 's/-/_/g')

escaped_dir_name=$(printf "%s" "$dir_name" | sed 's/[&/\]/\\&/g') # escape special characters for sed

# 1. Replace the string in pyproject.toml
if [ -f "pyproject.toml" ]; then
    sed -i.bak "s/uv_python_repo_template/$escaped_dir_name/g" pyproject.toml && rm pyproject.toml.bak
    sed -i.bak "s/uv_python_repo_template/$escaped_dir_name/g" pyproject.toml && rm pyproject.toml.bak

else
    echo "Error: pyproject.toml file not found" >&2
    exit 1
fi

# 2. Rename the directory
if [ -d "src/uv_python_repo_template" ]; then
    mv "src/uv_python_repo_template" "$dir_name"
else
    echo "Warning: 'src/uv_python_repo_template' directory not found, skipping renaming" >&2
fi

# 3. Run the init command
uv run poe init
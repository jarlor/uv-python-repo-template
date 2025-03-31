#!/bin/bash

# 获取当前目录名
dir_name=$(basename "$PWD")

# 转义特殊字符以兼容sed
escaped_dir_name=$(printf "%s" "$dir_name" | sed 's/[&/\]/\\&/g')

# 1. 替换pyproject.toml中的字符串
if [ -f "pyproject.toml" ]; then
    sed -i.bak "s/python-repo-template/$escaped_dir_name/g" pyproject.toml && rm pyproject.toml.bak
else
    echo "错误：未找到 pyproject.toml 文件" >&2
    exit 1
fi

# 2. 重命名目录
if [ -d "python-repo-template" ]; then
    mv "python-repo-template" "$dir_name"
else
    echo "警告：未找到 'python-repo-template' 目录，跳过重命名" >&2
fi

# 3. 重命名配置文件并执行命令
if [ -f "pyproject.toml" ]; then
    mv "pyproject.toml" "pyproject.toml.bak"
    echo "已创建备份文件：pyproject.toml.bak"
else
    echo "错误：pyproject.toml 文件不存在，无法重命名" >&2
    exit 1
fi

# 执行初始化命令
uv run init
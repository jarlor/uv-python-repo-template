#!/bin/sh

awk '/^## v/ {
    if (found) exit
    found = 1
    print
    next
}
found && /^## / { exit }
found { print }' CHANGELOG.md | sed '$d'
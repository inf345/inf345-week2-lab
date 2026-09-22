#!/usr/bin/env bash
set -euo pipefail

dir="${1:?usage: report.sh <directory>}"
cd "$dir"

files=$(find . -type f | wc -l)
dirs=$(find . -mindepth 1 -type d | wc -l)

echo "FILES: $files"
echo "DIRS: $dirs"

echo "LARGEST:"
find . -type f -printf '%s %p\n' | sort -rn | head -3

echo "EXECUTABLE:"
find . -type f -perm -u+x | sort

echo "EXTENSIONS:"
find . -type f -name "*.*" -printf '%f\n' | sed 's/.*\.//' | sort | uniq -c | sort -rn | head -5 | awk '{printf "%s .%s\n", $1, $2}'


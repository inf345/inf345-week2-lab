#!/usr/bin/env bash

set -euo pipefail

dir="${1:?usage: report.sh <directory>}"

cd "$dir"

echo "FILES: $(find . -type f | wc -l)"
echo "DIRS: $(find . -mindepth 1 -type d | wc -l)"

echo "LARGEST:"
find . -type f -printf "%s %P\n" | sort -nr | head -n 3

echo "EXECUTABLE:"
find . -type f -executable -printf "%P\n" | sort

echo "EXTENSIONS:"
find . -type f -printf "%f\n" | { grep -E '^.+\.[^.]+$' || true; } | sed -E 's/.*\.([^.]+)$/.\1/' | sort | uniq -c | sort -nr | head -n 5 | awk '{print $1, $2}'
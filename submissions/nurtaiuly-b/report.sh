#!/usr/bin/env bash
set -euo pipefail
export LC_ALL=C
dir="${1:?usage: report.sh <directory>}"
cd "$dir"

echo "FILES: $(find . -type f | wc -l)"
echo "DIRS: $(find . -mindepth 1 -type d | wc -l)"

echo "LARGEST:"
find . -type f -printf '%s %P\n' | sort -nr | head -3

echo "EXECUTABLE:"
find . -type f -perm -u=x -printf '%P\n' | sort

echo "EXTENSIONS:"
find . -type f -printf '%f\n' | awk -F. 'NF>1{print "."$NF}' | sort | uniq -c | sort -rn | head -5 | awk '{print $1,$2}'

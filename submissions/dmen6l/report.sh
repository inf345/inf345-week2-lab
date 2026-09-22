#!/usr/bin/env bash

set -euo pipefail

dir="${1:?usage: report.sh <directory>}"

echo "FILES: $(find "$dir" -type f | wc -l)"
echo "DIRS: $(find "$dir" -mindepth 1 -type d | wc -l)"

echo "LARGEST:"
find "$dir" -type f -printf '%s %P\n' |
  sort -nr |
  head -3

echo "EXECUTABLE:"
find "$dir" -type f -perm -u=x -printf '%P\n' |
  sort

echo "EXTENSIONS:"
find "$dir" -type f -name '*.*' |
  sed 's/.*\.//' |
  sort |
  uniq -c |
  sort -k1,1nr -k2,2 |
  head -5 |
  awk '{print $1 " ." $2}'

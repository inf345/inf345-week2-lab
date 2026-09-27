#!/usr/bin/env bash
set -euo pipefail

dir="${1:?usage: report.sh <directory>}"
export LC_ALL=C

cd "$dir"


files=$(find . -mindepth 1 -type f | wc -l)
dirs=$(find . -mindepth 1 -type d | wc -l)

echo "FILES: $files"
echo "DIRS: $dirs"


echo "LARGEST:"
find . -mindepth 1 -type f -printf '%s %p\n' | sort -rn | head -3


echo "EXECUTABLE:"
find . -mindepth 1 -type f -perm -u+x -printf '%p\n' | sort


echo "EXTENSIONS:"
declare -A counts
while IFS= read -r -d '' f; do
  base="${f##*/}"
  stripped="${base#.}"         
  if [[ "$stripped" == *.* ]]; then
    ext="${stripped##*.}"
    counts["$ext"]=$(( ${counts["$ext"]:-0} + 1 ))
  fi
done < <(find . -mindepth 1 -type f -print0)

for ext in "${!counts[@]}"; do
  echo "${counts[$ext]} $ext"
done | sort -rn -k1,1 | head -5 | awk '{print $1, "."$2}'
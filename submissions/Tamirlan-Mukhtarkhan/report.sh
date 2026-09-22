#!/usr/bin/env bash
set -euo pipefail

dir="$1"
cd "$dir"

filesize() {
  if stat -c '%s' "$1" >/dev/null 2>&1; then
    stat -c '%s' "$1"
  else
    stat -f '%z' "$1"
  fi
}

files_count=$(find . -type f | wc -l | tr -d ' ')
dirs_count=$(find . -mindepth 1 -type d | wc -l | tr -d ' ')

echo "FILES: $files_count"
echo "DIRS: $dirs_count"

echo "LARGEST:"
find . -type f -print0 | while IFS= read -r -d '' f; do
  printf '%s %s\n' "$(filesize "$f")" "$f"
done | sort -k1,1rn | head -3

echo "EXECUTABLE:"
find . -type f -perm -100 | sort

echo "EXTENSIONS:"
find . -type f -exec basename {} \; | while read -r name; do
  case "$name" in
    .*)
      rest="${name#.}"
      if [[ "$rest" == *.* ]]; then
        echo "${rest##*.}"
      fi
      ;;
    *.*)
      echo "${name##*.}"
      ;;
  esac
done | sort | uniq -c | sort -rn | head -5 | awk '{printf "%d .%s\n", $1, $2}'

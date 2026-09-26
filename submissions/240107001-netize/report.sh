#!/usr/bin/env bash
set -euo pipefail

dir="$1"

cd "$dir"

files=$(find . -mindepth 1 -type f | wc -l)
dirs=$(find . -mindepth 1 -type d | wc -l)

echo "FILES: $files"
echo "DIRS: $dirs"

echo "LARGEST:"
find . -mindepth 1 -type f -printf '%s %p\n' \
  | sed 's|^\([0-9]*\) \./|\1 |' \
  | sort -k1,1nr -k2,2 \
  | head -n 3

echo "EXECUTABLE:"
find . -mindepth 1 -type f -perm -u+x -printf '%p\n' \
  | sed 's|^\./||' \
  | sort

echo "EXTENSIONS:"
find . -mindepth 1 -type f -printf '%f\n' | while IFS= read -r name; do
  case "$name" in
    *.*)
      before="${name%.*}"
      if [ -n "$before" ]; then
        echo ".${name##*.}"
      fi
      ;;
  esac
done | sort | uniq -c | sort -k1,1nr -k2,2 | head -n 5 | awk '{print $1, $2}'
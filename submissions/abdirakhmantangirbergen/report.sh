#!/usr/bin/env bash
set -euo pipefail

TARGET_DIR="${1:-.}"

if [ ! -d "$TARGET_DIR" ]; then
  exit 1
fi

# Переходим в целевую папку, чтобы пути были относительными
cd "$TARGET_DIR"

# 1. FILES
echo "FILES:"
find . -type f | wc -l | tr -d ' '

# 2. DIRS
echo "DIRS:"
find . -mindepth 1 -type d | wc -l | tr -d ' '

# 3. LARGEST
echo "LARGEST:"
find . -type f -exec du -b {} + 2>/dev/null | sed 's|^\./||' | sort -rn -k1,1 | head -n 3 | awk '{print $1 " " $2}' || \
find . -type f -exec ls -l {} + 2>/dev/null | awk '{print $5 " " $NF}' | sed 's|^\./||' | sort -rn -k1,1 | head -n 3 || true

# 4. EXECUTABLE
echo "EXECUTABLE:"
find . -type f \( -perm -100 -o -perm -010 -o -perm -001 \) | sed 's|^\./||' | sort || true

# 5. EXTENSIONS
echo "EXTENSIONS:"
find . -type f -name "*.*" | sed -n 's/.*\.\([^.]*\)$/.\1/p' | sort | uniq -c | sort -rn -k1,1 -k2,2 | head -n 5 | awk '{print $1 " " $2}' || true
#!/usr/bin/env bash

TARGET="$1"

cd "$TARGET" || exit 1

echo "FILES: $(find . -type f | wc -l)"
echo "DIRS: $(find . -mindepth 1 -type d | wc -l)"

echo "LARGEST:"
find . -type f -exec stat -c "%s %n" {} + 2>/dev/null | sort -k1,1nr | head -n 3 | sed 's| \./| |'

echo "EXECUTABLE:"
find . -type f -executable | sed 's|^\./||' | sort

echo "EXTENSIONS:"
find . -type f | grep -E '\.[^./]+$' | sed 's/.*\.//' | sort | uniq -c | sort -k1,1nr -k2,2 | head -n 5 | awk '{print $1 " ." $2}'

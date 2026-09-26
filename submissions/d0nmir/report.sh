#!/usr/bin/env bash

if [ -z "$1" ]; then
    echo "Usage: $0 <directory>"
    exit 1
fi

TARGET_DIR="$1"

if [ ! -d "$TARGET_DIR" ]; then
    echo "Directory does not exist"
    exit 1
fi

FILES_COUNT=$(find "$TARGET_DIR" -mindepth 1 -type f | wc -l)
DIRS_COUNT=$(find "$TARGET_DIR" -mindepth 1 -type d | wc -l)

echo "FILES: $FILES_COUNT"
echo "DIRS: $DIRS_COUNT"

echo "LARGEST:"
find "$TARGET_DIR" -type f -exec ls -l {} + 2>/dev/null | \
    awk -v base="$TARGET_DIR" '{
        sub("^" base "/", "", $NF);
        sub("^./", "", $NF);
        print $5 " " $NF
    }' | sort -rn -k1,1 | head -n 3

echo "EXECUTABLE:"
find "$TARGET_DIR" -type f \( -perm -100 -o -executable \) 2>/dev/null | \
    sed "s|^${TARGET_DIR}/||; s|^\./||" | sort -u

echo "EXTENSIONS:"
find "$TARGET_DIR" -type f -name "*.*" ! -name ".*" 2>/dev/null | \
    sed -n 's/.*\.\([^./]*\)$/.\1/p' | \
    sort | uniq -c | \
    sort -rn -k1,1 -k2,2 | head -n 5 | \
    awk '{print $1 " ." $2}'
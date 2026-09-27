#!/bin/bash

if [ -z "$1" ]; then
    echo "Usage: $0 <directory>"
    exit 1
fi

cd "$1" || exit 1

FILES_COUNT=$(find . -type f | wc -l | sed 's/ //g')
DIRS_COUNT=$(find . -mindepth 1 -type d | wc -l | sed 's/ //g')

echo "FILES: $FILES_COUNT"
echo "DIRS: $DIRS_COUNT"

echo "LARGEST:"
find . -type f | sed 's|^\./||' | while read -r file; do
    if [ -f "$file" ]; then
        size=$(wc -c < "$file" | sed 's/ //g')
        echo "$size $file"
    fi
done | sort -nr | head -3

echo "EXECUTABLE:"
find . -type f -perm -u=x | sed 's|^\./||' | sort

echo "EXTENSIONS:"
find . -type f | sed 's|^\./||' | grep "\." | awk -F. '{print "."$NF}' | sort | uniq -c | sort -nr | head -5 | awk '{print $1, $2}'

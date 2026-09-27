#!/usr/bin/env bash

set -euo pipefail

dir="${1:?usage: report.sh <directory>}"

file_count=$(find "$dir" -type f | wc -l)
echo "FILES: $file_count"

dir_count=$(find "$dir" -mindepth 1 -type d | wc -l)
echo "DIRS: $dir_count"

echo "LARGEST:"
find "$dir" -type f -printf '%s %P\n' | sort -nr | head -3

echo "EXECUTABLE:"
find "$dir" -type f -perm -u+x -printf '%p\n' | sed "s|^$dir/||" | sort

echo "EXTENSIONS:"
find "$dir" -type f -printf '%f\n' |
awk '
/\./ {
    name=$0
    sub(/^.*\./, "", name)
    if (name != "") count[name]++
}
END {
    for (ext in count)
        print count[ext], "." ext
}' |
sort -k1,1nr -k2,2 |
head -5

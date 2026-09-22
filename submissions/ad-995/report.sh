#!/usr/bin/env bash
set -euo pipefail

dir="${1:?usage: report.sh <directory>}"

echo "FILES: $(find "$dir" -type f | wc -l)"
echo "DIRS: $(find "$dir" -mindepth 1 -type d | wc -l)"

echo "LARGEST:"
find "$dir" -type f -printf '%s %P\n' | sort -nr | head -3

echo "EXECUTABLE:"
find "$dir" -type f -perm -100 -printf '%P\n' | sort

echo "EXTENSIONS:"
find "$dir" -type f -printf '%f\n' |
awk '
{
    n = split($0, parts, ".")
    if (n > 1) {
        ext = "." parts[n]
        count[ext]++
    }
}
END {
    for (ext in count)
        print count[ext], ext
}
' | sort -k1,1nr -k2,2 | head -5
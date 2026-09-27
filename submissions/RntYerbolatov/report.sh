#!/usr/bin/env bash

set -euo pipefail

dir="${1:?usage: report.sh <directory>}"

echo "FILES: $(find "$dir" -type f | wc -l)"
echo "DIRS: $(find "$dir" -mindepth 1 -type d | wc -l)"

echo "LARGEST:"
find "$dir" -type f -printf '%s %p\n' |
	sort -nr |
	head -3 |
	while read -r size file
	do
		echo "$size ${file#$dir/}"
	done

echo "EXECUTABLE:"
find "$dir" -type f -perm -u=x -printf '%p\n' |
	sed "s|^$dir/||" |
	sort

echo "EXTENSIONS:"
find "$dir" -type f |
awk '
{
    n = split($0, parts, "/")
    file = parts[n]

    if (file ~ /\./ && file !~ /^\./) {
        sub(/^.*\./, "", file)
        count[file]++
    }
}
END {
    for (ext in count)
        print count[ext], "." ext
}' |
sort -k1,1nr -k2,2 |
head -5

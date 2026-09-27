#!/usr/bin/env bash
set -euo pipefail

dir="${1:?usage: report.sh <directory>}"
cd -- "$dir"

files=$(find . -type f | wc -l | tr -d '[:space:]')
dirs=$(find . -mindepth 1 -type d | wc -l | tr -d '[:space:]')
echo "FILES: $files"
echo "DIRS: $dirs"

echo "LARGEST:"
find . -type f -exec wc -c {} \; | sort -nr | sed -n '1,3p'

echo "EXECUTABLE:"
find . -type f -perm -100 | sort

echo "EXTENSIONS:"
find . -type f |
    sed 's|.*/||' |
    awk -F. 'NF > 1 && $NF != "" && !(NF == 2 && $1 == "") { print "." $NF }' |
    sort | uniq -c | sort -nr | sed -n '1,5p' |
    awk '{ print $1, $2 }'

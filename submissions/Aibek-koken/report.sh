#!/usr/bin/env bash
set -euo pipefail

DIR="$1"

echo "FILES: $(find "$DIR" -type f | wc -l | tr -d ' ')"
echo "DIRS: $(find "$DIR" -mindepth 1 -type d | wc -l | tr -d ' ')"

echo "LARGEST:"
find "$DIR" -type f -exec ls -l {} + | awk '{print $5, $NF}' | sort -k1 -n -r | head -n 3 | while read -r size path; do
    rel_path="${path#$DIR/}"
    rel_path="${rel_path#./}"
    echo "$size $rel_path"
done

echo "EXECUTABLE:"
find "$DIR" -type f \( -perm -100 -o -perm -010 -o -perm -001 \) | while read -r path; do
    rel_path="${path#$DIR/}"
    rel_path="${rel_path#./}"
    echo "$rel_path"
done | sort

echo "EXTENSIONS:"
find "$DIR" -type f -name "*.*" | awk -F. 'NF>1 {print $NF}' | sort | uniq -c | sort -rn -k1 | head -n 5 | awk '{print $1, "."$2}'
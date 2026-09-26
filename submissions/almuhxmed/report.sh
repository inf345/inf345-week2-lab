#!/bin/bash

dir="$1"

cd "$dir" || exit 1

echo "FILES: $(find . -mindepth 1 -type f | wc -l | tr -d ' ')"
echo "DIRS: $(find . -mindepth 1 -type d | wc -l | tr -d ' ')"

echo "LARGEST:"
find . -mindepth 1 -type f -print0 |
while IFS= read -r -d '' f; do
  size=$(wc -c < "$f" | tr -d ' ')
  echo "$size $f"
done | sort -rn -k1,1 | head -n 3

echo "EXECUTABLE:"
find . -mindepth 1 -type f -perm -u+x | sort

echo "EXTENSIONS:"
find . -mindepth 1 -type f -exec basename {} \; |
grep '\.' |
sed 's/.*\(\.[^.]*\)$/\1/' |
sort |
uniq -c |
sort -rn -k1,1 |
head -n 5 |
awk '{print $1, $2}'

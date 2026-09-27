#!/bin/bash

DIR="$1"

echo "FILES: $(find "$DIR" -type f | wc -l | tr -d ' ')"
echo "DIRS: $(find "$DIR" -mindepth 1 -type d | wc -l | tr -d ' ')"

echo "LARGEST:"
find "$DIR" -type f -printf '%s %P\n' |
    sort -nr |
    head -n 3

echo "EXECUTABLE:"
find "$DIR" -type f -perm -u=x |
    sed "s|^$DIR/||" |
    sort

echo "EXTENSIONS:"
find "$DIR" -type f |
    sed 's|.*/||' |
    awk '
        /\./ && !/^\.[^.]+$/ {
            n = split($0, parts, ".")
            print "." parts[n]
        }
    ' |
    sort |
    uniq -c |
    sort -nr |
    head -n 5 |
    awk '{print $1, $2}'
#!/bin/bash

ROOT="$1"

echo "FILES:"
find "$ROOT" -type f | wc -l

echo "DIRS:"
find "$ROOT" -mindepth 1 -type d | wc -l

echo "LARGEST:"
find "$ROOT" -type f -printf '%s %P\n' | sort -nr | head -3

echo "EXECUTABLE:"
find "$ROOT" -type f -perm -u=x -printf '%P\n' | sort

echo "EXTENSIONS:"
find "$ROOT" -type f | awk '
{
    n = split($0, a, "/");
    file = a[n];

    if (file ~ /\./ && file !~ /^\./) {
        ext = file;
        sub(/^.*\./, ".", ext);
        count[ext]++;
    }
}
END {
    for (ext in count)
        print count[ext], ext;
}' | sort -k1,1nr -k2,2 | head -5

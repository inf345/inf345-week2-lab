#!/usr/bin/env bash

dir="$1"

echo "FILES: $(find "$dir" -type f | wc -l)"
echo "DIRS: $(find "$dir" -mindepth 1 -type d | wc -l)"

echo "LARGEST:"
find "$dir" -type f -printf '%s %P\n' \
  | sort -nr \
  | head -n 3

echo "EXECUTABLE:"
find "$dir" -type f -perm -u=x -printf '%P\n' \
  | sort

echo "EXTENSIONS:"
find "$dir" -type f -printf '%f\n' \
  | awk '
      /\./ {
          n = split($0, a, ".")
          if (n > 1 && a[n] != "")
              print "." a[n]
      }
    ' \
  | sort \
  | uniq -c \
  | sort -k1,1nr \
  | head -n 5 \
  | awk '{print $1, $2}'
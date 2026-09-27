#!/usr/bin/env bash
set -euo pipefail

if [ $# -lt 1 ]; then
    echo "Usage: $0 <directory>" >&2
    exit 1
fi

dir="$1"

if [ ! -d "$dir" ]; then
    echo "Not a directory: $dir" >&2
    exit 1
fi

cd "$dir"

# ---------- FILES / DIRS ----------
file_count=$(find . -mindepth 1 -type f | wc -l)
dir_count=$(find . -mindepth 1 -type d | wc -l)

echo "FILES: $file_count"
echo "DIRS: $dir_count"

# ---------- LARGEST ----------
echo "LARGEST:"
find . -mindepth 1 -type f -printf '%s %P\n' \
    | sort -rn -k1,1 \
    | head -3

# ---------- EXECUTABLE ----------
echo "EXECUTABLE:"
find . -mindepth 1 -type f -perm -100 -printf '%P\n' \
    | sort

# ---------- EXTENSIONS ----------
echo "EXTENSIONS:"
find . -mindepth 1 -type f -printf '%f\n' \
    | sed 's/^\.*//' \
    | awk -F. 'NF>1 {print $NF}' \
    | sort \
    | uniq -c \
    | sort -rn -k1,1 \
    | head -5 \
    | awk '{printf "%d .%s\n", $1, $2}'

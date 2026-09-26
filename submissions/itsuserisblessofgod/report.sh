#!/usr/bin/env bash
set -euo pipefail
export LC_ALL=C

if [ $# -ne 1 ]; then
    echo "usage: $0 <directory>" >&2
    exit 1
fi

dir="$1"

if [ ! -d "$dir" ]; then
    echo "error: '$dir' is not a directory" >&2
    exit 1
fi

cd "$dir"

# --- FILES / DIRS ---
files=$(find . -type f | wc -l | tr -d ' ')
dirs=$(find . -mindepth 1 -type d | wc -l | tr -d ' ')

echo "FILES: $files"
echo "DIRS: $dirs"

# --- LARGEST ---
echo "LARGEST:"
find . -type f -printf '%s %p\n' \
    | sort -k1,1nr \
    | head -n 3 \
    | sed 's#^\([0-9]\+\) \./#\1 #'

# --- EXECUTABLE ---
echo "EXECUTABLE:"
find . -type f -perm -u+x -printf '%p\n' \
    | sed 's#^\./##' \
    | sort

# --- EXTENSIONS ---
echo "EXTENSIONS:"
find . -type f -printf '%f\n' | while IFS= read -r base; do
    rest="${base#.}"          # drop a single leading dot (for dotfiles)
    if [[ "$rest" == *.* ]]; then
        ext="${rest##*.}"
        [ -n "$ext" ] && echo "$ext"
    fi
done | sort | uniq -c | sort -k1,1nr | head -n 5 | awk '{print $1, "."$2}'

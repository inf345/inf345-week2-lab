#!/usr/bin/env bash

set -euo pipefail

dir="${1:?usage: report.sh <directory>}"

# --- FILES / DIRS -----------------------------------------------------------
files_count=$(find "$dir" -type f | wc -l)
dirs_count=$(find "$dir" -mindepth 1 -type d | wc -l)

echo "FILES: $files_count"
echo "DIRS: $dirs_count"

# --- LARGEST ----------------------------------------------------------------
echo "LARGEST:"
find "$dir" -type f -printf '%s %p\n' \
    | sed "s|^\([0-9]*\) $dir/|\1 |" \
    | sort -k1,1nr -k2,2 \
    | head -n 3

# --- EXECUTABLE -------------------------------------------------------------
echo "EXECUTABLE:"
find "$dir" -type f -perm -u+x \
    | sed "s|^$dir/||" \
    | LC_ALL=C sort

# --- EXTENSIONS -------------------------------------------------------------
echo "EXTENSIONS:"
find "$dir" -type f -printf '%f\n' \
    | awk '
        {
            name = $0
            if (substr(name,1,1) == ".") name = substr(name,2)
            n = split(name, parts, ".")
            if (n < 2) next
            ext = parts[n]
            if (ext == "") next
            print ext
        }
    ' \
    | sort | uniq -c \
    | sort -k1,1nr -k2,2 \
    | head -n 5 \
    | awk '{ printf "%s .%s\n", $1, $2 }'

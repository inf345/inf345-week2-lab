#!/bin/bash
set -euo pipefail
export LC_ALL=C

if [ $# -ne 1 ]; then
    echo "Usage: $0 <directory>" >&2
    exit 1
fi

target="$1"

if [ ! -d "$target" ]; then
    echo "Error: '$target' is not a directory" >&2
    exit 1
fi

cd "$target"

# ---- FILES / DIRS ----
files_count=$(find . -mindepth 1 -type f | wc -l)
dirs_count=$(find . -mindepth 1 -type d | wc -l)

echo "FILES: $files_count"
echo "DIRS: $dirs_count"

# ---- LARGEST ----
# Portable across BSD find (macOS) and GNU find (Linux): no -printf,
# byte counts via `wc -c` instead of `stat`/`du` (whose flags differ per platform).
echo "LARGEST:"
while IFS= read -r f; do
    size=$(( $(wc -c < "$f") ))
    echo "$size ${f#./}"
done < <(find . -mindepth 1 -type f) \
    | sort -rn -k1,1 \
    | head -3

# ---- EXECUTABLE ----
echo "EXECUTABLE:"
find . -mindepth 1 -type f -perm -u+x \
    | sed 's|^\./||' \
    | sort

# ---- EXTENSIONS ----
echo "EXTENSIONS:"
find . -mindepth 1 -type f | while IFS= read -r f; do
    base="${f##*/}"

    # skip files with no dot at all
    case "$base" in
        *.*) : ;;
        *) continue ;;
    esac

    # a leading dot with no other dot is a dotfile, not an extension
    stripped="${base#.}"
    case "$base" in
        .*)
            case "$stripped" in
                *.*) : ;;
                *) continue ;;
            esac
            ;;
    esac

    echo "${base##*.}"
done \
    | sort \
    | uniq -c \
    | sort -rn -k1,1 \
    | head -5 \
    | awk '{printf "%s .%s\n", $1, $2}'

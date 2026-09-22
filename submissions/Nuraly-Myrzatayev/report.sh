#!/usr/bin/env bash
set -euo pipefail
dir="${1:?usage: report.sh <directory>}"

files=$(find "$dir" -type f | wc -l)
dirs=$(find "$dir" -mindepth 1 -type d | wc -l)
echo "FILES: $files"
echo "DIRS: $dirs"


listOfBigFilesLol=$(find "$dir" -type f  -printf "%s %P\n" | sort -nr | head -n 3)
echo "LARGEST:"
echo "$listOfBigFilesLol"


execMe=$(find "$dir" -type f -executable -printf "%P\n" | sort)
echo "EXECUTABLE:"
echo "$execMe"

extensionCount=$(find "$dir" -type f | grep -E ".*\.[a-zA-Z0-9]*$" | sed -e 's/.*\(\.[a-zA-Z0-9]*\)$/\1/' | sort | uniq -c | sort -nr | sed 's/^\s*//' | head -5)
#damn that's a long line lol
#find - first we find all the files we need
#grep - then we remove anything that doesn't have an extension
#first sed - leave extensions only -> ".txt\n.css\n.txt"
#sort - sort extensions so duplicates will be right by each other
#uniq - count them
#sort - now sort by count
#second sed - this one's kinda stupid, i wanted to remove the whitespace that uniq -c creates as it is intended to right justify it's output, but the example output in the github showed that you (Teacher) don't have the whitespaes, so this regex will remove the whitespaces
#head - show first 5
echo "EXTENSIONS:"
echo "$extensionCount"

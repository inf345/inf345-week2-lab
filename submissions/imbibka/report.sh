#!/usr/bin/env python3

import os
import sys
from collections import Counter
from pathlib import Path

if len(sys.argv) != 2:
    sys.stderr.write("usage: report.sh DIRECTORY\n")
    sys.exit(1)

root = Path(sys.argv[1]).resolve()
if not root.is_dir():
    sys.stderr.write("not a directory\n")
    sys.exit(1)

files = []
dirs = []
for dirpath, dirnames, filenames in os.walk(root):
    base = Path(dirpath)
    for d in dirnames:
        dirs.append(base / d)
    for name in filenames:
        p = base / name
        if p.is_file() and not p.is_symlink():
            files.append(p)
        elif p.is_file():
            files.append(p)

# follow the same idea as find -type f / -type d
files = [p for p in root.rglob("*") if p.is_file()]
dirs = [p for p in root.rglob("*") if p.is_dir()]

print(f"FILES: {len(files)}")
print(f"DIRS: {len(dirs)}")

print("LARGEST:")
sized = []
for p in files:
    try:
        sized.append((p.stat().st_size, p.relative_to(root).as_posix()))
    except OSError:
        continue
sized.sort(key=lambda x: (-x[0], x[1]))
for size, path in sized[:3]:
    print(f"{size} {path}")

print("EXECUTABLE:")
execs = []
for p in files:
    try:
        if p.stat().st_mode & 0o100:
            execs.append(p.relative_to(root).as_posix())
    except OSError:
        continue
for path in sorted(execs):
    print(path)

print("EXTENSIONS:")
counts = Counter()
for p in files:
    suffix = p.suffix
    if suffix and p.name != suffix:
        counts[suffix] += 1
ranked = sorted(counts.items(), key=lambda kv: (-kv[1], kv[0]))
for ext, n in ranked[:5]:
    print(f"{n} {ext}")
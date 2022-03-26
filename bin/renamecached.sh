#!/bin/bash

# This script adds an extension to files in a chromium cache directory based on file's mime type

cache_dir='$HOME/Applications/privatehome/iridium/.cache/' # TODO: put the correct path
dest_dir='/tmp/chromium_cache'

[ -d "$dest_dir" ] || mkdir "$dest_dir"
for f in "$cache_dir"/*; do
  echo "File: $f"
  offs=$(printf "%d" $(dd if="$f" bs=1 skip=12 count=4 2>/dev/null| \hexdump -e '1/4 "0x%08X" "\n"'))
  dd if="$f" skip=1 bs="$((offs+24))" 2>/dev/null > "$dest_dir"/$(basename "$f")
  ext=$(./mime2ext.py $(file -bi "$dest_dir/$(basename "$f")" | awk -F';' '{print $1}'))
  mv "$dest_dir/$(basename "$f")" "$dest_dir/$(basename "$f").$ext"
done

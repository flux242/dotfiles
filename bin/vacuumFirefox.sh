#!/usr/bin/env bash

[ -n "$(pidof firefox)" ] && {
  echo "ERROR: firefox is still running, close it first!"
  exit 1
}

counterBefore=0
counterAfter=0

for i in ~/.mozilla/firefox/*/*.sqlite; do
  fileSizeBefore=$(du -b "$i"|awk '{ print $1 }')
  counterBefore=$((counterBefore + fileSizeBefore))
  sqlite3 "$i" vacuum
  fileSizeAfter=$(du -b "$i"|awk '{ print $1 }')
  counterAfter=$((counterAfter + fileSizeAfter))
  echo "$fileSizeBefore $fileSizeAfter - $(basename "$i")"
done
echo "Bytes saved: $(( counterBefore - counterAfter ))"

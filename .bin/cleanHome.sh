#!/usr/bin/env bash

# vacuum firefox's sqlite files
vacuumFirefox()
{
  pidof firefox && {
    echo "ERROR: firefox is still running, close it first!"
    return 1
  }
  which sqlite3 &>/dev/null || {
    echo "ERROR: sqlite3 is not installed. Do 'sudo apt-get install sqlite3' first"
    return 1
  }

  local counterBefore=0
  local counterAfter=0
  local fileSizeBefore fileSizeAfter

  for i in "$HOME"/.mozilla/firefox/*/*.sqlite; do
    fileSizeBefore=$(wc -c < "$i")
    counterBefore=$((counterBefore + fileSizeBefore))
    sqlite3 "$i" vacuum
    fileSizeAfter=$(wc -c < "$i")
    counterAfter=$((counterAfter + fileSizeAfter))
    echo "$fileSizeBefore $fileSizeAfter - $(basename "$i")"
  done
  echo "Firefox Bytes saved: $(( counterBefore - counterAfter ))"
  return 0
}

homeSizeBefore=$(du -sb "$HOME" 2>/dev/null|awk '{ print $1 }')
# cleaning phase
vacuumFirefox || exit 1
cd "$HOME"
xargs -d \\n -I {} bash -c "shopt -s dotglob;echo 'Cleaning $HOME/{}';eval '/bin/rm -rf $HOME/{}'" <<EOLIST
.thumbnails/*
.cache/*
.adobe/Flash_Player/AssetCache/*
.mozilla/firefox/*/Cache/*
.mozilla/firefox/*/minidumps
.mozilla/firefox/*/datareporting
.mozilla/firefox/*/saved-telemetry-pings
.mozilla/firefox/*/healthreport*
.mozilla/firefox/Crash\ Reports/
.mozilla/firefox/*/crashes
.mozilla/firefox/*/storage/*
.mozilla/firefox/*/adblockplus/patterns-backup*
.mozilla/firefox/*/weave/logs/
.davfs2/cache/*
.config/sublime-text-3/Cache/*
EOLIST
#.local/share/Trash/*

homeSizeAfter=$(du -sb "$HOME" 2>/dev/null|awk '{ print $1 }')

echo "Home total bytes saved: $(( homeSizeBefore - homeSizeAfter ))"


#!/bin/bash


[ "${1##*.}" = "AppImage" ] || exit 1
[ -n "$2" ] || exit 2 # mounting point should be specified
if [ -x "$1" ] && $1 --appimage-offset 2>/dev/null; then
  # non executable type 2 appimages won't be mounted
  squashfuse -o offset=$($1 --appimage-offset) $1 $2
else
  # type 1 appimage https://github.com/AppImage/AppImageKit/wiki/FUSE
  fuseiso $1 $2
fi

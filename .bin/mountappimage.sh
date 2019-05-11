#!/bin/bash

[ "${1##*.}" = "AppImage" ] || exit 1
[ -n "$2" ] || exit 2
squashfuse -o offset=$($1 --appimage-offset) $1 $2

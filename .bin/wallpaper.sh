#!/usr/bin/env bash

#local wname warr TIFS
wdir=${1:-~/wallpapers}
[[ -d "$wdir" ]] || wdir=/usr/share/xfce4/backdrops/
TIFS=$IFS;IFS=$'\n';warr=( $(ls "$wdir") );IFS=$TIFS
wname=$(/usr/bin/yad --entry --title "Available wallpapers" --text "Choose wallpaper image" --entry-text "${warr[@]}" 2>/dev/null)
[[ -n "$wname" ]] && feh --bg-scale "$(find "${wdir}" -iname "$wname"|shuf|head -n1)"

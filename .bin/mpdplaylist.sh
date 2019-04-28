#!/usr/bin/env bash

[[ -z "$(which yad)" ]] && {
  echo "Error: yad is not installed" >&2
  exit 1
}

[[ -n "$MPDSERVER" ]] || source "$HOME/.bash_aliases" # for mpdserver var
declare -f -F mpc > /dev/null || source "$HOME/bin/shellfunctions.sh"   # for mpc function

playlists=$(mpc listplaylists|awk -F"playlist: " '{if($2!=""){print $2}}')
pl=$(/usr/bin/yad --entry --title "Playlists" --text "Choose playlist to play" --entry-text ${playlists[@]} 2>/dev/null)

[[ -n "$pl" ]] && {
  mpc clear &>/dev/null
  mpc load "$pl"
  mpc shuffle &>/dev/null
  mpc play &>/dev/null
}


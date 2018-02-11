#!/bin/bash

border=$(i3-msg -t get_tree |awk -F"id\":" -v id=$(xprop -root|awk '/_NET_ACTIVE_WINDOW\(WINDOW\)/{print strtonum($NF)}') '{for(i=1;i<=NF;++i){if (match($i,id)){print gensub(/.*border.:.([^"]*).*/,"\\1","g",$i)}}}')
if [ "$border" = "pixel" ]; then
  i3-msg border normal
else
  i3-msg border pixel 2
fi


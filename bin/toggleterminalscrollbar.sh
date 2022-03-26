#!/usr/bin/env bash

configFile=~/.config/xfce4/terminal/terminalrc
keyword=ScrollingBar


result=$(awk -v incr=$step -v kw=$keyword -F= '
{
  if ($0 ~ kw) { 
    print $2;
  }
}' $configFile)

if [[ "$result" = "TERMINAL_SCROLLBAR_NONE" ]]; then
  result="${keyword}=TERMINAL_SCROLLBAR_RIGHT"
else
  result="${keyword}=TERMINAL_SCROLLBAR_NONE"
fi

[[ -n "$result" ]] && {
  sed -i "s/^$keyword.*/$result/" $configFile
}
 

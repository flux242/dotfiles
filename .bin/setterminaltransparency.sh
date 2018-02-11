#!/usr/bin/env bash

configFile=~/.config/xfce4/terminal/terminalrc
keyword=BackgroundDarkness


if [[ "$1" = "up" ]]; then
  step=-0.1
elif [[ "$1" = "down" ]]; then
  step=0.1
else
  exit -1
fi

result=$(awk -v incr=$step -v kw=$keyword -F= '
{
  if ( $0 ~ kw) { 
    val=$2+incr;
    if(val<0.0){val=0.0};
    if(val>1.0){val=1.0};
    print $1"="val;
  }
}' $configFile)

[[ -n $result ]] && {
  sed -i "s/^$keyword.*/$result/" $configFile
}
 

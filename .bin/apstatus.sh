#!/bin/bash

set -o pipefail
iface=${1:-wlan0}
r=$(/sbin/iwconfig "$iface" 2>/dev/null|awk '/ESSID:/{split($0,a,/\"/);print a[2]};
                        /Frequency:/{split($0,a,/Frequency:/);split(a[2],a,/\ /);print a[1]};
                        /Link\ Quality/ {split($2,a,/=/);print a[2]}')
[[ $? -ne 0 ]] && exit 1

IFS=$'\n'
res=($r)

# Link quality is shown in percent but to avoid status 
# line jumping it's multiplied by 99 and not by 100
case $2 in 
  -n) echo -e "${res[0]}" ;;
  -f) echo -e "${res[1]} GHz" ;;
  -s) echo -e "$((99*${res[2]}))" ;;
   *) echo -e "${res[0]} [$((99*${res[2]}))] ${res[1]} GHz" ;;
esac


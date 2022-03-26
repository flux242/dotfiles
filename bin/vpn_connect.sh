#!/usr/bin/env bash

[[ -z "$(which yad)" ]] && {
  echo "Error: yad is not installed" >&2
  exit 1
}

IFS=$'\n'
vpns=$(nmcli -t -f name,type connection show | awk -F: '($2 ~ "vpn") {print $1}')
activevpns=$(nmcli -t -f name,type connection show --active | awk -F: '($2 ~ "vpn") {print $1}')
activevpnarray=( )

for avpn in $activevpns; do
  activevpnarray+=("disconnect $avpn")
  filteredvpns=( )
  for vpn in ${vpns[@]}; do
    [[ ! "$vpn" = "$avpn" ]] && filteredvpns+=("$vpn")
  done
  vpns=("${filteredvpns[@]}")
done
vpns=( ${activevpnarray[@]} ${vpns[@]} ) 

vpn=$(/usr/bin/yad --entry --title "Available VPNs" --text "Choose VPN to activate" --entry-text "${vpns[@]}")
[ -z "$vpn" ] && exit 1

# is that a disconnection request?
for avpn in $activevpns; do
  [[ "$vpn" =~ "$avpn" ]] && {
    nmcli connection down "$avpn"
    exit 0
  }
done

nmcli connection up "$vpn"


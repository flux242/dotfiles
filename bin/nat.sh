#!/usr/bin/env bash

profile_id=nat_forwarder
#profile_id=static
dhcp_min=100
dhcp_max=150
out_iface=wlan0

mac_addr=$(nmcli con list id "$profile_id" | sed -nr 's/.*\.mac-address:[^0-9]+(.*)/\1/p')
iface=$(ifconfig | grep -i "$mac_addr" | cut -d\  -f 1)
ifaceip=$(nmcli con list id "$profile_id" | sed -nr 's/^ipv4[^=]*= ([^\/]*).*/\1/p')

[ -z "$ifaceip" -o -z "$mac_addr" ] && {
  echo -e "Error getting data from Profile $profile_id\nmac: $mac_addr\niface: $iface\nifaceip: $ifaceip"
  exit 1
}

subnet=$(echo "$ifaceip"|sed -nr 's/(.*)[^\.]+$/\1/p')

echo -e "mac: $mac_addr\niface: $iface\nifaceip: $ifaceip\nsubnet: $subnet"

killall dnsmasq
dnsmasq -i "$iface" --dhcp-range="$iface,$subnet$dhcp_min,$subnet$dhcp_max,24h"
nmcli con up id "$profile_id"

# delete old configuration, if any
#Flush all the rules in filter and nat tables
iptables --flush              
iptables --table nat --flush
          
# delete all chains that are not in default filter and nat table, if any
iptables --delete-chain     
iptables --table nat --delete-chain

# Set up IP FORWARDing and Masquerading (NAT)
iptables -t nat -A POSTROUTING -o "$out_iface" -j MASQUERADE
iptables -A FORWARD -i "$iface" -j ACCEPT

#iptables --table nat --append POSTROUTING --out-interface wlan0 -j MASQUERADE
#iptables --append FORWARD --in-interface "$iface" -j ACCEPT
#iptables -t nat -A POSTROUTING -o wlan0 -j MASQUERADE
#iptables -A FORWARD -i wlan0 -o eth0 -m state --state RELATED,ESTABLISHED -j ACCEPT
#iptables -A FORWARD -i eth0 -o wlan0 -j ACCEPT

echo 1 > /proc/sys/net/ipv4/ip_forward


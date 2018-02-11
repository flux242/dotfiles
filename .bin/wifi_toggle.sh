#!/usr/bin/env bash

wifistat=$(nmcli radio wifi)
if [ "disabled" = "${wifistat#*\ }" ]; then
  nmcli radio wifi on
  wifistat=$(nmcli radio wifi)
  notify-send -u low -i /usr/share/icons/elementary-xfce/status/48/wifi-100.png "WiFi status:" "WiFi is now ${wifistat#*\ }"
else
  nmcli radio wifi off
  wifistat=$(nmcli radio wifi)
  notify-send -u low -i /usr/share/icons/elementary-xfce/status/48/wifi-100.png "WiFi status:" "WiFi is now ${wifistat#*\ }"
fi

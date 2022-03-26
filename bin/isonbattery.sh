#!/bin/sh

# This script exits with the status 0 if running on battery, and
# with 1 otherwise. 

for i in /sys/class/power_supply/*; do
  [ -e "$i/online" ] && [ "1" = "$(cat $i/online)" ] && exit 1
done
exit 0


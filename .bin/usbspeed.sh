#!/bin/bash

# this script works with the usbmon from https://github.com/swetland/usbmon 
# not sure if it outputs correct numbers
# also check https://www.kernel.org/doc/html/latest/usb/usbmon.html
# To make it work:
# sudo modprobe usbmon
# chown $USER /dev/usbmon0
# usbspeed.sh

COUNTER=0;
# first get USB devices
IFS=$'\n'
USBDEVICES=$( lsusb | grep -v "0000:0000" | grep -iv "hub" )
if [[ -n "$(which zenity)" ]]; then
  CHOOSED_DEVICE=$(zenity --list  --width=700 --height=500 --title "Connected USB devices" --column="Devices" ${USBDEVICES[@]})
else
  CHOOSED_DEVICE=$(yad --list  --width=700 --height=500 --title "Connected USB devices" --column="Devices" ${USBDEVICES[@]})
fi
unset IFS

echo ${CHOOSED_DEVICE} 
echo ${CHOOSED_DEVICE} | cut -d: -f 1 | read 

BUS=`echo ${CHOOSED_DEVICE} | cut -d: -f 1 | cut -d\  -f 2`
DEVICE=`echo ${CHOOSED_DEVICE} | cut -d: -f 1 | cut -d\  -f 4`

let BUS=$BUS+0

echo "Bus: $BUS	Device: $DEVICE"

# create data to pipe
let totalIN=0;
let totalOUT=0;

oldtime=$(date +%s)
usbmon -b${BUS} -d${DEVICE} | grep --line-buffered "C B" | \
while read  devstr symbol status value okstatus; do 
  if [[ "$okstatus" = "OK" ]]; then
    if [[ $status =~ "Bi" ]]; then
      let totalIN=$totalIN+$value
    elif [[ $status =~ "Bo" ]]; then
      let totalOUT=$totalOUT+$value
    else
      #echo "discarded"
      continue;
    fi
  fi
  curtime=$(date +%s)
  [[ $oldtime < $curtime ]] && {
     oldtime=$curtime
     if [ -t 1 ]; then
       printf "\033[sIN: %d	OUT: %d\033[K\033[u" "0x$totalIN" "0x$totalOUT"
     else
       printf "IN: %d	OUT: %d\n" "0x$totalIN" "0x$totalOUT"
     fi
     totalIN=0
     totalOUT=0
  }
done


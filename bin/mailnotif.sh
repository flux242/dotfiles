#!/usr/bin/env bash

#mCount=$(/usr/bin/ssh -o ConnectTimeout=1 root@192.168.1.1 'cat /tmp/newMail' 2>/dev/null)
mCount=$(cat /tmp/newMail 2>/dev/null)
#logger "Count: $mCount" 
[ -n "$mCount" -a "0" != "$mCount" ] && {
  [ -z "$DBUS_SESSION_BUS_ADDRESS" ] && {
#DBUS_SESSION_BUS_ADDRESS=$(awk -F',' 'BEGIN {RS='\0'} /DBUS_SESSION_BUS_ADDRESS/ {print $1}'  /proc/$(pgrep xfsettingsd)/environ)
#export DBUS_SESSION_BUS_ADDRESS
    export "$(tr '\0' '\n' < "/proc/$(pgrep xfsettingsd)/environ"|grep DBUS_SESSION_BUS_ADDRESS)"
#dbus_session_file="${HOME}/.dbus/session-bus/$(cat /var/lib/dbus/machine-id)-0"
#. "$dbus_session_file"
#export DBUS_SESSION_BUS_ADDRESS DBUS_SESSION_BUS_PID
  }
  /usr/bin/dbus-send --dest=org.xfce.Panel.Plugin.Messenger /org/xfce/panel/plugin/messenger org.xfce.Panel.Plugin.Messenger.Message string:"newmail:"
}


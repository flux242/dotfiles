#!/bin/bash
# acpi handler for AC adapter events

compositor="picom"

case "$2" in
  AC*|AD*)
     case "$4" in
       00000000)
           killall -q "$compositor"
       ;;
       00000001)
           /usr/bin/pgrep "^${compositor}" &>/dev/null || {
               pid=$(/usr/bin/pgrep 'xfsettingsd') # pid of some process that is always started
               user=$(/usr/bin/awk 'BEGIN{RS="\x00";FS="="}/(USER)/{print $2}' "/proc/$pid/environ")
               export $(/usr/bin/awk 'BEGIN{RS="\x00"}/(DISPLAY|HOME)/{print $0}' "/proc/$pid/environ")
#               su $user -c '/usr/bin/compton -b'
               sudo -u $user /usr/bin/$compositor -b
           }
       ;;
     esac
     ;;
  *) logger "ACPI action undefined: $2"
     ;;
esac

exit 0

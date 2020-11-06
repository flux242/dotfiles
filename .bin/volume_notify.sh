#!/usr/bin/env bash

# this script is depricated because pulseaudio should be
# used instead of the amixer. Use volume_notify_pa.sh instead

# this script requires python3-notify2 lib to be installed first

# $1 - icon_name, $2 - volume, $3 - id
print_cmd()
{
cat <<HEREDOC
import notify2
notify2.init("volume_notify.py")
notif=notify2.Notification("Volume", "", "$1")
notif.set_hint_int32("value",$2)
notif.id = $3
notif.show()
print(notif.id)
HEREDOC
}

step=5
card=0
id_file="/tmp/notify_volume.id"

#icon_high="/usr/share/icons/elementary-xfce/notifications/48/audio-volume-high.png"
#icon_low="/usr/share/icons/elementary-xfce/notifications/48/audio-volume-low.png"
#icon_medium="/usr/share/icons/elementary-xfce/notifications/48/audio-volume-medium.png"
#icon_muted="/usr/share/icons/elementary-xfce/notifications/48/audio-volume-muted.png"
#icon_off="/usr/share/icons/elementary-xfce/notifications/48/audio-volume-off.png"
icon_high="audio-volume-high"
icon_low="audio-volume-low"
icon_medium="audio-volume-medium"
icon_muted="audio-volume-muted"
icon_off="audio-volume-off"

case $1 in 
  up)
      amixer -q -c $card set Master $step+ ;;
  down)
      amixer -q -c $card set Master $step- ;;
  toggle)
      #pactl list sinks|grep -q Mute:.yes;pactl set-sink-mute 0 ${PIPESTATUS[1]} ;;
      # amixer needs -D pulse switch as a workaround for the pulseaudio
      # check http://goo.gl/4z4U6R
      amixer -q -D pulse set Master toggle ;;
  *)
      echo "Usage: $0 up/down/toggle"
      exit 1 ;;
esac


#muted=$(amixer get Master | tail -n1 | sed -nr 's/.*\[([a-z]+)\].*/\1/p')
#volume=$(amixer get Master | tail -n1 | sed -nr 's/[^\[]*.([^%]*).*/\1/p')
val=$(amixer -c $card get Master | tail -n1 | sed -nr 'h;s/[^\[]*.([^%]*).*/\1/p;g;s/.*\[([a-z]+)\].*/\1/p')
muted=${val#*$'\n'}
volume=${val%$'\n'*}
if ((volume==0)); then
  icon=$icon_off
elif ((volume<34)); then
  icon=$icon_low
elif ((volume<67)); then
  icon=$icon_medium
else
  icon=$icon_high
fi
if [[ $muted == "off" ]]; then
  icon=$icon_muted
fi
id=$(cat $id_file 2>/dev/null);id=${id:-0}
#echo $id
idn=$(python3 -c "$(print_cmd "$icon" "$volume" "$id")")
(("$idn" != "$id")) && echo "$idn" > "$id_file"
exit 0


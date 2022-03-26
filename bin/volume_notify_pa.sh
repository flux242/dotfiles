#!/bin/bash

# this script requires python3-notify2 lib to be installed first

STEP='5%'

# some sound cards could have different MIN/MAX values 
# this isn't implemented yet as I can't test it
MIN_VOLUME=0
MAX_VOLUME=65536

# file where notification ids are stored
ID_FILE="/tmp/notify_volume.id"

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

# input parameters are: $1 - volume, $3 - muted status
send_notification() {
  local icon id idn
  local volume_raw=$1
  local muted=$2

  local volume=$(( (100*(volume_raw-MIN_VOLUME))/(MAX_VOLUME-MIN_VOLUME) ))

  if ((volume==0)); then
    icon=$icon_off
  elif ((volume<34)); then
    icon=$icon_low
  elif ((volume<67)); then
    icon=$icon_medium
  else
    icon=$icon_high
  fi
  if [[ "$muted" == "yes" ]]; then
    icon=$icon_muted
  fi
  id=$(cat $ID_FILE 2>/dev/null);id=${id:-0}
  idn=$(python3 -c "$(print_cmd "$icon" "$volume" "$id")")
  (("$idn" != "$id")) && echo "$idn" > "$ID_FILE"
}

get_volume() {
  local VOLHEX=$(pacmd dump | awk '/^set-sink-volume/{printf("%s", $3)}')
  [ -n "$VOLHEX" ] || {
    echo "$MIN_VOLUME"
    return
  }
  printf '%d' $VOLHEX
}

# returns 'yes' or 'no'
get_muted() {
    MUTED=$(pacmd dump | awk '/set-sink-mute/{print $3}')
    printf "%s" "$MUTED" 
}


icon_high="audio-volume-high"
icon_low="audio-volume-low"
icon_medium="audio-volume-medium"
icon_muted="audio-volume-muted"
icon_off="audio-volume-off"

SINK=$(pactl info | awk '/Default Sink/{print $3}')
[ -n "$SINK" ] || exit 1

case $1 in
  up)
      pactl set-sink-volume  "$SINK" "+$STEP"
      [ "$(get_volume)" -gt $MAX_VOLUME ] && pactl set-sink-volume  "$SINK" "$MAX_VOLUME"        
      ;;
  down)
      pactl set-sink-volume  "$SINK" "-$STEP"
      [ "$(get_volume)" -le $MIN_VOLUME ] && pactl set-sink-volume  "$SINK" "$MIN_VOLUME"        
      ;;
  toggle)
      MUTED=$(pacmd dump | awk '/set-sink-mute/{print $3}')
      if [ "yes" = "$MUTED" ]; then
        pactl set-sink-mute "$SINK" 0
      else
        pactl set-sink-mute "$SINK" 1
      fi
      ;;
  *)
      echo "Usage: $0 up/down/toggle"
      exit 1 ;;
esac

send_notification "$(get_volume)" "$(get_muted)"

exit 0

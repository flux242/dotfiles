#!/usr/bin/env bash

[ -z "$1" ] && {
  echo "Usage: $0 tmp_channel_file_created_by_irclogbot_script"
  exit 1
}
channel=#$(echo "$1"|sed -nr 's/.*_(.*)/\1/p')
user=$(echo "$1"|sed -nr 's/[^_]*_(.*)_.*/\1/p')

while read -erp "$channel> " message; do
  [ -n "$message" ] && {
    case "$message" in
      /*) echo "${message:1}" >> "$1" ;;
       *) echo "PRIVMSG $channel,$user :$message" >> "$1" ;;
    esac
  }
done


#!/usr/bin/env bash

[ -z "$1" ] && {
  echo "Usage: $0 tmp_channel_file_created_by_irclogbot_script"
  exit 1
}
channel=$(awk '/JOIN/{printf("%s",$2)}' "$1")
user=$(awk '/USER/{printf("%s",$2)}' "$1")

while read -erp "$channel> " message; do
  [ -n "$message" ] && {
    case "$message" in
  /join*) channel="${message#* }"; echo "${message:1}" >> "$1" ;;
      /*) echo "${message:1}" >> "$1" ;;
       *) echo "PRIVMSG $channel :$message" >> "$1" ;;
    esac
  }
done


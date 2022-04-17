#!/usr/bin/env bash

historyfile="$HOME/.ircsendhistory"
channelsfile="$HOME/.ircchannels"

HISTFILE="$historyfile"
HISTCONTROL=ignoreboth

[ -z "$1" ] && {
  echo "Usage: $0 tmp_channel_file_created_by_irclogbot_script"
  exit 1
}
channel=$(awk '/JOIN/{printf("%s",$2);exit(0)}' "$1")
nick=$(awk '/USER/{printf("%s",$2);exit(0)}' "$1")

echo "CAP REQ :echo-message" >> "$1"
cat "$channelsfile" | while read channel; do
  [[ "$channel" =~ ^#[^[:space:]]+ ]] && {
    printf "JOIN $channel\n" >> "$1"
  }
done

history -r
while read -erp "$channel> " message; do
  [ -n "$message" ] && {
    case "$message" in
      /nick*) nick="${message#* }"; echo "${message:1}" >> "$1" ;;
      /ident*) nickpass="${message#* }"; echo "PRIVMSG NickServ :IDENTIFY $nickpass" >> "$1" ;;
      /join*) grep -qoP '\s+\K(#[^\s]+)$' <<< "$message" && channel="${message##* }" && sed -i "/$channel/d" "$channelsfile" && echo "$channel" >> "$channelsfile" && echo "${message:1}" >> "$1" ;;
      /part*) grep -qoP '\s+\K(#[^\s]+)$' <<< "$message" && channel="${message##* }" && sed -i "/$channel/d" "$channelsfile" && echo "${message:1}" >> "$1" ;; 
      /whoami*) echo "whois $nick" >> "$1" ;;
      /msg*) msg="${message#* }";name="${msg%% *}";rest="${msg#* }";echo "PRIVMSG $name :$rest" >> "$1" ;;
      /me*) printf "PRIVMSG $channel :\x01ACTION ${message#* }\x01\n" >> "$1" ;;
      /*) echo "${message:1}" >> "$1" ;;
       *) echo "PRIVMSG $channel :$message" >> "$1" ;;
    esac
  }

  history -s "$message"; history -w;
done


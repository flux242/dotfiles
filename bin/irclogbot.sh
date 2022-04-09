#!/bin/sh 

nick="blb$$"
channel=testchannel
server=irc.libera.chat
port=6667
config=/tmp/irclog

[ "$1" = "-r" ] && outputraw=1 && shift
[ -n "$1" ] && channel=$1
[ -n "$2" ] && server=$2
config="${config}_${nick}_${channel}"

# colorize output.
ec='echo -e'; [ -n "$($ec)" ] && ec='echo'
WB=$($ec "\033[1m")
GR=$($ec "\033[1;32m")
LR=$($ec "\033[1;31m")
NC=$($ec "\033[0m")

echo "NICK $nick" > "$config"
echo "USER $nick +i * :$(basename $0)" >> "$config"
echo "CAP REQ :echo-message" >> "$config"
echo "JOIN #$channel" >> "$config"

trap 'rm -f $config;exit 0' INT TERM EXIT

tail -f "$config" | nc "$server" "$port" | while read -r MESSAGE
do
  case "$MESSAGE" in
    PING*) echo "PONG${MESSAGE#PING}" >> "$config" ;;
    *QUIT*) ;;
    *PART*) ;;
    *JOIN*) ;;
    *NICK*) ;;
    *PRIVMSG*) if [ -n "$outputraw" ];then echo "${MESSAGE}";else echo "${MESSAGE}" | sed -nr "s/^:([^!]+).*PRIVMSG([^:]+):(.*)/$WB\[$(date '+%Y\/%m\/%d %R')\]$LR\2$GR\1$NC$WB> $NC\3/p";fi ;;
    *) echo "${MESSAGE}" ;;
  esac
done 


#!/bin/sh 

nick="blb$$"
channel=testchannel
server=irc.freenode.net
config=/tmp/irclog

[ -n "$1" ] && channel=$1
[ -n "$2" ] && server=$2
config="${config}_${nick}_${channel}"

# colorize output if stdout is connected to a terminal
[ -t 1 ] && {
  ec='echo -e'; [ -n "$($ec)" ] && ec='echo'
  WB=$($ec "\033[1m")
  GREEN=$($ec "\033[1;32m")
  NORM=$($ec "\033[0m")
}

echo "NICK $nick" > "$config"
echo "USER $nick +i * :$0" >> "$config"
echo "JOIN #$channel" >> "$config"

trap 'rm -f $config;exit 0' INT TERM EXIT

tail -f "$config" | nc "$server" 6667 | while read MESSAGE
do
  case "$MESSAGE" in
    PING*) echo "PONG${MESSAGE#PING}" >> "$config" ;;
    *QUIT*) ;;
    *PART*) ;;
    *JOIN*) ;;
    *NICK*) ;;
    *PRIVMSG*) echo "${MESSAGE}" | sed -nr "s/^:([^!]+).*PRIVMSG[^:]+:(.*)/$WB[$(date '+%R')] $GREEN\1> $NORM\2/p" ;;
    *) echo "${MESSAGE}" ;;
  esac
done 


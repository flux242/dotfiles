#!/bin/sh 

nick="blb$$"
channel=testchannel
server=irc.freenode.net
config=/tmp/irclog

[ "$1" = "-r" ] && outputraw=1 && shift
[ -n "$1" ] && channel=$1
[ -n "$2" ] && server=$2
config="${config}_${nick}_${channel}"

# colorize output.
ec='echo -e'; [ -n "$($ec)" ] && ec='echo'
WB=$($ec "\033[1m")
GR=$($ec "\033[1;32m")
NC=$($ec "\033[0m")

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
    *PRIVMSG*) if [ -n "$outputraw" ];then echo "${MESSAGE}";else echo "${MESSAGE}" | sed -nr "s/^:([^!]+).*PRIVMSG[^:]+:(.*)/$WB\[$(date '+%Y\/%m\/%d %R')\] $GR\1$NC$WB> $NC\2/p";fi ;;
    *) echo "${MESSAGE}" ;;
  esac
done 


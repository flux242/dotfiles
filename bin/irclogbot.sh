#!/bin/sh 

rc()
{
  local RANDOM
  RANDOM=$(od -A n -t d -N 1 /dev/urandom)
  printf \\$(printf "%o\n" $((97+RANDOM%26)))
}
#nick="blb$$"
nick="$(rc;rc;rc;rc;rc;rc)"
#nick="blb$$"
channel=mytestchannel
server=irc.libera.chat
port=6667
config=/tmp/irclog

[ "$1" = "-r" ] && outputraw=1 && shift
[ -n "$2" ] && channel=$2
[ -n "$1" ] && server=$1
config="${config}_${nick}_${channel}"

# colorize output.
ec='echo -e'; [ -n "$($ec)" ] && ec='echo'
WB=$($ec "\033[1m")
GR=$($ec "\033[1;32m")
LR=$($ec "\033[1;31m")
NC=$($ec "\033[0m")

echo "NICK $nick" > "$config"
echo "USER $nick +i * :$(basename $0)" >> "$config"
echo "JOIN #$channel" >> "$config"

trap 'rm -f $config;exit 0' INT TERM EXIT

tail -f "$config" | nc "$server" "$port" | while read MESSAGE
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


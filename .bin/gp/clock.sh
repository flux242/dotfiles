#!/usr/bin/env bash

# Usage example: 
# bin/gp/clock.sh|bin/gp/gnuplotblock.sh ":;5:11" ";points pointtype 5 pointsize 5;blue;xy"

dx=1
dy=1

digits=( 0xf9 0x99 0xf0 0x11 0x11 0x10 \
         0xf1 0xf8 0xf0 0xf1 0xf1 0xf0 \
         0x99 0xf1 0x10 0xf8 0xf1 0xf0 \
         0xf8 0xf9 0xf0 0xf1 0x11 0x10 \
         0xf9 0xf9 0xf0 0xf9 0xf1 0xf0 )
         

function plot_digit_nibble
{
  local nibble=$1
  local i=8
  local x=$2
  local y=$3
  
  nibble=$((nibble & 15))
  [[ $nibble == 0 ]] && return;
 
  while [[ $i != 0 ]]; do 
    (( (nibble & i) > 0 )) && {
      echo "$x $y"
    }
    x=$((x+dx))
    i=$((i>>1))
  done
}

function plot_digit
{
  local digit=$(($1%10))
  local index=$((digit*3)) # 3 bytes per digit
  local x=$2
  local y=$3
  local i

  for((i=0;i<3;++i)); do 
    plot_digit_nibble $((digits[index+i] >> 4)) "$x" "$y"
    y=$((y-dy))
    plot_digit_nibble $((digits[index+i] & 15)) "$x" "$y"
    y=$((y-dy))
  done
}

IFS=$':'
while true; do
  date=$(date "+%H:%M:%S")
  date_arr=( $date  )

  plot_digit $((${date_arr[0]#0}/10)) 10 10
  plot_digit $((${date_arr[0]#0}%10)) 15 10

  plot_digit $((${date_arr[1]#0}/10)) 23 10
  plot_digit $((${date_arr[1]#0}%10)) 28 10

  plot_digit $((${date_arr[2]#0}/10)) 36 10
  plot_digit $((${date_arr[2]#0}%10)) 41 10
 
  echo
  sleep 1
done


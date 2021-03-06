#!/usr/bin/env bash

# Usage example: 
#
# ./clock2.sh|bin/gp/gnuplotblock.sh ":;0:12" ";points pointtype 7 pointsize 5;blue;xy"
# ~/bin/gp/clock2.sh|GNUPLOT_TERM='sixelgd animate transparent size 1045,255' ~/bin/gp/gnuplotblock.sh "-1:;0:12" ";points pointtype 7 pointsize 3;white;xy"

dx=1
dy=1
lpd=10 # lines per digit

digits=( \
0x38 0x6c 0xc6 0xc6 0xd6 0xd6 0xc6 0xc6 0x6c 0x38 \
0x18 0x38 0x78 0x18 0x18 0x18 0x18 0x18 0x18 0x7e \
0x7c 0xc6 0x06 0x0c 0x18 0x30 0x60 0xc0 0xc6 0xfe \
0x7c 0xc6 0x06 0x06 0x3c 0x06 0x06 0x06 0xc6 0x7c \
0x0c 0x1c 0x3c 0x6c 0xcc 0xfe 0x0c 0x0c 0x0c 0x1e \
0xfe 0xc0 0xc0 0xc0 0xfc 0x06 0x06 0x06 0xc6 0x7c \
0x38 0x60 0xc0 0xc0 0xfc 0xc6 0xc6 0xc6 0xc6 0x7c \
0xfe 0xc6 0x06 0x06 0x0c 0x18 0x30 0x30 0x30 0x30 \
0x7c 0xc6 0xc6 0xc6 0x7c 0xc6 0xc6 0xc6 0xc6 0x7c \
0x7c 0xc6 0xc6 0xc6 0x7e 0x06 0x06 0x06 0x0c 0x78 \
)


function plot_digit_line
{
  local nibble=$1
  local i=128
  local x=$2
  local y=$3
#echo "$nibble"  
  nibble=$((nibble & 255))
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
  local index=$((digit*lpd))
  local x=$2
  local y=$3
  local i

  for((i=0;i<lpd;++i)); do 
    plot_digit_line $((digits[index+i])) "$x" "$y"
    y=$((y-dy))
  done
}

IFS=$':'
while true; do
  date=$(date "+%H:%M:%S")
  date_arr=( $date  )

  plot_digit $((${date_arr[0]#0}/10)) 0 10
  plot_digit $((${date_arr[0]#0}%10)) 9 10

  plot_digit $((${date_arr[1]#0}/10)) 20 10
  plot_digit $((${date_arr[1]#0}%10)) 29 10

  plot_digit $((${date_arr[2]#0}/10)) 40 10
  plot_digit $((${date_arr[2]#0}%10)) 49 10
 
  echo
  sleep 1
done


#!/bin/bash

function zpk3D
{
  local m=$1
  local ban=$2
  local xsign=$3
  local ysign=$4
  local zsign=$5

  case "$ban" in
   1)
    (( m > 2 )) && zpk3D $((m/2))  6  $((-xsign))  $((-ysign))  "$zsign";
    echo "$X $Y $Z"
    Z=$((Z+zsign));
    (( m > 2 )) && zpk3D $((m/2)) 3  "$xsign"  "$ysign"  "$zsign"
    echo "$X $Y $Z"
    X=$((X+xsign));
    (( m > 2 )) && zpk3D $((m/2)) 3  "$xsign"  "$ysign"  "$zsign"
    echo "$X $Y $Z"
    Z=$((Z-zsign));
    (( m > 2 )) && zpk3D $((m/2)) 5  $((-xsign))  "$ysign"  $((-zsign))
    echo "$X $Y $Z"
    Y=$((Y+ysign));
    (( m > 2 )) && zpk3D $((m/2)) 5  $((-xsign))  "$ysign"  $((-zsign))
    echo "$X $Y $Z"
    Z=$((Z+zsign));
    (( m > 2 )) && zpk3D $((m/2)) 3  $((-xsign))  $((-ysign))  "$zsign"
    echo "$X $Y $Z"
    X=$((X-xsign));
    (( m > 2 )) && zpk3D $((m/2)) 3  $((-xsign))  $((-ysign))  "$zsign"
    echo "$X $Y $Z"
    Z=$((Z-zsign));
    (( m > 2 )) && zpk3D $((m/2)) 6  $((-xsign))  "$ysign"  $((-zsign))
    (( m > 2 )) || echo "$X $Y $Z"
    ;;
   2)
    (( m > 2 )) && zpk3D $((m/2)) 5  "$xsign"  "$ysign"  "$zsign"
    echo "$X $Y $Z"
    Y=$((Y+ysign));
    (( m > 2 )) && zpk3D $((m/2)) 4  $((-xsign))  $((-ysign))  "$zsign"
    echo "$X $Y $Z"
    X=$((X+xsign));
    (( m > 2 )) && zpk3D $((m/2)) 4  $((-xsign))  $((-ysign))  "$zsign"
    echo "$X $Y $Z"
    Y=$((Y-ysign));
    (( m > 2 )) && zpk3D $((m/2)) 6  "$xsign"  "$ysign"  "$zsign"
    echo "$X $Y $Z"
    Z=$((Z+zsign));
    (( m > 2 )) && zpk3D $((m/2)) 6  "$xsign"  "$ysign"  "$zsign"
    echo "$X $Y $Z"
    Y=$((Y+ysign));
    (( m > 2 )) && zpk3D $((m/2)) 4  "$xsign"  $((-ysign))  $((-zsign))
    echo "$X $Y $Z"
    X=$((X-xsign));
    (( m > 2 )) && zpk3D $((m/2)) 4  "$xsign"  $((-ysign))  $((-zsign))
    echo "$X $Y $Z"
    Y=$((Y-ysign));
    (( m > 2 )) && zpk3D $((m/2)) 5  "$xsign"  $((-ysign))  $((-zsign))
    (( m > 2 )) || echo "$X $Y $Z"
    ;;
   3)
    (( m > 2 )) && zpk3D $((m/2)) 1  "$xsign"  "$ysign"  "$zsign"
    echo "$X $Y $Z"
    Y=$((Y+ysign));
    (( m > 2 )) && zpk3D $((m/2)) 6  $((-xsign))  $((-ysign))  "$zsign"
    echo "$X $Y $Z"
    Z=$((Z+zsign));
    (( m > 2 )) && zpk3D $((m/2)) 6  $((-xsign))  $((-ysign))  "$zsign"
    echo "$X $Y $Z"
    Y=$((Y-ysign));
    (( m > 2 )) && zpk3D $((m/2)) 4  $((-xsign))  "$ysign"  $((-zsign))
    echo "$X $Y $Z"
    X=$((X+xsign));
    (( m > 2 )) && zpk3D $((m/2)) 4  $((-xsign))  "$ysign"  $((-zsign))
    echo "$X $Y $Z"
    Y=$((Y+ysign));
    (( m > 2 )) && zpk3D $((m/2)) 6  "$xsign"  $((-ysign))  $((-zsign))
    echo "$X $Y $Z"
    Z=$((Z-zsign));
    (( m > 2 )) && zpk3D $((m/2)) 6  "$xsign"  $((-ysign))  $((-zsign))
    echo "$X $Y $Z"
    Y=$((Y-ysign));
    (( m > 2 )) && zpk3D $((m/2)) 1  $((-xsign))  $((-ysign))  "$zsign"
    (( m > 2 )) || echo "$X $Y $Z"
    ;;
   4)
    (( m > 2 )) && zpk3D $((m/2)) 2  $((-xsign))  $((-ysign))  "$zsign"
    echo "$X $Y $Z"
    Z=$((Z+zsign));
    (( m > 2 )) && zpk3D $((m/2)) 5  $((-xsign))  $((-ysign))  "$zsign"
    echo "$X $Y $Z"
    Y=$((Y-ysign));
    (( m > 2 )) && zpk3D $((m/2)) 5  $((-xsign))  $((-ysign))  "$zsign"
    echo "$X $Y $Z"
    Z=$((Z-zsign));
    (( m > 2 )) && zpk3D $((m/2)) 3  $((-xsign))  "$ysign"  $((-zsign))
    echo "$X $Y $Z"
    X=$((X-xsign));
    (( m > 2 )) && zpk3D $((m/2)) 3  $((-xsign))  "$ysign"  $((-zsign))
    echo "$X $Y $Z"
    Z=$((Z+zsign));
    (( m > 2 )) && zpk3D $((m/2)) 5  "$xsign"  "$ysign"  "$zsign"
    echo "$X $Y $Z"
    Y=$((Y+ysign));
    (( m > 2 )) && zpk3D $((m/2)) 5  "$xsign"  "$ysign"  "$zsign"
    echo "$X $Y $Z"
    Z=$((Z-zsign));
    (( m > 2 )) && zpk3D $((m/2)) 2  "$xsign"  $((-ysign))  $((-zsign))
    (( m > 2 )) || echo "$X $Y $Z"
    ;;
   5)
    (( m > 2 )) && zpk3D $((m/2)) 4  $((-xsign))  $((-ysign))  "$zsign"
    echo "$X $Y $Z"
    X=$((X+xsign));
    (( m > 2 )) && zpk3D $((m/2)) 2  "$xsign"  "$ysign"  "$zsign"
    echo "$X $Y $Z"
    Z=$((Z+zsign));
    (( m > 2 )) && zpk3D $((m/2)) 2  "$xsign"  "$ysign"  "$zsign"
    echo "$X $Y $Z"
    X=$((X-xsign));
    (( m > 2 )) && zpk3D $((m/2)) 1  $((-xsign))  "$ysign"  $((-zsign))
    echo "$X $Y $Z"
    Y=$((Y+ysign));
    (( m > 2 )) && zpk3D $((m/2)) 1  $((-xsign))  "$ysign"  $((-zsign))
    echo "$X $Y $Z"
    X=$((X+xsign));
    (( m > 2 )) && zpk3D $((m/2)) 2  "$xsign"  $((-ysign))  $((-zsign))
    echo "$X $Y $Z"
    Z=$((Z-zsign));
    (( m > 2 )) && zpk3D $((m/2)) 2  "$xsign"  $((-ysign))  $((-zsign))
    echo "$X $Y $Z"
    X=$((X-xsign));
    (( m > 2 )) && zpk3D $((m/2)) 4  "$xsign"  "$ysign"  "$zsign"
    (( m > 2 )) || echo "$X $Y $Z"
    ;;
   6)
    (( m > 2 )) && zpk3D $((m/2)) 3  $((-xsign))  $((-ysign))  "$zsign"
    echo "$X $Y $Z"
    X=$((X-xsign));
    (( m > 2 )) && zpk3D $((m/2)) 1  $((-xsign))  $((-ysign))  "$zsign"
    echo "$X $Y $Z"
    Y=$((Y-ysign));
    (( m > 2 )) && zpk3D $((m/2)) 1  $((-xsign))  $((-ysign))  "$zsign"
    echo "$X $Y $Z"
    X=$((X+xsign));
    (( m > 2 )) && zpk3D $((m/2)) 2  "$xsign"  "$ysign"  "$zsign"
    echo "$X $Y $Z"
    Z=$((Z+zsign));
    (( m > 2 )) && zpk3D $((m/2)) 2  "$xsign"  "$ysign"  "$zsign"
    echo "$X $Y $Z"
    X=$((X-xsign));
    (( m > 2 )) && zpk3D $((m/2)) 1  $((-xsign))  "$ysign"  $((-zsign))
    echo "$X $Y $Z"
    Y=$((Y+ysign));
    (( m > 2 )) && zpk3D $((m/2)) 1  $((-xsign))  "$ysign"  $((-zsign))
    echo "$X $Y $Z"
    X=$((X+xsign));
    (( m > 2 )) && zpk3D $((m/2)) 3  "$xsign"  $((-ysign))  $((-zsign))
    (( m > 2 )) || echo "$X $Y $Z"
    ;;
   *) echo "Error: zpk rotation index is wrong: $m" >&2;;
  esac 
}

iteration=${1:-1}

while true; do
  N=$((1<<iteration))
  X=0; Y=0; Z=0;
  zpk3D $N 1  1 1 1 | awk -v N=$((N-1)) '{print $1/N" "$2/N" "$3/N;fflush()}'
  echo
  [[ -n "$2" ]] && exit 0
  while true; do
    read -s -n1 c
    case $c in
      s) [[ "$iteration" -gt 1 ]] && iteration=$((iteration-1));break ;;
      w) [[ "$iteration" -lt 8 ]] && iteration=$((iteration+1));break ;;
      *) echo "$iteration" >&2
    esac
  done
done


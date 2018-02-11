#!/bin/bash

# Usage example: 
# bin/gp/maze.sh 12 12|bin/gp/gnuplotblock.sh "-1.5:23.5;-1.5:23.5" \
#                       ";points pointtype 5 pointsize 3;blue;xy" \
#                       ";points pointtype 5 pointsize 3;red;xy"

rows=${1:-16}
cols=${2:-16}
declare -A M

function generate_maze
{
  local r=0
  local c=0
  local history=( "$r:$c" ) 
  local check; local rc; local ri; local move_dir

  for ((r=0;r<rows;++r)); do
    for ((c=0;c<cols;++c)); do
      M[$r,$c,0]=0
      M[$r,$c,1]=0
      M[$r,$c,2]=0
      M[$r,$c,3]=0
      M[$r,$c,4]=0
    done
  done
  
  r=0; c=0; 
  TIFS=$IFS
  IFS=$':'
  while [ ${#history[@]} -gt 0 ]; do
    M[$r,$c,4]=1
    check=( )
    [[ $c -gt 0 ]] && [[ "${M[$r,$((c-1)),4]}" = "0" ]] && check=( "${check[@]}" "L" )
    [[ $r -gt 0 ]] && [[ ${M[$((r-1)),$c,4]} == 0 ]] && check=( "${check[@]}" "U" )
    [[ $c -lt $((cols-1)) ]] && [[ ${M[$r,$((c+1)),4]} == 0 ]] && check=( "${check[@]}" "R" )
    [[ $r -lt $((rows-1)) ]] && [[ ${M[$((r+1)),$c,4]} == 0 ]] && check=( "${check[@]}" "D" )
    if [[ ${#check[@]} -gt 0 ]]; then
      history=( "${history[@]}" "$r:$c" )
#      ri=$(dd if=/dev/urandom bs=1 count=1 2>/dev/null | hexdump -v -e '/1 "%u\n"' | awk -v len="${#check[@]}" '{print $1%len}')
      ri=$((RANDOM % ${#check[@]}))
      move_dir=${check[$ri]}
      case $move_dir in
        L) M[$r,$c,0]=1;((c--));M[$r,$c,2]=1 ;;
        U) M[$r,$c,1]=1;((r--));M[$r,$c,3]=1 ;;
        R) M[$r,$c,2]=1;((c++));M[$r,$c,0]=1 ;;
        D) M[$r,$c,3]=1;((r++));M[$r,$c,1]=1 ;;
        *) echo "ERROR!!! $move_dir" >&2 ;;
      esac
    else
      rc=${history[${#history[@]}-1]}
      r=${rc%:*};c=${rc#*:}
      unset history[${#history[@]}-1]
    fi 
  done
  IFS=$TIFS

  M[0,0,0]=1
  M[$((rows-1)),$((cols-1)),2]=1
}

generate_maze

x=0; y=0
while true; do
(
  for((r=0;r<rows;++r)); do
    for((c=0;c<cols;++c)); do
      [[ ${M[$r,$c,0]} == 0 ]] && echo "$((r*2)) $((c*2-1))" 
      [[ ${M[$r,$c,1]} == 0 ]] && echo "$((r*2-1)) $((c*2))" 
      [[ ${M[$r,$c,2]} == 0 ]] && echo "$((r*2)) $((c*2+1))" 
      [[ ${M[$r,$c,3]} == 0 ]] && echo "$((r*2+1)) $((c*2))" 
      echo "$((r*2-1)) $((c*2-1))"
      echo "$((r*2-1)) $((c*2+1))"
      echo "$((r*2+1)) $((c*2-1))"
      echo "$((r*2+1)) $((c*2+1))"
    done
  done
) | sort | uniq | awk -v x=$((x*2)) -v y=$((y*2)) '{if(NR==1) print $0" "x " "y;else print $0}'
 
  echo

  read -s -t1 -n1 c
  case $c in
    a) [[ "${M[$x,$y,1]}" = "1" ]] && ((x--)) ;;
    s) [[ "${M[$x,$y,0]}" = "1" ]] && ((y--)) ;;
    d) [[ "${M[$x,$y,3]}" = "1" ]] && ((x++)) ;;
    w) [[ "${M[$x,$y,2]}" = "1" ]] && ((y++)) ;;
  esac
done


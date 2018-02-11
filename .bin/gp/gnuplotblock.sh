#!/usr/bin/env bash

terminal="qt"      # terminal type (x11,wxt,qt)
range=${1:-:;:;:}  # min:max values of displayed ranges.
                   # ":" for +/- infinity. Default ":;:;:"
shift              # the rest are the titles

# titles definitions examples:
# - "Spectrum;1;blue"
# - "Scatter plot;points pointtype 5 pointsize 10;red;xy"
# - "3D plot;2;#903489;3d;32;32"

declare -A styles_def
styles_def=( [0]="filledcurves x1" [1]="boxes" [2]="lines" [3]="points" )
# remove the color adjustment line below to get
# default gnuplot colors for the first six plots
#colors_def=("red" "blue" "green" "yellow" "cyan" "magenta")
#colors=( "${colors_def[@]}" )
colors=(  )

# parsing input plots descriptions
i=0
IFS=$';'
while [ -n "$1" ]; do
  tmparr=( $1 )
  titles[$i]=${tmparr[0]}
  [ -n "${tmparr[1]}" ] || tmparr[1]=0
  styles[$i]=${styles_def[${tmparr[1]}]-${tmparr[1]}}
  [ -n "${styles[$i]}" ] || styles=${styles_def[0]}
  colors[$i]=${tmparr[2]}
  dtype[$i]=${tmparr[3]}
  dtype_arg[$i]=${tmparr[4]}
  dtype_arg2[$i]=${tmparr[5]}
  [ "${dtype[$i]}" = "xy" ] && ((i++))
  ((i++))
  shift
done

tmparr=( $range )
xrange=${tmparr[0]}
yrange=${tmparr[1]}
zrange=${tmparr[2]}
IFS=$'\n'
blocks=0          # blocks counter
(
 echo "set term $terminal noraise"
 echo "set style fill transparent solid 0.5"

 echo "set xrange [$xrange]"
 echo "set yrange [$yrange]"
 echo "set zrange [$zrange]"
 echo "set ticslevel 0"
 echo "set hidden3d"
# uncomment to remove axis, border and ticks
# echo "set tics scale 0;set border 0;set format x '';set format y '';set format z ''"
 [[ "${dtype[0]}" != "xyz" ]] && [[ "${dtype[0]}" != "map" ]] && {
   echo "set dgrid3d ${dtype_arg[0]},${dtype_arg[0]} gauss 0.25"
 }

 [[ "${dtype[0]}" = "map" ]] && {
   echo "set view map"
 }

 while read newLine; do
  if [[ -n "$newLine" ]]; then
    a+=("$newLine") # add to the end
  else
#    nf=$(echo "${a[1]}"|awk '{print NF}')
    nf=0;TMPIFS=$IFS;IFS=$' 	\n'
      for j in ${a[0]};do ((nf++));done
    IFS=$TMPIFS
    if [[ "${dtype[0]}" = "map" ]] || [[ "${dtype[0]}" = "xyz" ]] || [[ "${dtype[0]}" =~ ^3d.* ]]; then
      # only one splot command is used for all blocks for 3db type plots
      if [[ "${dtype[0]}" != "3db" ]] || [[ $((blocks%dtype_arg2[0])) -eq 0 ]]; then
        if [[ "${dtype[0]}" = "map" ]]; then
          echo -n "plot "
        else
          echo -n "splot "
        fi
        echo -n "'-' u 1:2:3 t '${titles[0]}'"
        echo -n " w ${styles[0]-${styles_def[0]}}"
        [[ -n "${colors[0]}" ]] && echo -n " lc rgb '${colors[0]}'"
        echo -n ","
      fi
    else
      echo -n "plot "
      for ((j=0;j<nf;++j)); do
        c1=1; c2=$((j+2));
        [[ "${dtype[j]}" = "xy" ]] && {
          c1=$((j+2)); c2=$((j+3));
        }
        echo -n " '-' u $c1:$c2 t '${titles[$j]}' "
        echo -n "w ${styles[$j]-${styles_def[0]}} "
        [[ -n "${colors[$j]}" ]] && echo -n "lc rgb '${colors[$j]}'"
        echo -n ","
        [[ $c1 = 1 ]] || ((j++))
      done
    fi
    echo
    if [[ "${dtype[0]}" = "3d" ]] || [[ "${dtype[0]}" = "map" ]]; then
      [[ ${#a[@]} -gt $((dtype_arg[0]*dtype_arg2[0])) ]] && {
        a=( "${a[@]:dtype_arg[0]}" )
      }
      for ((j=1;j<=dtype_arg2[0];++j)); do
        [[ -n "${a[(dtype_arg2[0]-j)*${dtype_arg[0]}]}" ]] || continue;
        for ((i=0;i<dtype_arg[0];++i)); do
          echo  "$i $j ${a[(dtype_arg2[0]-j)*${dtype_arg[0]}+i]}"
        done
      done
      echo e # gnuplot's end of dataset marker
    elif [[ "${dtype[0]}" = "3db" ]]; then
      for ((i=0;i<dtype_arg[0];++i)); do
        echo  "$i $((blocks%dtype_arg2[0])) ${a[i]}"
      done
      unset a
      [[ $((blocks%dtype_arg2[0])) -eq $((dtype_arg2[0]-1)) ]] && {
        echo e # gnuplot's end of dataset marker
      }
    elif [[ "${dtype[0]}" = "xyz" ]]; then
      for i in "${a[@]}"; do echo  "$i"; done
      unset a
      echo e # gnuplot's end of dataset marker
    else
      for ((j=0;j<nf;++j)); do
        tc=0 # temp counter
        for i in "${a[@]}"; do
          echo "$tc $i"
          ((tc++))
        done
        echo e # gnuplot's end of dataset marker
      done
      unset a
    fi
    ((blocks++))
  fi
done) | gnuplot 2>/dev/null


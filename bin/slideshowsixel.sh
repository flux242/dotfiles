#!/bin/bash

# This script shows jpg pictures from a directory in a terminal
# emulator that supports sixel format
# Dependencies: ncurses-bin, imagemagic, gnuplot 
# Note: this script is supposed to be used with monospace fonts 
#       font_width is the text cell width in pixels
#       font_height is the text cell height in pixels
#       Both parameters depends on currently selected terminal font
#       and its size. If the terminal font or its size is changed
#       then both params needs to be adjusted.
#       I do not know what's the relation between the font size and
#       the text cell size, so I simply find proper values empirically

do_zoom="" # do zoom if a pictures is smaller than the terminal window size
delay=3   # seconds between pictures
font_width=11
font_height=23

while getopts ":d:w:hzs" opt; do
  case $opt in
      d) delay=$OPTARG ;;
      w) font_width=$OPTARG ;;
      h) font_heght=$OPTARG ;;
      z) do_zoom=1 ;;
      s) do_shuffle=1 ;;
     \?) echo "Invalid option: $OPTARG" >/dev/sdterr ;;
      :) echo "Option $OPTARG requires an argument" >/dev/sdterr ;;
  esac
done
shift $((OPTIND-1))

PIC_DIR="$1"
[ -d "$PIC_DIR" ] || PIC_DIR="$HOME/media/test/pics"

CANVA_WIDTH=$(($(tput cols)*font_width))
CANVA_HEIGHT=$(($(tput lines)*font_height))

#for pic in "$PIC_DIR"/*.jpg; do
if [[ do_shuffle -eq 1 ]]; then
  shuffle_cmd='shuf'
else
  shuffle_cmd='cat -'
fi

find "$PIC_DIR" -iname '*.jpg' | $shuffle_cmd | while read pic; do
  widthheight=$(identify -format '%w,%h' $pic)
  width=${widthheight%,*}
  height=${widthheight#*,}

  canva_width=$width
  canva_height=$height

  if [ -n "$do_zoom" ]; then 
    if [ $canva_height -lt $CANVA_HEIGHT ]; then
      # this can make canva_width bigger than CANVA_WIDTH
      # but it'll be corrected below
      canva_width=$(((canva_width*CANVA_HEIGHT)/canva_height))
      canva_height=$CANVA_HEIGHT
    fi
    if [ $canva_width -lt $CANVA_WIDTH ]; then
      # this can make canva_height bigger than CANVA_HEIGHT
      # but it'll be corrected below
      canva_height=$(((canva_height*CANVA_WIDTH)/canva_width))
      canva_width=$CANVA_WIDTH
    fi
  fi 

  if [ $canva_width -gt $CANVA_WIDTH ]; then
    canva_height=$(((canva_height*CANVA_WIDTH)/canva_width))
    canva_width=$CANVA_WIDTH
  fi

  if [ $canva_height -gt $CANVA_HEIGHT ]; then
    canva_width=$(((canva_width*CANVA_HEIGHT)/canva_height))
    canva_height=$CANVA_HEIGHT
  fi

  echo "set term sixelgd size $canva_width,$canva_height animate truecolor crop enhanced; \
        set lmargin screen 0;set rmargin screen 1; \
        set tmargin screen 0;set bmargin screen 1; \
        unset border; unset tics;unset key; \
        set size ratio -1; \
        set view map; \
        splot '$pic' binary filetype=auto with rgbimage;"
  sleep $delay
done | gnuplot -

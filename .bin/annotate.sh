#!/bin/bash

indir=/tmp
font="Arial-Bold"
fontColor=red
annotSize=32 # 1/32 of a picture height
 
[[ -n "$1" ]] && indir=$1
 
# shopt is needed to discard *.jpg (or *.JPG) filename in
# the for loop if there are no files with that extentions
shopt -s nullglob
 
for i in ${indir}/*.{jpg,JPG}
do
  dim=$(identify -format "%w %h" "$i")
#  width=${dim%% *}
  height=${dim#* }
  echo "$i"
  convert "$i" \
          -font "$font" \
          -fill "$fontColor" \
          -pointsize "$(awk "BEGIN{ print (1.2*$height)/$annotSize }")" \
          -gravity SouthEast \
          -annotate 0 "%[exif:DateTime]" \
          "${i}.annot.jpg"
done


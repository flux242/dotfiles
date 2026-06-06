#/usr/bin/env bash

# first of jan picture is 0013, then 24 is added for each next day
MAGIC_CONST=13

hours=$((($(date +%s)-$(date +%s -d "$(date +%Y)/1/1"))/(24*60*60)*24+$MAGIC_CONST))

# this stopped working in 2026
#wget -qO- "https://moon.nasa.gov/mvg.$(date +%Y)/$(printf '%04d' $hours).jpg" | img2sixel

#https://svs.gsfc.nasa.gov/vis/a000000/a005500/a005587/frames/730x730_1x1_30p/moon.0751.jpg
wget -qO- "https://svs.gsfc.nasa.gov/vis/a000000/a005500/a005587/frames/730x730_1x1_30p/moon.$(printf '%04d' $hours).jpg" | img2sixel

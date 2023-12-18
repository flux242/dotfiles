#/usr/bin/env bash

# first of jan picture is 0013, then 24 is added for each next day
MAGIC_CONST=13

hours=$((($(date +%s)-$(date +%s -d '2023/1/1'))/(24*60*60)*24+$MAGIC_CONST))

wget -qO- "https://moon.nasa.gov/mvg.$(date +%Y)/$(printf '%04d' $hours).jpg" | img2sixel


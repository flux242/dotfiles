#!/bin/bash


SIZE=720

declare -a sizes=( 180 240 400 640 720 1200 1280 1600 1920 )

if [[ -n "$1" ]]; then
  if [[ "${sizes[@]}" =~ "$1" ]]; then
    SIZE=$1
  else
    printf "Size $1 is not supported. Supported sizes are: %s\n" "${sizes[*]}" > /dev/stderr
    exit 1
  fi
fi

wget -qO- https://www.foto-webcam.eu/webcam/rosenheim/current/$SIZE.jpg | img2sixel
#wget -qO- https://www.addicted-sports.com/fileadmin/webcam/chiemsee/current/$SIZE.jpg | img2sixel
wget -qO- https://www.addicted-sports.com/fileadmin/webcam/torbole/current/$SIZE.jpg | img2sixel
wget -qO- https://www.foto-webcam.eu/webcam/malcesine/current/$SIZE.jpg | img2sixel
wget -qO- https://www.foto-webcam.eu/webcam/kampenwand/current/$SIZE.jpg | img2sixel
wget -qO- https://www.foto-webcam.eu/webcam/hochries-nord/current/$SIZE.jpg | img2sixel
wget -qO- https://www.foto-webcam.eu/webcam/pendling-ost/current/$SIZE.jpg | img2sixel

ct="$(date +'%Y/%m/%d/%H')$(printf "%02d" $(( (10#$(date +'%M') / 10) * 10 )))"

#https://www.terra-hd.de/wasserburg/2026/03/28/0730m.jpg
wget -qO- "https://www.terra-hd.de/wasserburg/${ct}m.jpg" | convert JPG:- -resize "${SIZE}x" JPG:- | img2sixel

#https://www.terra-hd.de/chiemsee/2026/03/28/0800m.jpg
wget -qO- "https://www.terra-hd.de/chiemsee/${ct}m.jpg" | convert JPG:- -resize "${SIZE}x" JPG:- | img2sixel

#!/bin/bash


SIZE=640


#declare -A sizes
sizes=( 180 240 400 640 720 1200 1280 1600 1920 )

if [[ -n "$1" ]]; then
  if [[ "${sizes[@]}" =~ "$1" ]]; then
    SIZE=$1
  else
    echo "Size $1 is not supported" > /dev/stderr
    exit 1
  fi
fi


#wget -qO- https://sdo.gsfc.nasa.gov/assets/img/latest/latest_512_0171.jpg | img2sixel
wget -qO- https://www.foto-webcam.eu/webcam/rosenheim/current/$SIZE.jpg | img2sixel
wget -qO- https://www.addicted-sports.com/fileadmin/webcam/chiemsee/current/$SIZE.jpg | img2sixel
wget -qO- https://www.addicted-sports.com/fileadmin/webcam/torbole/current/$SIZE.jpg | img2sixel
wget -qO- https://www.foto-webcam.eu/webcam/malcesine/current/$SIZE.jpg | img2sixel
wget -qO- https://www.foto-webcam.eu/webcam/kampenwand/current/$SIZE.jpg | img2sixel


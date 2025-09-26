#!/usr/bin/env bash

[ -e "$1" ] || { printf "Input file param is missing\n" > /dev/stderr; exit 1; }

cd "$HOME/rc/overlay_generator"
./convert_inav_blackbox.sh "$1"
./overlay_generator.sh /tmp/blackbox.converted.file.name.csv | parallel

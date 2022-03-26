#!/bin/bash

# https://www.utf8-zeichentabelle.de/unicode-utf8-table.pl
# can be combined with 
# play -c 2 -n synth pinknoise band -n 2500 4000 tremolo 0.03 5 reverb 20 gain -l 6

cols=$(tput cols)
while true; do
  str=$(awk -v cols="$cols" -v seed="$RANDOM" 'BEGIN {
    srand(seed);s="";
    while (--cols >= 0) {o=sprintf("%o",150+int(10*rand())); printf("\xe2\x96\\%s",o);}
  }')
  printf "$str"
done

# the same as oneliner
# while true;do printf "$(awk -v c="$(tput cols)" -v s="$RANDOM" 'BEGIN{srand(s);while(--c>=0){printf("\xe2\x96\\%s",sprintf("%o",150+int(10*rand())));}}')";done

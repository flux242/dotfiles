#!/usr/bin/env bash

avs=${1:-10}     # average over so many last samples, default is 10 
column=${2:-1}   # read new value from this column

awk -v avs="$avs" -v col="$column" '
BEGIN {
  sum=0;start=0;end=0
}
{
  if (match($0,/^.+$/)) {
    a[end] = $col
    end++;
    if (end>start+avs) {
      sum-=a[start];
      delete a[start];
      start++;
    } 
    sum+=$col;
    print $0 " " sum/avs;
    fflush()
  }
}' -


# Older bash implementation does not handle
# fractional numbers
# 
##!/bin/bash
#
#avs=${1:-10}     # average over so many last samples, default is 10 
#column=${2:-1}   # read new value from this column
#sum=0
#
#while read newLine; do
#  newVal="$(echo $newLine|awk -v col=$column '{print $col}')"
#  [ -n "$newVal" ] && {
#    [ "${#a[@]}" -ge $avs ] && {
#      sum=$((sum - ${a[0]}))
#      a=(${a[@]:1}) # pop from the front
#    }
#    a=("${a[@]}" "$newVal") # add to the end
#    sum=$((sum + newVal))
#    if [ -t 1 ]; then
#      echo -ne "\033[s$newLine $((sum/avs))\033[K\033[u"
#    else
#      echo "$newLine $((sum/avs))"
#    fi
#  }
#done


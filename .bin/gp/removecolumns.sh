#!/bin/bash

# input parameter is the columns to be removed
# separated by comma - "1,3,5"

awk -v cols="$1" '
BEGIN {split(cols,a,",")}
{
  if (length($0)>0) {
  for(c in a)
    $a[c]="";
  }
  print $0;
  fflush();
}' -


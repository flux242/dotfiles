#!/usr/bin/env bash

N=${1:-64}

awk -v N="$N" '
{
  if(match($0,/^.+$/)) {
    print sqrt($1*$1+$2*$2)/N;
  }
  else {
    print $0
  }
  fflush();
}' -


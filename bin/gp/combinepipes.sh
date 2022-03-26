#!/usr/bin/env bash

# Usage example: 
# ((cpustat.sh 0 | bin/gp/markpipe.sh 0) & \
#  (cpustat.sh 1 | bin/gp/markpipe.sh 1) & \
#  (cpustat.sh 2 | bin/gp/markpipe.sh 2) & \
#  (cpustat.sh 3 | bin/gp/markpipe.sh 3)) | \
#  bin/combinepipes.sh 4

# by default 2 pipes are combined
pipes=${1:-2}

awk -F: -v pipes="$pipes" '
{
  s="";for(n=2;n<NF;++n){s=s$n":"};s=s""$n
  a[$1]=s;
  cnt=0;
  for (i in a) cnt++;
  if(cnt==pipes) {
    i=0;
    while(i<cnt) {
      printf("%s ", a[i])
      delete a[i++]
    }
    printf("\n")
    fflush()
  }
}' -


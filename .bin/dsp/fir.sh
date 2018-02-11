#!/usr/bin/env bash

# Example: Show white noise and the noise filtered
# dd if=/dev/urandom | hexdump -v -e '/1 "%u\n"'| \
# bin/gp/syncpipe.pl 0.02| \
# bin/gp/fir.sh|bin/gp/gnuplotwindow.sh 100 "0:255" "Noise;2" \
# "Filtered Noise;2"

column=${1:-1}   # read new value from this column

awk -v col="$column" '
BEGIN {

# low pass filter
# passband: 0 - 2Hz, 5dB, gain 0.82
# stopband: 5 - 25Hz, -40dB, gain 0
N=19;
h[0]= 0.002711194051441766
h[1]= 0.014554159700613932
h[2]= 0.021045304863035214
h[3]= 0.034365187654135286
h[4]= 0.04861466078274462
h[5]= 0.06381400872019195
h[6]= 0.07806090741758967
h[7]= 0.08976640481334615
h[8]= 0.09745970764670556
h[9]= 0.10013849663367967
h[10]=0.09745970764670556
h[11]=0.08976640481334615
h[12]=0.07806090741758967
h[13]=0.06381400872019195
h[14]=0.04861466078274462
h[15]=0.034365187654135286
h[16]=0.021045304863035214
h[17]=0.014554159700613932
h[18]=0.002711194051441766

  for (c=0;c<N;c++) {
    x[c] = 0;
  }
  c=0;
}
{
  if (match($0,/^.+$/)) {
    x[c]=$col;
    y=0;
    for (i=0;i<N;i++) {
      y+= h[i]*x[(c-i+N)%N];
    }
    print $0" "y;
    if ((++c)>=N) {c=0;}
    fflush();
  }
}
' -


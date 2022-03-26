#!/bin/bash

xmin=-16
xmax=16
ymin=-16
ymax=16
step=1.0
argstep=0.1

xnumb=$( awk -v min=$xmin -v max=$xmax -v step=$step 'BEGIN{if(min<0){min=-min};if(max<0){max=-max};print (min+max)/step}' )
ynumb=$( awk -v min=$ymin -v max=$ymax -v step=$step 'BEGIN{if(min<0){min=-min};if(max<0){max=-max};print (min+max)/step}' )

(while true; do echo line; sleep 0.25; done)| \
  awk -v xmin=$xmin -v xmax=$xmax -v ymin=$ymin -v ymax=$ymax -v step=$step -v argstep=$argstep \
  'BEGIN{arg=0.01}
      {for(j=ymin;j<=ymax;j+=step) {
         for(i=xmin;i<=xmax;i+=step) {
           r=sqrt(i*i+j*j);
           if (r!=0) {t=sin(sin(arg)*r)/(sin(arg)*r)}
           else {t=1.0}
           print t
         }
         print ""
       }
       fflush();arg+=argstep}'| \
  ~/bin/gp/gnuplotblock.sh "0:$xnumb;0:$ynumb;-0.25:1" \
    "sinc(sqrt(x*x+y*y));l lw 1 palette;;3db;$((xnumb+1));$((ynumb+1))"

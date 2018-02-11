#!/usr/bin/env bash

# Usage examples:
#
# dd if=/dev/urandom | hexdump -v -e '/1 "%u\n"' | \
# (while read line; do echo "$line"; sleep 0.05; done)|bin/dsp/fir.sh | \
# bin/gp/removecolumns.sh 1 | awk '{print $1/8;fflush()}'| \
# bin/gp/biker.sh 80 '20;40'| \
# bin/gp/gnuplotblock.sh "0:79;0:80" "Filtered Noise;0;#008000" "biker;l lw 3;red;xy"
#
# (while true; do echo line; sleep 0.03; done)| \
#  awk 'BEGIN{PI=atan2(0,-1);t=0;f0=0.1;}{print sin(2*PI*t*f0)+2.0;t+=0.1;fflush()}'| \
#  bin/gp/biker.sh 64 "10;4"| \
#  bin/gp/gnuplotblock.sh "0:63;0:8" "Sine wave;0;#008000" "gnuplot biker;l lw 3;red;xy"
#
# generation of the biker array:
# awk -F: 'BEGIN{cnt=0;idx=0}
#          {
#            if(cnt==2){printf("%s\"\n",$2);++idx;cnt=0};
#            if(cnt==1){printf("b[%d]=\"%s ", idx, $2);cnt++};
#            if(match($0,"(MoveTo|LineTo)")){cnt=1}
#          }' Downloads/bike.fx
# bike.fx is a vector path drawn over a real picture in inkscape
# and saved as a JavaFx file

N=${1:-64}    # number of samples, default 64
scale=${2:-5;5} # biker size in percent
col=${3:-1}  # input stream column to work with


awk -v N="$N" -v col="$col" -v scale="$scale" '
function init_biker()
{
  b[0]=" 229.65326000  -261.56693000"
  b[1]=" 236.53660000  -230.90478000"
  b[2]=" 268.45027000  -217.76386000"
  b[3]=" 311.00183000  -218.38962000"
  b[4]=" 245.92298000  -151.43349000"
  b[5]=" 304.74425000  -110.75920000"
  b[6]=" 311.00183000  -118.89406000"
  b[7]=" 289.72605000  -147.05318000"
  b[8]=" 295.35788000  -165.20017000"
  b[9]=" 345.41853000  -204.62294000"
  b[10]=" 344.79278000  -226.52447000"
  b[11]=" 331.65185000  -242.79419000"
  b[12]=" 287.84878000  -259.68966000"
  b[13]=" 332.90337000  -265.94724000"
  b[14]=" 336.65792000  -239.03964000"
  b[15]=" 352.30187000  -224.64720000"
  b[16]=" 424.88983000  -220.26689000"
  b[17]=" 438.65651000  -229.65326000"
  b[18]=" 437.40499000  -248.42601000"
  b[19]=" 420.50952000  -250.30329000"
  b[20]=" 407.99436000  -240.91691000"
  b[21]=" 359.81097000  -251.55480000"
  b[22]=" 362.31401000  -279.08816000"
  b[23]=" 384.21554000  -280.96544000"
  b[24]=" 394.85343000  -267.82452000"
  b[25]=" 409.87163000  -272.83058000"
  b[26]=" 415.50345000  -282.21695000"
  b[27]=" 421.13528000  -307.87304000"
  b[28]=" 417.38073000  -328.52306000"
  b[29]=" 399.85950000  -342.91550000"
  b[30]=" 380.46099000  -346.67005000"
  b[31]=" 366.06855000  -334.78064000"
  b[32]=" 356.68218000  -314.75638000"
  b[33]=" 340.41247000  -335.40640000"
  b[34]=" 254.05783000  -297.23515000"
  b[35]=" 234.03357000  -277.21089000"
  b[36]=" 228.24531000  -261.87981000"
  b[37]=" 222.76992000  -273.92566000"
  b[38]=" 111.94690000  -274.77876000"
  b[39]=" 140.26549000  -250.44248000"
  b[40]=" 138.05310000  -224.77876000"
  b[41]=" 210.61947000  -184.51327000"
  b[42]=" 223.45133000  -188.93805000"
  b[43]=" 253.09735000  -160.84071000"
  b[44]=" 243.36283000  -149.55752000"
  b[45]=" 224.55752000  -173.45133000"
  b[46]=" 196.01770000  -188.49558000"
  b[47]=" 159.07080000  -186.50442000"
  b[48]=" 129.21907000  -169.58048000"
  b[49]=" 115.48673000  -149.11504000"
  b[50]=" 109.29204000  -127.43363000"
  b[51]=" 111.06195000  -99.11504000"
  b[52]=" 125.22124000  -72.56637000"
  b[53]=" 143.36283000  -58.84956000"
  b[54]=" 171.23894000  -48.67257000"
  b[55]=" 203.09735000  -52.21239000"
  b[56]=" 225.22124000  -65.92920000"
  b[57]=" 242.47788000  -86.28319000"
  b[58]=" 247.34513000  -97.78761000"
  b[59]=" 268.14159000  -75.22124000"
  b[60]=" 419.02655000  -76.10619000"
  b[61]=" 411.94690000  -109.73451000"
  b[62]=" 415.92920000  -126.99115000"
  b[63]=" 416.37168000  -100.44248000"
  b[64]=" 426.99115000  -76.10619000"
  b[65]=" 446.46018000  -60.17699000"
  b[66]=" 472.56637000  -51.32743000"
  b[67]=" 502.21239000  -53.98230000"
  b[68]=" 528.76106000  -70.79646000"
  b[69]=" 542.92035000  -97.78761000"
  b[70]=" 543.80531000  -129.64602000"
  b[71]=" 533.62832000  -150.44248000"
  b[72]=" 513.71681000  -170.79646000"
  b[73]=" 519.02655000  -171.68142000"
  b[74]=" 489.82301000  -184.07080000"
  b[75]=" 497.34513000  -188.93805000"
  b[76]=" 513.27434000  -196.01770000"
  b[77]=" 516.37168000  -207.07965000"
  b[78]=" 492.92035000  -239.82301000"
  b[79]=" 504.86726000  -239.38053000"
  b[80]=" 470.35398000  -269.02655000"
  b[81]=" 428.76106000  -296.01770000"
  b[82]=" 438.93805000  -253.53982000"
  b[83]=" 474.33628000  -234.95575000"
  b[84]=" 471.23894000  -225.22124000"
  b[85]=" 402.21239000  -211.50442000"
  b[86]=" 332.30089000  -180.08850000"
  b[87]=" 367.25664000  -130.08850000"
  b[88]=" 414.25194000  -97.14896000"
  b[89]=" 247.48737000  -98.24404000"
  b[90]=" 246.23586000  -151.74637000"
  b[91]=" 311.62759000  -219.01537000"
  b[92]=" 268.13739000  -217.76386000"
  b[93]=" 236.22373000  -230.27902000"
  b[94]=" 229.65326000  -261.56693000"
}

function get_array_length(arr,    len,i)
{
  len = 0;
  for (i in arr) ++len;
  return len;
}

function scale_array(arr,len,scale_x,scale_y,    i,p)
{
  for(i=0;i<len;++i) {
    split(arr[i], p);
    arr[i] = p[1]*scale_x " " p[2]*scale_y;
  }
}

function translate_array(arr,len,x,y,    i,p)
{
  for(i=0;i<len;++i) {
    split(arr[i], p);
    arr[i] = p[1]+x " " p[2]+y;
  }
}

function rotate_array(arr,len,dx,dy,    i,p,alpha,cos_a,sin_a)
{
  alpha=atan2(dy,dx);
  cos_a = cos(alpha);
  sin_a = sin(alpha);
  for(i=0;i<len;++i) {
    split(arr[i], p);
    arr[i] = p[1]*cos_a + p[2]*sin_a " " (p[2]*cos_a-p[1]*sin_a);
  }
}

function rotate_translate_array(arr,len,rdx,rdy,dx,dy,    i,p,alpha,cos_a,sin_a)
{
  alpha=atan2(rdy,rdx);
  cos_a = cos(alpha);
  sin_a = sin(alpha);
  for(i=0;i<len;++i) {
    split(arr[i], p);
    arr[i] = p[1]*cos_a + p[2]*sin_a + dx" " p[2]*cos_a-p[1]*sin_a+dy;
  }
}

function calc_array_bbox(arr,len,bbox,     x1,y1,x2,y2,val,p)
{
  split(arr[0], p);
  x1 = x2 = p[1];
  y1 = y2 = p[2];

  for(val in arr) {
    split(arr[val], p);
    if (x1 > p[1]) x1=p[1];
    if (y1 > p[2]) y1=p[2];
    if (x2 < p[1]) x2=p[1];
    if (y2 < p[2]) y2=p[2];
  }

  bbox[0]=x1;bbox[1]=y1;
  bbox[2]=x2;bbox[3]=y2;
}

BEGIN {
  start=0;end=0;
  split(scale, scale_arr, ";");
  scale_x = scale_arr[1];
  scale_y = scale_arr[2];
  init_biker()
  len = get_array_length(b);
  scale_array(b, len, 1, -1);
  calc_array_bbox(b, len, bbox);
#  print bbox[0]";"bbox[1]";"bbox[2]";"bbox[3] > "/dev/stderr";

  # scale to unity square
  translate_array(b, len, -bbox[0], -bbox[1]);
  scale_array(b, len, 1/(bbox[2]-bbox[0]), 1/(bbox[2]-bbox[0]));

  # scale according to input values
  scale_array(b, len, scale_x, scale_y);
  biker_start_x = int((N-scale_x)/2);
  biker_end_x = int(biker_start_x+scale_x);
  biker_len = biker_end_x - biker_start_x;

  # additional scaling to compensate 2*wheel_diameter/2 
  translate_array(b, len, -biker_len/2, 0);
  scale_array(b, len, 1.417, 1);
  translate_array(b, len, biker_len/2, 0);
}
{
  if (match($0,/^.+$/)) {
    a[end] = $col;
    ++end;
    if (end>start+N) {
      delete a[start];
      start++;
    } 

    for(i=0;i<len;++i) { c[i] = b[i]; }
    rotate_translate_array(c, len, biker_end_x-biker_start_x,
                         a[biker_start_x+start]-a[biker_end_x+start],
                         biker_start_x, a[biker_start_x+start]);

    for (i=start;i<N+start;++i) {
      (i<end)?atmp=a[i]:atmp=0;
      print atmp " " c[i-start];
    }
    i-=start;
    for(;i<len;++i) {
      print 0 " " c[i];
    }
    printf("\n");
    fflush();
  }
}
' -


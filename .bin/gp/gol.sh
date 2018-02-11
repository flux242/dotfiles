#!/usr/bin/env bash

N=${1:-50}      # number of columns
M=${2:-50}      # number of rows
fill=${3:-60}   # initial array fill factor in percent or 's1' for ship
iter=${4:-1e20} # default is endless. Use 'keyboard' to step with Enter

awk -v N="$N" -v M="$M" -v maxiter="$iter" -v fill="$fill" '
function init_rnd(a,N,M,probperc,     NM,i)
{
  NM=N*M;
  srand();
  for(i=0;i<NM;++i) {
    if(int(100*rand())>=probperc) {a[i]=1;}
    else {a[i]=0;}
  }
}

function init_ship1(a,N,M,     NM,i)
{
  NM=N*M;
  for(i=0;i<NM;++i) {a[i]=0;}
  row=N*int(M/3-6);
  a[row+1]=1;
  a[row+N]=1;
  a[row+2*N]=1;a[row+2*N+4]=1;
  a[row+3*N]=1;a[row+3*N+1]=1;a[row+3*N+2]=1;a[row+3*N+3]=1;
  a[row+4*N+7]=1;
  a[row+5*N+5]=1;a[row+5*N+6]=1;
  a[row+6*N+7]=1;
  a[row+7*N]=1;a[row+7*N+1]=1;a[row+7*N+2]=1;a[row+7*N+3]=1;
  a[row+8*N]=1;a[row+8*N+4]=1;
  a[row+9*N]=1;
  a[row+10*N+1]=1;
  
  row=N*int(2*M/3-6);
  a[row+6]=1;
  a[row+N+7]=1;
  a[row+2*N+3]=1;a[row+2*N+7]=1;
  a[row+3*N+4]=1;a[row+3*N+5]=1;a[row+3*N+6]=1;a[row+3*N+7]=1;
  a[row+4*N]=1;
  a[row+5*N+1]=1;a[row+5*N+2]=1;
  a[row+6*N]=1;
  a[row+7*N+4]=1;a[row+7*N+5]=1;a[row+7*N+6]=1;a[row+7*N+7]=1;
  a[row+8*N+3]=1;a[row+8*N+7]=1;
  a[row+9*N+7]=1;
  a[row+10*N+6]=1;
}

BEGIN {
  NM=N*M;
  NM_1=N*(M-1);
  iter=0;
  if (maxiter=="keyboard") {keyboard=1;maxiter=1e20;}
  else {maxiter+=0;} # to turn string into number
  if (fill=="s1") {init_ship1(a,N,M);}
  else {init_rnd(a,N,M,fill);}
  while (iter<maxiter) {
#for(j=0;j<NM;++j) {printf("%d",a[j]);if(0==((j+1)%N)){print "";}}
    for(row=0;row<M;++row) {
      trow=row*N;
      for(col=0;col<N;++col) {
        d=0;
        if (0==row) {crow=NM_1;} else{crow=trow-N;}
        d+=a[crow+((col+1+N)%N)] + a[crow+((col-1+N)%N)] + a[crow+((col+N)%N)];
        crow=trow;
        d+=a[crow+((col-1+N)%N)] + a[crow+((col+1+N)%N)];
        if ((M-1)==row) {crow=0;} else{crow=trow+N;}
        d+=a[crow+((col+1+N)%N)] + a[crow+((col-1+N)%N)] + a[crow+((col+N)%N)];
        idx=trow+col;
        if (d<2 || d>3) {b[idx] = 0;} # cell dies
        else if (3==d) {b[idx] = 1;}  # cell is born
        else {b[idx]=a[idx];}         # cell is preserved
      }
    }
    cellcount=0;
    for (i=0;i<NM;++i) {
      if (1==a[i]) {++cellcount;print i%N" "int(i/N);}
      a[i]=b[i];
    }
    print ""
    print iter" "cellcount > "/dev/stderr"
    ++iter;
#    if (0==cellcount) {iter=maxiter;}
    fflush();
    if (1==keyboard){getline line;}
  }
}'


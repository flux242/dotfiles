#!/usr/bin/env bash

# Usage example:
# PLot the chirp signal and its frequency domain presentation:
# (while true; do echo line; sleep 0.01; done)| \
#  awk 'BEGIN{PI=atan2(0,-1);t=0;f0=1;f1=32;T=256;k=(f1-f0)/T;}{print sin(2*PI*(t*f0+k/2*t*t));t+=0.1;fflush()}'| \
#  tee >(bin/dsp/fft.sh 64 "w1;0.5;0.5"|bin/dsp/fftabs.sh 64| \
#        bin/gp/gnuplotblock.sh '-0.5:31.5;0:0.5' 'Chirp signal spectrum;1')| \
#  bin/gp/gnuplotwindow.sh 128 "-1:1" "Chirp signal;2"

N=${1:-64}   # number of samples, default 64
wd=${2:-w0}  # window function description, w0-rectangular window (default), w1-hanning window
col=${3:-1}  # input stream column to calculate fft for


awk -v N="$N" -v col="$col" -v win_desc="$wd" '
function compl_add(a, b,   ara,arb) {
  split(a, ara);split(b, arb);
  return ara[1]+arb[1]" "ara[2]+arb[2];
}
function compl_sub(a, b,   ara,arb) {
  split(a, ara);split(b, arb);
  return ara[1]-arb[1]" "ara[2]-arb[2];
}
function compl_mul(a, b,   ara,arb) {
  split(a, ara);split(b, arb);
  return ara[1]*arb[1]-ara[2]*arb[2]" "ara[1]*arb[2]+ara[2]*arb[1];
}

function init_hanning_window(N,a,b,     i)
{
  for(i=0;i<N;++i) {
    w[i] = a - b*cos(2*PI*i/(N-1));
  }
}

function init_window(N,win_desc,    i,wa,a,b,win_type)
{
  split(win_desc, wa, ";");
  switch(wa[1]) {
  case "w1": # hanning window
    win_type = 1;
    if (2 in wa) a = wa[2]; else a = 0.5;
    if (3 in wa) b = wa[3]; else b = 0.5;
    init_hanning_window(N,a,b);
    break;
  case "w0":
  default:
    win_type = 0;
    break;
  }
  return win_type;
}

function apply_window(N,    i)
{
  for(i=0;i<N;++i) {
    c[i]*=w[i];
  }
}

function calc_pow2(N,    pow)
{
  pow = 0;
  while(N = rshift(N,1)) {
    ++pow;
  };
  return pow;
}

function bit_reverse(n,pow,    i,r)
{
  r = 0;
  pow-=1;
  for(i=pow;i>=0;--i) {
    r = or(r,lshift(and(rshift(n,i),1), pow-i));
  }
  return r;
}

function binary_inversion(N,pow,    tmp,i,j)
{
#  pow = calc_pow2(N);
  for(i=0;i<N;++i) {
    j = bit_reverse(i,pow);
    if (i<j) {
      tmp = c[i];
      c[i] = c[j]; 
      c[j] = tmp; 
    }
  } 
}

function fft(start,end,e,     N,N2,k,t,et) {
  N = end - start;
  if (N<2) return;
  N2 = N/2;
  et = e;
  for (k=0;k<N2;++k) {
    t = c[start+k];
    c[start+k] = compl_add(t,c[start+k+N2]);
    c[start+k+N2] = compl_sub(t,c[start+k+N2]);
    if (k>0) {
      c[start+k+N2] = compl_mul(et,c[start+k+N2]);
      et = compl_mul(et,e);
    }
  }
  et = compl_mul(e,e);
  fft(start, start+N2, et);
  fft(start+N2, end, et);
}

function print_fft(N,     N2,i)
{
  N2 = N/2;
  for(i=1;i<=N2;++i) {
    print c[i];
  }
}

BEGIN {
  if (and(N,N-1)!=0) {
    print "Error: Signal width shall be power of two!" > "/dev/stderr";
    exit(1);
  }
  start=0;end=0;
  for(i=0;i<N;++i) a[i]=0;
  PI = atan2(0,-1);
  expN = cos(2*PI/N) " " (-sin(2*PI/N));
  N2 = N/2;
  pow = calc_pow2(N);
  #  win_type = 0; # rectangular window by default
  #  win_type = 1; # hanning window
  win_type = init_window(N, win_desc);
}
{
  if (match($0,/^.+$/)) {
    a[end] = $col;
    ++end;
    if (end>start+N) {
      delete a[start];
      start++;
    } 
    for (i=start;i<N+start;++i) {
      (i<end)?c[i-start] = a[i]:c[i-start] = 0;
    }
    if (win_type!=0) {
      apply_window(N);
    }
    fft(0,N,expN); 
    binary_inversion(N,pow); # N = 2^pow;
    print_fft(N);
    printf("\n");
    fflush();
  }
}
' -


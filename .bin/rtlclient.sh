#!/bin/bash
# A simple bash rtl_tcp client
# Written by Alexander K
#
# Example:
# Feed the rtl_433 with data from a remove server:
# bin/rtlclient.sh -f 433920000 -a 192.168.1.153 -P 46 -s 250000 -g 0 |\
#  projects/rtl_433/build/src/rtl_433 -G -r /dev/stdin -F json |\
#  tee >(\grep --line-buffered ^{ |\
#        jq --unbuffered -c 'select(.temperature_C!=null)|.temperature_C'|\
#        awk -v n=5 'BEGIN{m=int(n/2)+1}{if(1==i){for(j=1;j<n;++j){a[j]=a[j+1]}a[n]=$1}else{for(j=1;j<=n;++j){a[j]=$1};i=1}asort(a,b);print(b[m]);fflush()}'|\
#        bin/gp/syncpipe.pl 60 0 | bin/gp/gnuplotwindow.sh "$((24*60))" ":" "Outside temperature")

# RTL_CLIENT_CONTROL_FILE is defined in the defaults.conf but I'm not sourcing it here
[ -n "$RTL_CLIENT_CONTROL_FILE" ] || RTL_CLIENT_CONTROL_FILE='/tmp/rtlclient.control.txt'

SET_FREQUENCY=1
SET_SAMPLE_RATE=2
SET_GAIN_MODE=3
SET_GAIN=4
SET_FREQUENCY_CORRECTION=5
SET_AGC_MODE=8

show_error_exit()
{
  echo "$1" >&2
  echo "For help: $0 -h"
  exit 2
}

show_usage()
{
cat <<HEREDOC
Usage: $1 [options]

Options:
  -h,             show this help message and exit
  -f FREQUENCY,   Frequency in Hz to tune to
  -a ADDRESS,     Address of the server to connect to (default: localhost)
  -p PORT,        Port of the server to connect to (default:1234)
  -s SAMPLERATE,  Sample rate to use (default: 2400000)
  -g GAIN,        Gain to use (default: 0 for auto)
  -P PPM,         PPM error (default: 0)
HEREDOC
}

byte()
{
  printf \\$(printf "%03o" $1)
}
int2bytes()
{
  byte $(($1>>24))
  byte $(($1>>16&255))
  byte $(($1>>8&255))
  byte $(($1&255))
}

set_frequency()
{
  byte $SET_FREQUENCY
  int2bytes $1
}
set_sample_rate()
{
  byte $SET_SAMPLE_RATE
  int2bytes $1
}
set_gain()
{
  if [ $1 -eq 0 ]; then
    # automatic gain control
    byte $SET_GAIN_MODE
    int2bytes 0
    byte $SET_AGC_MODE
    int2bytes 1
  else
    byte $SET_GAIN_MODE
    int2bytes 1
    byte $SET_AGC_MODE
    int2bytes 0
    byte $SET_GAIN
    int2bytes 0
    byte $SET_GAIN
    int2bytes $1
  fi
}

set_ppm()
{
  byte $SET_FREQUENCY_CORRECTION
  int2bytes $1
}

address='localhost'
port=1234
frequency=0
samplerate=0
gain=0
ppm=0

OPTIND=1 #reset index
while getopts "ha:p:f:s:g:P:" opt; do
  case $opt in
     h)  show_usage $(basename $0); exit 0; ;;
     a)  address="$OPTARG" ;;
     p)  port="$OPTARG" ;;
     f)  frequency="$OPTARG" ;;
     s)  samplerate="$OPTARG" ;;
     g)  gain="$OPTARG" ;;
     P)  ppm="$OPTARG" ;;
     \?) exit 1 ;;
     :)  echo "Option -$OPTARG requires an argument" >&2;exit 1 ;;
  esac
done
shift $((OPTIND-1)) 
 
# Due to a bug in the hardware sample rate should be in the following range 
# 225001 - 300000 Hz
# 900001 - 3200000 Hz
# and sample loss is to be expected for rates > 2400000
# https://github.com/merbanan/rtl_sdr_r820t/commit/003bd51167d9680e9721c7296323fdffe4be5a09

[ ! "$frequency" -eq 0 ] || show_error_exit "Wrong frequency"
[ ! "$samplerate" -eq 0 ] || show_error_exit "Wrong sample rate"
(("$f" > 225000 && "$f" <= 300000)) || (("$f" > 900000 && "$f" <= 2400000)) || show_error_exit "Wrong sample rate"

echo "freq $frequency" > "$RTL_CLIENT_CONTROL_FILE"
echo "srate $samplerate" >> "$RTL_CLIENT_CONTROL_FILE"
echo "gain $gain" >> "$RTL_CLIENT_CONTROL_FILE"
echo "ppm $ppm" >> "$RTL_CLIENT_CONTROL_FILE"

tail -f "$RTL_CLIENT_CONTROL_FILE" | while read LINE
do
  case "$LINE" in
    freq*) set_frequency "${LINE#freq }" ;;
    srate*) set_sample_rate "${LINE#srate }" ;;
    gain*) set_gain "${LINE#gain }" ;;
    ppm*) set_ppm "${LINE#ppm }" ;;
    *) ;;
  esac
done | nc $address $port

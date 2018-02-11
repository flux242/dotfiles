#!/bin/sh

# workaroud for the dash not handling -e correctly
ec='echo -e';[ -n "$($ec)" ] && ec='echo'

f="/sys/class/net/${1:-wlan0}/statistics"
otx=$(cat "$f/tx_bytes")
orx=$(cat "$f/rx_bytes")
oe=0

while [ $oe -eq 0 ]; do
  tx=$(cat "$f/tx_bytes")
  rx=$(cat "$f/rx_bytes")
  txd=$((tx-otx))
  rxd=$((rx-orx))
  [ $txd -lt 0 ] && txd=$((txd+4294967296))
  [ $rxd -lt 0 ] && rxd=$((rxd+4294967296))
  if [ -t 1 ]; then
    $ec -n "\033[s$((txd+rxd)) ${2+$txd} ${2+$rxd}\033[K\033[u"
  else
    echo "$((txd+rxd)) ${2+$txd} ${2+$rxd}"
  fi
  oe=$?
  otx=$tx
  orx=$rx
  sleep 1
done


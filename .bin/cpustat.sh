#!/bin/sh

ec='echo -e';[ -n "$($ec)" ] && ec='echo'
cpu="cpu$1 "
oe=0

while [ $oe -eq 0 ]; do
  res=$(awk -v cpu="$cpu" '{if(match($0,cpu)) {
                             for(i=2;i<=NF;++i){s+=$i}
                             printf "%.0f;%.0f\n",s,$5+$6;
                            }}' /proc/stat)
  total=${res%%;*}
  idle=${res#*;}
  [ -n "$prevtotal" ] && {
    totaldiff=$((total-prevtotal))
    s=$((100*(totaldiff-idle+previdle)))
    [ $totaldiff -ne 0 ] && s=$((s/totaldiff))
    if [ -t 1 ]; then
      $ec -n "\033[s$s\033[K\033[u"
    else
      echo "$s"
    fi
    oe=$?
  }

  prevtotal=$total
  previdle=$idle
  sleep 1
done


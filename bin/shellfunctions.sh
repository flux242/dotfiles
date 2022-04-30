#┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
#░█▀▀░█░█░█▀▀░█░░░█░░░░░█▀▀░█░█░█▀█░█▀▀░▀█▀░▀█▀░█▀█░█▀█░█▀▀
#░▀▀█░█▀█░█▀▀░█░░░█░░░░░█▀▀░█░█░█░█░█░░░░█░░░█░░█░█░█░█░▀▀█
#░▀▀▀░▀░▀░▀▀▀░▀▀▀░▀▀▀░░░▀░░░▀▀▀░▀░▀░▀▀▀░░▀░░▀▀▀░▀▀▀░▀░▀░▀▀▀
#┃           Maintained at https://is.gd/jfAQYX            ┃
#┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛


# use grc if it's installed or execute the command direct
grc() {
  if [[ -n "$(which grc)" ]]; then
    #grc --colour=auto
    $(which grc) --colour=on "$@"
  else
    "$@"
  fi
}

# adds files permissons in binary form to the ls command output
lso()
{
  if [ -t 0 ];then ls -alG "$@";else cat -;fi |
    awk '{t=$0;gsub(/\x1B\[[0-9;]*[mK]/,"");k=0;for(i=0;i<=8;i++)k+=((substr($1,i+2,1)~/[rwx]/)*2^(8-i));if(k)printf(" %0o ",k);print t}'
}

# watches input command output through a banner
# Usage: showbanner "date +%T"
showbanner()
{
  local opt; local t=1; local cmd

  OPTIND=1 #reset index
  while getopts "t:" opt; do
    case $opt in
      t)  t=$OPTARG ;;
      \?) return 1 ;;
      :)  echo "Option -$OPTARG requires number of sec as an argument" >&2;return 1 ;;
    esac
  done
  shift $((OPTIND-1));
  cmd=echo
  [ -n "$BANNER" ] && cmd="$BANNER"
  echo y|watch --color -etn"$t" "$*|xargs $cmd"
}

# cli calculator. Usage: ? "sqrt(3)/2 + 4"
function ? {
  awk "BEGIN{ pi = 4.0*atan2(1.0,1.0); deg = pi/180.0; print $* }"
}

# crypting functions
# perl oneliner is to enable encrypt|decrypt combos or any other pipe
# combination where multiple programs ask for a pass at the same time
encrypt() {
  local iter="$ITER"
  [[ -n "$ITER" ]] || iter="20242"

  if [ -t 0 ]; then
    # interactive
    local fname="$1"
    shift
    openssl aes-256-cbc -iter "$iter" -salt -in "$fname" -out "${fname}.enc" "$@"
    # gpg encryption example
    # gpg --output encrypted.data --symmetric --cipher-algo AES256 un_encrypted.data
  else
    # piped
    perl -e 'use IO::Select; $ready=IO::Select->new(STDIN)->can_read();'
    openssl aes-256-cbc -iter "$iter" -salt "$@"
  fi
}
decrypt() {
  local iter="$ITER"
  [[ -n "$ITER" ]] || iter="20242"

  if [ -t 0 ]; then
    # interactive
    local fname="$1"
    shift
    openssl aes-256-cbc -d -iter "$iter" -in "$fname" -out "${fname%\.*}" "$@"
    # gpg decryption example
    # gpg --output un_encrypted.data --decrypt encrypted.data
  else
    perl -e 'use IO::Select; $ready=IO::Select->new(STDIN)->can_read();'
    openssl aes-256-cbc -d -iter "$iter" "$@"
  fi
}

# prints/puts content of/to the clipboard
printclip() {
  xclip -o -sel c 2>/dev/null
}
putclip() {
  xclip -i -sel c
}


# shows weather in a city
wttr() {
  wttrfull "$@" | head -n 7
}
wttrfull() {
  wget -q -O - http://wttr.in/$1
}

# transfer a file or pipe to the server
# 10G maximum for 14 days
transfer() {
  local basefile tmpfile
  if [ $# -eq 0 ]; then
    echo "No arguments specified. Usage:"
    echo "  transfer /tmp/test.md"
    echo "  cat /tmp/test.md | transfer test.md";
    return 1;
  fi
  tmpfile=$(mktemp -t transferXXX);
  if tty -s; then
    basefile=$(basename "$1" | sed -e 's/[^a-zA-Z0-9._-]/-/g');
    curl --progress-bar --upload-file "$1" "https://transfer.sh/$basefile" >> "$tmpfile";
  else
    curl --progress-bar --upload-file "-" "https://transfer.sh/$1" >> "$tmpfile";
  fi;
  tee >(putclip) <"$tmpfile"
  \rm -f "$tmpfile";
} 

# copies a file and shows progress
copy() {
  [[ -z "$1" || -z "$2" ]] && {
    echo "Usage: copy /source/file /destination/file"
    return 1
  }
  local dest=$2
  local size=$(stat -c%s "$1")
  [[ -d "$dest" ]] && dest="$2/$(basename "$1")"
  dd if="$1" 2> /dev/null | pv -petrb -s "$size" | dd of="$dest"
}

#pb pastebin || Usage: 'command | pb or  pb filename'
pb() {
  curl -F "c=@${1:--}" https://ptpb.pw/?u=1 | tee >(putclip)
}
pbs() {
  local var
  for var in "$@"; do [ -e "$var" ] && {
    echo "File exists: $var" >/dev/stderr
    return 1
  } done
  local sname=$(scrot "$@" '/tmp/screenshot_$w_$h_%F_%H-%M-%S.png' -e 'echo $f')
  [[ -s "$sname" ]] && pbx "$sname"
}
pbsw() {
  echo "Select window to upload"
  pbs -s
}
pbx() {
  read -rp "Upload screenshot $1? [yN]:"
  [[ "y" = "$REPLY" ]] && {
    curl -sF "c=@${1:--}" -w "%{redirect_url}" 'https://ptpb.pw/?r=1' -o /dev/stderr | putclip
  }
}

# search command usage examples on commandlinefu.com
cmdfu() {
  wget -qO - "http://www.commandlinefu.com/commands/matching/$(echo "$@" \
        | sed 's/ /-/g')/$(echo -n "$@" | base64)/sort-by-votes/plaintext" ;
}

# url escape / unescape
urlencode() {
  # needs liburi-perl to be installed
  local url="$1"
  [[ -z "$url" ]] && url=$(cat -)
  perl -MURI::Escape -e 'print uri_escape($ARGV[0]);' "$url"
}
urldecode() {
  # needs liburi-perl to be installed
  local url="$1"
  [[ -z "$url" ]] && url=$(cat -)
  perl -MURI::Escape -e 'print uri_unescape($ARGV[0]);' "$url"
}

# shorten / expand a URL
shortenurl() {
#    curl -F"shorten=$*" https://0x0.st
#  wget -q -O - --post-data="shorten=$1" https://0x0.st
  local url=$1
  [[ -z "$url" ]] && url=$(printclip)
  [[ -z "$url" ]] && echo "Nothing to shorten" && return 1
  wget -q -O - 'http://is.gd/create.php?logstats=1&format=simple&url='"$(urlencode "$url")"|tee >(putclip);echo
}
expandurl() {
  local url=$1
  [[ -z "$url" ]] && url=$(printclip)
  [[ -z "$url" ]] && echo "Nothing to expand" && return 1
  wget -S "$url" 2>&1 | grep ^Location | awk '{print $2}'|tee >(putclip)
}

# shows battery status
showbattery() {
  local dir=/sys/class/power_supply/BAT0/
  if [[ -e "$dir"/charge_now ]]; then
    echo "$(<"$dir"/status) $(( $(<"$dir"/charge_now) * 100 / $(<"$dir"/charge_full) ))% Capacity $(<"$dir"/capacity)%"
  elif [[ -e "$dir"/energy_now ]]; then
    echo "$(<"$dir"/status) $(( $(<"$dir"/energy_now) * 100 / $(<"$dir"/energy_full) ))% Capacity $(<"$dir"/capacity)%"
  fi
}

# shows battery full statistics
showbatteryfull() {
  upower -i $(upower -e | grep BAT)
}

# shows cpu temperature
showcputemp() {
  awk -v t="$(cat /sys/class/thermal/thermal_zone0/temp)" 'BEGIN{print t/1000}'
}

# system info
showsysteminfo () {
  echo -ne "${LIGHTRED}PRODUCT$NC\t";cat /sys/class/dmi/id/product_name
  echo -ne "${LIGHTRED} VENDOR$NC\t";cat /sys/class/dmi/id/sys_vendor | tr -c '[[:print:]]' ' ';printf "\n"
#  echo -ne "${LIGHTRED}   BIOS$NC\t";cat /sys/class/dmi/id/bios_version
  echo -ne "${LIGHTRED}    CPU$NC";sed -nr  's/model name[^:*]: (.*)/\t\1/p' /proc/cpuinfo
  echo -ne "${LIGHTRED}    GPU$NC\t";glxinfo -l | sed -nr 's/.*Device\:\ |.*Video\ memory\:\ (.*)/\1/p' | awk '{printf("%s ",$0)}END{printf("\n")}'
  echo -ne "${LIGHTRED}NETWORK$NC\t";lspci | awk '/Network controller/{$1="";$2="";$3="";print}'|sed -nr "s/^\s*(.*)/\1/p"
  echo -ne "${LIGHTRED} MEMORY$NC\t";awk '/MemTotal/{mt=$2};/MemFree/{mf=$2};/MemAvail/{ma=$2}END{print "Total: "mt" | Free: "mf" | Available: "ma" (kB)"}' /proc/meminfo
  echo -ne "${LIGHTRED}     OS$NC\t";lsb_release -cds|awk '{printf("%s ", $0)}';uname -m
  echo -ne "${LIGHTRED} KERNEL$NC\t";uname -a | awk '{ print $3 }'
  echo -ne "${LIGHTRED} UPTIME$NC\t";uptime -p
#  echo -ne "${LIGHTRED}  USERS$NC\t";w -h | awk '{print $1}'|uniq|awk '{users=users$1" "}END{print users}'
  echo -ne "${LIGHTRED} TEMPER$NC\t";echo "$(showcputemp)°"
  echo -ne "${LIGHTRED}BATTERY$NC\t";echo "$(showbattery)"
  echo -ne "${LIGHTRED}DISPLAY$NC\t";echo "$(xdpyinfo | awk '/dimensions:/{print $2}')"
  echo -ne "${LIGHTRED}PACKGES$NC\t";dpkg -l | grep -E '^ii|^hi' | wc -l
#  echo -ne "${LIGHTRED}   DISK$NC";df -h | awk '/\/dev\/sd|\/mnt\//{print "\t"$0}'
  echo -ne "${LIGHTRED}   DISK$NC";lsblk -I8,259 -o +FSTYPE -o NAME,SIZE,FSTYPE,LABEL,MOUNTPOINT | tail -n+2 | awk '{print "\t"$0}'
}

# monitors the network activity
shownetstat()
{
#  watch --color -tn1 sudo grc 'netstat -tuapn4|tail -n+3|grep -v "\(systemd-resolv\|FIN_WAIT1\|FIN_WAIT2\|TIME_WAIT\\)"'
#  watch --color -tn1 sudo grc 'netstat -tuapn|tail -n+3|grep -v "\(systemd-resolv\|cupsd\|FIN_WAIT1\|FIN_WAIT2\|TIME_WAIT\\)"'
#  watch --color -tn1 sudo grc 'ss -tuapn4|tail -n+2|grep -v "\(systemd-resolv\|cupsd\|FIN_WAIT1\|FIN_WAIT2\|TIME_WAIT\\)"'
#  watch --color -tn1 sudo grc 'ss -tuapn4|tail -n+2|grep -v "\(systemd-resolv\|FIN_WAIT1\|FIN_WAIT2\|TIME_WAIT\\)"'
watch --color -tn1 sudo grc --colour=on 'ss -tuapn | awk '\''{if(NR>1){if(0==match($0,/systemd-resolv|FIN-WAIT-1|FIN-WAIT-2|TIME-WAIT|LAST-ACK|SYN-SENT/)){gsub(/\s+/," ");gsub(/users:\(\(|\)\)/,"");;print}}}'\'
}

# remove last n records from history
delhistory() {
  local opt id n=1
  OPTIND=1 #reset index
  while getopts "n:" opt; do
    case $opt in
      n)  n=$OPTARG ;;
      \?) return 1 ;;
      :)  echo "Option -$OPTARG requires number of history last entries to remove as an argument" >&2;return 1 ;;
    esac
  done

  ((++n));id=$(history | tail -n $n | head -n1 | awk '{print $1}')
  while ((n-- > 0)); do history -d "$id"; done
}

# poor man's mpd client
mpc() {
  echo "$@" | nc -q0 "$MPDSERVER" 6600
}

# mpd status display in the upper right terminal corner
mpdd() {
  local _r _l _p
  while sleep 1; do
    _r=$(awk 'BEGIN{FS=": "}
                /^Artist:/{r=r""$2};
                /^Title:/{r=r" - "$2};
                /^time:/{r=$2" "r};
                /^state: play/{f=1}
              END{if(f==1){print r}}' <(mpc status;mpc currentsong));

    _l=${#_r};
    [[ $_l -eq 0 ]] && continue;
    [[ -z "$_p" ]] && _p=$_l;
    echo -ne "\e[s\e[0;${_p}H\e[K\e[u";
    _p=$((COLUMNS - _l));
    echo -ne "\e[s\e[0;${_p}H\e[K\e[0;44m\e[1;33m${_r}\e[0m\e[u";
  done
}

# returns album art for the "artist - album" input string
# todo: do we need only [,] to be removed or some other chars too? 
getart() {
  [[ -z "$ARTDIR" ]] && local ARTDIR="$HOME/.cache/albumart"
  [[ -d "$ARTDIR" ]] || mkdir -p "$ARTDIR"

  local mpccurrent artfile
  mpccurrent="$(echo "$@"|sed -r 's/(\[|\]|\,)//g')"
  artfile=$(find "$ARTDIR" -iname "${mpccurrent}*")
  [[ -z "$artfile" ]] && {
    # customize useragent at http://whatsmyuseragent.com/
    local useragent='Mozilla/5.0 (X11; Ubuntu; Linux i686; rv:31.0) Gecko/20100101 Firefox/31.0'
    local link imagelink ext imagepath
    link="www.google.com/search?q=$(urlencode "$mpccurrent")\&tbm=isch"
#    imagelinks=$(wget -e robots=off --user-agent "$useragent" -qO - "$link" | sed 's/</\n</g' | grep '<a href.*\(png\|jpg\|jpeg\)' | sed 's/.*imgurl=\([^&]*\)\&.*/\1/')
#    imagelinks=$(timeout 10s wget -e robots=off --user-agent "$useragent" -o /dev/null -qO - "$link" | tee /tmp/out | sed 's/</\n</g' | grep "ou\":\"http" | sed -nr 's/.*ou\":\"([^"]+).*/\1/p')
    imagelinks=$(timeout 10s wget -e robots=off --user-agent "$useragent" -o /dev/null -qO - "$link" | tee /tmp/out | sed 's/</\n</g' | sed -nr 's/<img.*src="(http[^"]+).*/\1/p')
    for imagelink in $imagelinks; do
#      imagelink=$(echo "$imagelink" | sed -nr 's/(.*\.(jpg|jpeg|png)).*/\1/p')
#      ext=$(echo "$imagelink" | sed -nr 's/.*(\.(jpg|jpeg|png)).*/\1/p')
#      imagepath="${ARTDIR}/${mpccurrent}${ext}"
      imagepath="${ARTDIR}/${mpccurrent}"
      timeout 10s wget --max-redirect 0 -o /dev/null -qO "$imagepath" "${imagelink}"
      [[ -s "$imagepath" ]] && break
      rm "$imagepath" # remove zero length file
    done
    artfile=$(find "$ARTDIR" -iname "${mpccurrent}*")
  }
  echo "$artfile"
}

# sends notifications for the new title
notifyart() {
  local artist="$1"
  local title="$2"
  local album="$3"
  [[ -z "$album" ]] && album="$title"
  notify-send "$title" "$artist" -i "$(getart "$artist - $album")" -t 5000
}

notifympd() {
  local artist album title oldartist oldtitle
  while true; do
    artist=$(mpc currentsong | awk -F": " '/^Artist:/{print $2}')
    title=$(mpc currentsong | awk -F": " '/^Title:/{print $2}')
    album=$(mpc currentsong | awk -F": " '/^Album:/{print $2}')
    [[ "$artist" != "$oldartist" ]] || [[ "$title" != "$oldtitle" ]] && {
      notifyart "$artist" "$title" "$album"
      oldartist="$artist"
      oldtitle="$title"
    } 
    sleep 2
  done
}

# purge all packages marked as rc with the dpkg
purgerc() {
  dpkg -l | grep "^rc" | cut -d " " -f 3 | xargs sudo dpkg --purge
}

# force file system recheck at new boot
forcefsck() {
  sudo touch /forcefsck
}

# shows up/down seconds counter. Exits and produces a sound if reaches zero
timer() {
  local ts=$(($(date +%s)+${1:-0}-1))
  export ts
  local p1='d=$(($(date +%s)-$ts));[ $d -lt 0 ] && d=$((-d));'
  local p2='[ $d -eq 0 ] && exit 1;'
  local p3='date -u -d @"$d" +"%H.%M.%S"'
  showbanner -t.5 $p1$p2$p3
  local status=$?
  eval "$p1$p3"
  [[ $status -eq 8 ]] && speaker-test -t sine -f 1500 -S 70 -p 10000 -l 1 &>/dev/null
}

# shows a deb package direct dependenies graph
printdebtree() {
  debtree $1 -I --condense --no-alternatives --no-provides --no-recommends --no-conflicts | tred | dot -Tsvg
}
showdebtree() {
  # rsvg-view-3 is not shipped any longer. The librsvg2-bin package
  # still has rsvg-convert utility.
  # TODO zathura is hardcoded
  # we could register any pdf viewer like this:
  # xdg-mime default org.pwmt.zathura.desktop application/pdf
  # and then query the info
  # xdg-mime query default application/pdf
  # then the desktop file needs to found and parsed to get the app name
  # printdebtree $1 | rsvg-view-3 /dev/stdin
  printdebtree $1 | rsvg-convert -u -f pdf | zathura -
}

# shows kernel graph
showkernelgraph() {
lsmod | perl -e 'print "digraph \"lsmod\" {";
                 <>;
                 while(<>){
                   @_=split/\s+/;
                   print "\"$_[0]\" -> \"$_\"\n" for split/,/,$_[3]
                 }
                 print "}"' | dot -Tsvg | rsvg-view-3 /dev/stdin
}

# converts text into a qr code
qrcode() {
  local text=$1
  [[ -e "$text" ]] && text=$(cat "$text")
  [[ -z "$text" ]] && [[ ! -t 0 ]] && text=$(cat -)
  [[ -z "$text" ]] && text=$(printclip)
  if [[ -n "which qrencode" ]]; then
     qrencode -t UTF8 "$text"
  else
     wget -q -O- qrenco.de/$(urlencode "$text")
  fi
#  echo "$text" | curl -F-=\<- qrenco.de
}

# shows connected stationss in hotspot mode
show_wifi_clients() {
  #!/bin/bash
  # show_wifi_clients.sh
  # Shows MAC, IP address and any hostname info for all connected wifi devices
  # written for openwrt 12.09 Attitude Adjustment
  # modified by romano@rgtti.com from http://wiki.openwrt.org/doc/faq/faq.wireless#how.to.get.a.list.of.connected.clients
  echo    "# All connected wifi devices, with IP address,"
  echo    "# hostname (if available), and MAC address."
  printf  "# %-20s %-30s %-20s\n" "IP address" "lease name" "MAC address"
  leasefile=/var/lib/misc/dnsmasq.leases
  # list all wireless network interfaces
  # (for MAC80211 driver; see wiki article for alternative commands)
  for interface in `iw dev | grep Interface | cut -f 2 -s -d" "`
  do
    # for each interface, get mac addresses of connected stations/clients
    maclist=`iw dev $interface station dump | grep Station | cut -f 2 -s -d" "`
    # for each mac address in that list...
    for mac in $maclist
    do
      # If a DHCP lease has been given out by dnsmasq,
      # save it.
      ip="UNKN"
      host=""
      ip=`cat $leasefile | cut -f 2,3,4 -s -d" " | grep $mac | cut -f 2 -s -d" "`
      host=`cat $leasefile | cut -f 2,3,4 -s -d" " | grep $mac | cut -f 3 -s -d" "`
      # ... show the mac address:
      printf "  %-20s %-30s %-20s\n" $ip $host $mac
    done
  done
}

ascii() {
  for i in {0..255};do p="  $i";echo -e "${p: -3} $(printf '%02X' $i) \\0$(($i/64*100+$i%64/8*10+$i%8))";done|cat -t|column -c120
}

dusort() {
#  IFS='\n' \du -sh "$@" | sort -h | grcat conf.du
  \du -sh "$@" | sort -h | grcat conf.du
}

#list servicesd
listd() {
  echo -e ${RED}${BOLD}" --> SYSTEM LEVEL <--"${NC}
  find /etc/systemd/system -mindepth 1 -type d | sed '/getty.target/d' | xargs ls -gG --color
  [[ $(find $HOME/.config/systemd/user -mindepth 1 -type d | wc -l) -eq 0 ]] || {
    echo -e ${RED}${BOLD}" --> USER LEVEL <--"${NC}
    find $HOME/.config/systemd/user -mindepth 1 -type d | xargs ls -gG --color
  }
}

grabpage() {
  wget --no-clobber -e robots=off --recursive --convert-links  --html-extension --page-requisites --no-parent "$1"
}

imgur() {
  # This function reads imgur client id from the IMGUR_ID var or from the keyring
  #   python3 -c 'import keyring; print(keyring.get_password("imgur","'"$USER"'"))'
  # One could put the imgur client id into the keyring using the following command:
  #   python3 -c 'import keyring; keyring.set_password("imgur","'"$USER"'", "MY_CLIENT_ID")'
  # where MY_CLIENT_ID is the token string obtained from https://api.imgur.com/oauth2/addclient

  clientid=${IMGUR_ID}
  [ -n "$clientid" ] || clientid=$(python3 -c 'import keyring; print(keyring.get_password("imgur","'"$USER"'"))')
  [ -n "$clientid" ] || printf "No imgur client id specified. Get one using https://api.imgur.com/oauth2/addclient\n"
  img="$1"
  [ -e "$img" ] || {
    img=$(mktemp '/tmp/imgur-XXXXXX.png')
    scrot -s "$@" $img >/dev/null 2>&1 || exit
    is_scrshot_created=1
    printf "Upload the screenshot [y/n]? "; read LINE; [ "y" = "$LINE" ] || exit
  }
  res=$(curl -sH "Authorization: Client-ID $clientid" -F "image=@$img" "https://api.imgur.com/3/upload")

  echo $res | grep -qo '"status":200' && link=$(echo $res | sed -e 's/.*"link":"\([^"]*\).*/\1/' -e 's/\\//g')
  if test -n "$link"; then
    printf $link | tee /dev/stderr | xclip -i -sel c; printf "\n"
  else
    echo "$res" > "/dev/stderr"
  fi

  [ -n "$is_scrshot_created" ] && rm "$img"
}

# empty user trash
emptytrash() {
  local flist=$(gio list trash://);
  [[ ! $flist =~ ^$ ]] && {
    printf "$flist\n\n"
    read -p "Empty trash [y|n]:" -n1 -r
    [[ $REPLY =~ ^[Yy]$ ]] && gio trash --empty;echo
  }
}

lstrash() {
  gio list trash://
}

# converts hex color string (like #FFAABB) to a terminal
# color index and also shows the color in the terminal
function colorfromhex() {
  [ -n "$1" ] || return 1
  hex=$1
  if [[ $1 == "#"* ]]; then
    hex=$(echo $1 | awk '{print substr($0,2)}')
  fi
  r=$(printf '0x%0.2s' "$hex")
  g=$(printf '0x%0.2s' "${hex#??}")
  b=$(printf '0x%0.2s' "${hex#????}")

  color=$(printf "%03d" "$(((r<75?0:(r-35)/40)*6*6+(g<75?0:(g-35)/40)*6+(b<75?0:(b-35)/40)+16))")

  echo -en "\e[38;5;${color}m ${color}\t\e[0m"
  echo -en "\e[48;5;${color}m ${color}\e[0m\n"
}

# shows image GPS information
function showgpsimage()
{
  [ -n "$1" ] || return 1
  [ -n "$(which identify)" ] || return 2
  identify -verbose "$1" | awk 'function cf(i){split(i,a,"/");if(length(a)==2){return a[1]/a[2]}else{return a[1]}}/GPS/{if($1~/GPSLatitude:|GPSLongitude:/){s=$0;gsub(/,/,"",$0);printf("%s  (%f)\n", s, $2+cf($3)/60+cf($4)/3600)}else{print}}'
}

# creates google maps link to the GPS coords from a picture
function showgpsimagelink()
{
  [ -n "$1" ] || return 1
  [ -n "$(which identify)" ] || return 2

  coords=$(identify -verbose "$1" |awk '/GPSLatitude|GPSLongitude/{if(NF==2){printf(", %s\n", $2)}else {printf("%s", $0)}}' | awk 'function cf(i){split(i,a,"/");if(length(a)==2){return a[1]/a[2]}else{return a[1]}}{s=$0;gsub(/,/,"",$0);if(NF==5){printf("%d°%d\x27%0.1f\"%s+",cf($2),cf($3),cf($4),$5)} }'|sed s/.$//)
  [ -n "$coords" ] && {
    echo "https://google.com/maps/place/${coords}"
  }
}

# creates yandex maps link to the GPS coords from a picture
function showgpsimagelinkyandex()
{
  [ -n "$1" ] || return 1
  [ -n "$(which identify)" ] || return 2

  coords=$(identify -verbose "$1" |awk '/GPSLatitude|GPSLongitude/{if(NF==2){printf(", %s\n", $2)}else {printf("%s", $0)}}' | sort -r | awk 'function cf(i){split(i,a,"/");if(length(a)==2){return a[1]/a[2]}else{return a[1]}}{s=$0;gsub(/,/,"",$0);if(NF==5){if($5 ~ /[^NE]/){printf("-")}printf("%f,",$2+cf($3)/60+cf($4)/3600)}}'|sed s/.$//)
  [ -n "$coords" ] && {
    echo "https://yandex.ru/maps/?ll=${coords}&mode=whatshere&whatshere[point]=${coords}&whatshere%5Bzoom%5D=13&z=13"
  }
}

function sun()
{
  # Image size is hardcoded in the URL as 512
  # Possible sizes: 170 256 512 1024 2048 3072 4096
  local explanation="$(cat <<HEREDOC
   From the sun's surface on out, the wavelengths SDO observes, measured in Angstroms, are:

    4500: Showing the sun's surface or photosphere.
    1700: Shows surface of the sun, as well as a layer of the sun's atmosphere called the chromosphere, which lies just above the photosphere and is where the temperature begins rising.
    1600: Shows a mixture between the upper photosphere and what's called the transition region, a region between the chromosphere and the upper most layer of the sun's atmosphere called the corona. The transition region is where the temperature rapidly rises.
     304: This light is emitted from the chromosphere and transition region.
     171: This wavelength shows the sun's atmosphere, or corona, when it's quiet. It also shows giant magnetic arcs known as coronal loops.
     193: Shows a slightly hotter region of the corona, and also the much hotter material of a solar flare.
     211: This wavelength shows hotter, magnetically active regions in the sun's corona.
     335: This wavelength also shows hotter, magnetically active regions in the corona.
      94: This highlights regions of the corona during a solar flare.
     131: The hottest material in a flare.'
HEREDOC
)"
  if [[ -z "$(which img2sixel)" ]];then
    printf "img2sixel is missing\n"
    printf "sudo apt install libsixel-bin\n"
    return 2
  fi
  local swla;local wla;local i
  wla[94]="0094";wla[131]="0131";wla[171]="0171";
  wla[193]="0193";wla[211]="0211";wla[304]="0304";
  wla[335]="0335";wla[1600]="1600";wla[1700]="1700";
  wla[4500]="4500"

  [[ -n "$1" ]] || set -- 171 # wavelength to use if no parameters

  if [[ "all" = "$1" ]]; then
    for i in "${!wla[@]}";do [[ "$i" -gt 0 ]] && swla=(${swla[@]} "$i");done
  else
    while [[ -n "$1" ]]; do
      if [[ -n "${wla[$1]}" ]]; then
        swla=(${swla[@]} "$1")
      else
        unset swla
        break
      fi
      shift
    done
  fi

  [[ "${#swla[@]}" -gt 0 ]] || {
    printf "Usage: '${FUNCNAME[0]} [all|wavelength1 wavelength2 ..]' where possible wavelenghs are:\n"
    printf "        ";for i in "${!wla[@]}"; do printf "%s " "$i"; done
    printf "\n\n"
    printf "${explanation}\n"
    return 1
  }
  for i in "${swla[@]}";do
    wget -qO- "https://sdo.gsfc.nasa.gov/assets/img/latest/latest_512_${wla[$i]}.jpg" | img2sixel
  done
}

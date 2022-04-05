# Don't wait for job termination notification
set -o notify
shopt -s dotglob
shopt -s histappend

# Ignore some controlling instructions
export HISTIGNORE="[   ]*:&:bg:fg:exit:ls:la:ll:l:ps:df:vim:vi:man*:info*:exit:dmesg:ifconfig:route:gs:gd:gl:cd"
export HISTSIZE=-1     # unlimited
export HISTFILESIZE=-1 # unlimited
export HISTFILE=~/.bash_eternal_history
export HISTTIMEFORMAT='%F %T '
export EDITOR=vi
export PAGER=less
export BANNER="echo"
[[ -n "$(which banner 2>/dev/null)" ]] && export BANNER="banner"
[[ -n "$(which figlet 2>/dev/null)" ]] && export BANNER="figlet -f banner"
[[ -n "$(which toilet 2>/dev/null)" ]] && export BANNER="toilet -f mono9.tlf"
# setting the temp directory for vim
[ -z $TEMP ] && export TEMP=/tmp
export MPDSERVER=dir860.lan


# aliases
alias less='less -r'                          # raw control characters
alias grep='grep --color'                     # show differences in colour
alias gr='grep -HEnri'                        #
alias rm='gio trash'                          # safe rm

# my shortcuts
alias abspath='readlink -f'
alias feh='feh -g 800x600 -d -.'
alias ne='stdbuf -oL sed "s,\x1B\[[0-9;]*[a-zA-Z],,g"'
alias nocr='stdbuf -oL sed "s,\x0D,,g"'
alias c='printf "\33[2J"'
alias sss='bc64=( {a..z} {A..Z} {0..9} + / = );c;while true; do echo -ne "\033[$((1+RANDOM%LINES));$((1+RANDOM%COLUMNS))H\033[$((RANDOM%2));3$((RANDOM%8))m${bc64[$((RANDOM%${#bc64[@]}))]}"; sleep 0.1 ; done'
alias p4='unset PWD; p4 '
alias ff='wget randomfunfacts.com -O - 2>/dev/null | grep \<strong\> | sed "s;^.*<i>\(.*\)</i>.*$;\1;"'
alias genpass='read -s tmppass; echo -n "$tmppass->"; echo $tmppass | md5sum | base64 | cut -c -16; unset tmppass'
alias 2edit='xsel -b;n=pipe$RANDOM;xdotool exec --terminator -- mousepad $n -- search --sync --onlyvisible --name $n key --window %1 ctrl+v ctrl+Home'
alias 2win='xsel -b;n=pipe$RANDOM;xdotool exec --terminator -- subl $n -- search --sync --onlyvisible --name $n key --window %1 ctrl+v ctrl+Home'
alias readpass='echo -n $(read -s passwd_;echo -n $passwd_)'
alias cdh='cd ~'
alias top10='ps aux --sort -rss | head -n11'
alias traf='netstat -np | grep -v unix'
alias why='apt-cache rdepends --installed'
alias exit='pwd >~/.lastdir;exit'
alias cdl='cd "$(cat ~/.lastdir)"'
alias tb='nc termbin.com 9999'
alias smile='printf "$(awk  '\''BEGIN{c=127;while(c++<191){printf("\xf0\x9f\x98\\%s",sprintf("%o",c));}}'\'')"'
alias pseudo='printf "$(awk  '\''BEGIN{c=127;while(c++<191){printf("\xe2\x96\\%s",sprintf("%o",c));}}'\'')"'

# git shortcuts
alias gc='git checkout'
alias gcb='git checkout -branch'
alias ga='git add'
alias gap='git add -p'
alias gs='git status'
alias gl='git log'
alias gb='git branch'
alias gd='git diff'
alias gcm='git commit -m'
alias glb='git log --graph --simplify-by-decoration --pretty=format:'%d' --all'

#coloring some programs using grc (check /usr/share/grc)
[[ -s "/etc/grc.bashrc" ]] && {
  source /etc/grc.bashrc
  alias hexdump='colourify hexdump'
  alias ps='colourify  ps -A'
  alias diff='colourify -c conf.diff diff'
  alias ls='colourify ls -X -hF --color=yes --group-directories-first'
}

alias hl='highlight --style olive -O xterm256'

alias showtemp='showbanner -t 20 '\''echo "temp: "$(ssh root@buffalo.lan /mnt/sd/bin/readavrstick)°'\'''
alias showclock='showbanner "date +%T"'

 
# some cygwin related patches
# Terminal capabilities
if [ "$OSTYPE" = "cygwin" ]; then
  alias cs='cygstart'
  if [ -f ${HOME}/.termcap ]; then
    TERMCAP=$(< ${HOME}/.termcap)
    export TERMCAP
  fi
  if [ -x /usr/bin/tput ]; then
    LINES=$(tput lines)
    export LINES
    COLUMNS=$(tput cols)
    export COLUMNS 
  fi
  # set PATH so it includes user's private bin if it exists
  if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
  fi
  # dircolors
  test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
fi

# generated prompt line
#PROMPT_COMMAND="history -a;history -n;$PROMPT_COMMAND"
PROMPT_COMMAND="history -a;$PROMPT_COMMAND"
[ "$TERM" = "linux" ] || source ${HOME}/bin/shellpromptfull.sh
# custom functions
source ${HOME}/bin/shellfunctions.sh
# colors
source ${HOME}/bin/shellcolors.sh
#PROMPT_COMMAND="history -a;history -n;$PROMPT_COMMAND"

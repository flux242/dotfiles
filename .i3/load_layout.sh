#!/bin/sh

# Note: -title option is important and is proven to be compatible with:
#        - xfce4-terminal ( through the xfce4-terminal-wrapper
#        - urxvt        

i3-msg "workspace 1; append_layout ~/.i3/workspace2.json"

(x-terminal-emulator -title TerminalTailSyslog -e sh -c 'env PROMPT_COMMAND="unset PROMPT_COMMAND; tail -F /var/log/syslog" bash') &
(x-terminal-emulator -title TerminalDmesg -e sh -c 'env PROMPT_COMMAND="unset PROMPT_COMMAND; dmesg -wt" bash') &
(x-terminal-emulator -title TerminalShownetstat -e sh -c 'env PROMPT_COMMAND="unset PROMPT_COMMAND; shownetstat" bash') &
(x-terminal-emulator -title TerminalWork -e 'bash') &


#!/bin/sh

i3-msg "workspace 1; append_layout ~/.i3/workspace1.json"

(xfce4-terminal -T TerminalTailSyslog -e 'env PROMPT_COMMAND="unset PROMPT_COMMAND; tail -F /var/log/syslog" bash') &
(xfce4-terminal -T TerminalShownetstat -e 'env PROMPT_COMMAND="unset PROMPT_COMMAND; shownetstat" bash') &
(xfce4-terminal -T TerminalWork -e 'bash') &


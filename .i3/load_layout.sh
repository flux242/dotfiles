#!/bin/sh

i3-msg "workspace 1; append_layout ~/.i3/workspace1.json"

(x-terminal-emulator -T TerminalTailSyslog -e 'env PROMPT_COMMAND="unset PROMPT_COMMAND; tail -F /var/log/syslog" bash') &
(x-terminal-emulator -T TerminalShownetstat -e 'env PROMPT_COMMAND="unset PROMPT_COMMAND; shownetstat" bash') &
(x-terminal-emulator -T TerminalWork -e 'bash') &


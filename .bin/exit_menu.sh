#!/usr/bin/env bash

[ $(echo -e 'YES\nNO' | dmenu -sb '#ff6600' -fn \
'-misc-fixed-medium-r-normal--20-140-100-100-c-100-iso8859-1' -i -p "Do you really want to exit? This \
will end your session") = "YES" ] && i3-msg exit


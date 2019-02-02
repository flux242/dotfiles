#!/bin/sh

#$(find ~/Applications/ -iname 'welle.io*')
$(find ~/Applications/ -iname 'welle.io*' -exec sh -c '[ -x "{}" ] && echo "{}"' \;)

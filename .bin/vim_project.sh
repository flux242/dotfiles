#!/usr/bin/env bash

PROJDIR=$1
[[ -z "$PROJDIR" ]] || [[ ! -d "$PROJDIR" ]] && {
  PROJDIR=$(pwd)
  echo "Project dir is not specified, using current directory - $PROJDIR" >&2
#  exit 1
}

PROJDIR=$(realpath "$PROJDIR")
export PROJDIR
cd "$PROJDIR" || exit 1
ctags -R ./
vim -c ":NERDTree $PROJDIR" 


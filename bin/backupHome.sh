#!/bin/bash

homeDir=$HOME
destDir=~/media/nas/Alex/backup
archName="$(whoami).$(hostname)"
destHost='flux@dns325.lan'
destDir="/mnt/nas/Alex/backup/$(hostname)"

# files or directories to exclude
printExcludes()
{
awk '{printf("--exclude='\''%s'\'' ",$1)}'  <<EOEXCL
Android
.AndroidStudio3.5
.android
.bin
.gvfs
.gradle
.qt
.adobe
.aptitude
.dbus
.gconf
.eagle
.gradle
.macromedia
.gnome
.java
.cache
.links2
.openshot_qt
.pulse*
.platformio
.smbcredentials
.ssh
.thumbnails
.vimrc
.vim
.Xauthority
.xchm
.xsession-errors
.local/share/vifm
.local/share/Trash
Books
Downloads
games
Music
Videos
Pictures
VirtualBox*
bin
dotfiles
media
.git
projects/fres*
projects/electro*
projects/openw*
ssmtp
STM32Cube
tags
EOEXCL
}

~/bin/cleanHome.sh || exit 1


echo "rsync -arv --delete --no-links $(printExcludes) $homeDir $destHost:$destDir"
eval "rsync -arv --delete --no-links $(printExcludes) $homeDir "$destHost:$destDir""
exit 0


# creating an archive
if [ -d "$destDir" ]; then
  exe="tar -czf "${destDir}/${archName}.$(date +%Y-%m-%d).tgz" $(printExcludes) -C $homeDir ./"
  echo "$exe" 
  eval "$exe" 
else
  echo "ERROR: Directory $destDir doesn't exist. Canno't create an archive"
  exit 1
fi


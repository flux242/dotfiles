# Firejail profile for default
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/welle.io.local
# Persistent global definitions
include /etc/firejail/globals.local

# generic gui profile
# depending on your usage, you can enable some of the commands below:

noblacklist ${HOME}/.config/welle.io

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

include /etc/firejail/whitelist-var-common.inc

caps.drop all
# ipc-namespace
netfilter
# no3d
nodvd
nogroups
nonewprivs
noroot
# nosound
notv
novideo
protocol unix,inet,inet6,netlink
seccomp


# disable-mnt
# private
# private-bin program
#private-dev
# private-etc none
# private-lib
private-tmp

# memory-deny-write-execute
#noexec ${HOME}
noexec /tmp
#read-only ${HOME}/
read-write ${HOME}/.config/welle.io/

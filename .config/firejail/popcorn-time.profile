# Firejail profile for Popcorn-Time
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/popcorn-time.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ~/.Popcorn-Time
noblacklist ~/.pki

noblacklist ${HOME}/.cache/
noblacklist ${HOME}/.config/
noblacklist ${HOME}/.pki


include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

#mkdir ~/.cache/Popcorn-Time
#mkdir ~/.config/Popcorn-Time
#mkdir ~/.pki
whitelist ${DOWNLOADS}
#whitelist ~/.cache/Popcorn-Time
#whitelist ~/.config/Popcorn-Time
whitelist ~/.pki
whitelist ~/.config
whitelist ~/.cache
include /etc/firejail/whitelist-common.inc

#caps.keep sys_chroot,sys_admin
caps.drop all 
netfilter
nodvd
nogroups
notv
novideo
seccomp
#seccomp.drop @clock,@cpu-emulation,@debug,@module,@obsolete,@reboot,@resources,@swap,acct,add_key,bpf,chroot,fanotify_init,io_cancel,io_destroy,io_getevents,io_setup,io_submit,iopl,ioprio_set,kcmp,keyctl,mount,name_to_handle_at,nfsservctl,ni_syscall,open_by_handle_at,pciconfig_iobase,pciconfig_read,pciconfig_write,pivot_root,remap_file_pages,request_key,s390_mmio_read,s390_mmio_write,setdomainname,sethostname,syslog,umount,umount2,userfaultfd,vhangup,vmsplice
shell none
#protocol unix,inet,inet6,netlink

disable-mnt
private-dev
private-tmp

noexec ${HOME}
noexec /tmp


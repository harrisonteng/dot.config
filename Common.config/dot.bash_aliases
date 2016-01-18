alias memsucker='ps aux|sort -nrk 4|head'
alias vie='vim -u NORC'
alias svilla='ssh harrison@villa.enterprisemailer.net';
alias sbones='ssh harrison@bones.enterprisemailer.net';
alias sswindon='ssh harrison@swindon.m4internet.com';
alias tswindon='ssh -L 3390:swindon.m4internet.com:3389 harrison.teng@bastion.m4internet.com';
alias vswindon='ssh -L 6900:swindon.m4internet.com:5900 harrison.teng@bastion.m4internet.com';
#alias tvilla='ssh -L 3391:villa.enterprisemailer.net:3389 harrison.teng@bastion.m4internet.com';
alias tvilla='ssh -L 3391:216.13.249.148:3389 harrison.teng@bastion.m4internet.com';
alias vvilla='ssh -L 6901:villa.enterprisemailer.net:5900 harrison.teng@bastion.m4internet.com';
alias svilla='ssh Administrator@villa.enterprisemailer.net';
alias tbones='ssh -L 3392:bones.enterprisemailer.net:3389 harrison.teng@bastion.m4internet.com';
alias vbones='ssh -L 6902:bones.enterprisemailer.net:5900 harrison.teng@bastion.m4internet.com';
alias trazor='ssh -L 3393:razor.m4internet.com:3389 harrison.teng@bastion.m4internet.com';
alias vrazor='ssh -L 6903:razor.m4internet.com:5900 harrison.teng@bastion.m4internet.com';
alias srazor='ssh Administrator@razor.m4internet.com "/bin/bash -i"';
alias psswindon='srdp "c:\windows\system32\WindowsPowerShell\v1.0\powershell.exe" localhost:3390'
alias pst='ps -ALeo pid,tid,class,rtprio,stat,comm,wchan'
alias hpstree='ps -aef --forest'


alias tfuseweb2a='sudo ssh -l root -L 2333:fuseweb2a.electric.net:22 harrison.teng@bastion1.electric.net'

alias sbastion1='ssh harrison.teng@bastion1.electric.net'
alias sbastion2='ssh -A -i ~/.ssh/id_rsa_bastion2 harrison.teng@bastion2.electric.net'
alias sbastion3='ssh -A -i ~/.ssh/id_rsa_bastion2 harrison.teng@bastion3.electric.net'

alias smbacct='sudo smbmount //egret.electric.net/accounting /mnt/accounting -o username=harrison.teng'
alias smbpub='sudo smbmount //egret.electric.net/public /mnt/public -o username=harrison.teng'

alias cb='pushd +1 >/dev/null'
alias cf='pushd -0 >/dev/null'

alias temcsvn='ssh -L 2222:svn.electric.net:22 harrison.teng@bastion3ai.electric.net'
alias temcsvn3a='ssh -L 2223:svn3a.electric.net:22 harrison.teng@bastion3ai.electric.net'
alias envemcsvn='export SVN_SSH="ssh -l harrison.teng";export SVN_ROOT="svn+ssh://harrison.teng@127.0.0.1/svn/"'

alias ack='/usr/bin/ack-grep'

# time last accessed == atime
alias ldc='ls -lud' 
# time last written to == mtime
alias ldw='ls -ld'
# last time filesystem metadata for the directory changed (inode) == ctime
alias ldm='ls -lctd'

#BSD
alias upports='portupgrade -var'
alias upportsbin='portupgrade -varPP'
alias portsdistclean='rm -rf /usr/ports/distfiles'
alias portsmakeclean='portsclean -CD'
alias pkgsup='pkg_version -vIL='

#conky

#KVM
kvminstall='virt-install --connect qemu:///system -n homeserver -r 2048 -vcpus=1 --disk path=/var/lib/libvirt/images/homeserver.img,size=80 -c /disk2/installation/homeserver/Windows.Home.Server.OEM.Install.DVD.iso --vnc --noautoconsole --os-type windows --accelerate --network=bridge:br0 --hvm'
kvmviewer='virt-viewer -c qemu:///system ob54'

#emacs daemon
emacsdaemon='emacs --daemon --background-color=black --foreground-color=white'
#emacsdaemon='emacs --daemon --eval "(setq default-frame-alist '((font-backend . \"xft\") (set-background-color \"black\") (set-foreground-color \"white\") (font . \"-unknown-DejaVu SansMono-normal-normal-normal-*-12-*-*-*-m-0-iso10646-1\")))"
#/usr/local/emacs24/bin/emacs --daemon --eval "(setq default-frame-alist '((font-backend . \"xft\") (set-background-color \"black\") (set-foreground-color \"white\") (font . \"-unknown-DejaVu SansMono-normal-normal-normal-*-13-*-*-*-m-0-iso10646-1\")))"
#emacsclient='emacsclient -c -n -e \\'(load "~/.emacs.d/clientinit.el")\\''

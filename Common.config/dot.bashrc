# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

GREP=`which grep`
SED=`which sed`
EGREP=`which egrep`

# get our OS type
UNAME=`uname -a`;
        case $UNAME in
                (SunOS|Solaris)
                ;;
                (Ubuntu|Debian)
                        # make less more friendly for non-text input files, see lesspipe(1)
                        [ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"
                ;;
                (funtoo|gentoo)
                        export LESSOPEN="|lesspipe.sh %s"
                        export LESSCOLORIZER=pygmentize
                ;;
        esac

# don't put duplicate lines in the history. See bash(1) for more options
export HISTCONTROL=ignoredups
# ... and ignore same sucessive entries.
export HISTCONTROL=ignoreboth

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

_chomp_path() {
    local path=${1/${HOME}/\~}
    local last=${path} sedout= count=0 count2=0
    sedout=$(echo ${path} | sed -e 's:/: :g')
    for i in ${sedout}; do
        (( count++ ))
    done
    if ((count > 2)); then
        last="..."
        for i in ${sedout}; do
        (( count2++ ))
        if (( count2 >=  count - 1 )); then
            last+="/$i"
        fi
        done
    fi
    echo ${last}
}


#PS1='\[\033[1;34m\]\u \[\033[1;32m\]@\[\033[1;34m\] \h \[\033[1;30m\]::\[\033[1;37m\] $(_chomp_path $(pwd)) \[\033[1;30m\]%%\[\033[0m\] '

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    #PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
    #PS1='${debian_chroot:+($debian_chroot)}\[\033[1;34m\]\u\[\033[1;32m\]@\[\033[1;34m\]\h\[\033[1;30m\] \[\033[1;37m\]$(_chomp_path $(pwd))\[\033[1;30m\] \$\[\033[0m\] '
    PS1='${debian_chroot:+($debian_chroot)}\n\[\033[1;30m\]$(/bin/date "+%A %Y-%m-%d %H:%M:%S %p")\n\[\033[1;37m\][$(_chomp_path $(pwd))]\n\[\033[1;36m\]$(/bin/ls -1|/usr/bin/wc -l|"$SED" "s: ::g") items \[\033[1;33m\] $(/bin/ls -l |"$EGREP" "^(d|l)" |/usr/bin/wc -l|"$SED" "s: ::g") subdirs \[\033[1;32m\] $(/bin/ls -lah | "$GREP" -m 1 total | "$SED" "s/total //")b\[\033[0m\]\[\033[0m\]\n\[\033[1;34m\]\u\[\033[1;32m\]@\[\033[1;34m\]\h\[\033[1;30m\] \$\[\033[0m\] '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    #PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD/$HOME/~}\007"'
	#PROMPT_COMMAND='RET=$?; echo;if [ $RET != 0 ] ; then echo -ne "\E[47;31m""\033[1mRC:$RET\033[0m"; fi;'
    ;;
*)
    ;;
esac

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable color support of ls and also add handy aliases
if [ "$TERM" != "dumb" ] && [ -x /usr/bin/dircolors ]; then
    eval "`dircolors -b`"
    alias ls='ls --color=auto'
    #alias dir='ls --color=auto --format=vertical'
    #alias vdir='ls --color=auto --format=long'

    #alias grep='grep --color=auto'
    #alias fgrep='fgrep --color=auto'
    #alias egrep='egrep --color=auto'
fi

# some more ls aliases
#alias ll='ls -l'
#alias la='ls -A'
#alias l='ls -CF'


function spacesucker {
        du -h | perl -e 'sub h{%h=(K=>10,M=>20,G=>30);($n,$u)=shift=~/([0-9.]+)(\D)/;return $n*2**$h{$u}}print sort{h($b)<=>h($a)}<>;'
	#below one should handle mounted pionts
	#perl -MList::MoreUtils=any -lne 'BEGIN{@m=map {@F=split; qq(^$F[2])} map {$1 if m{(.*)}} qx{mount|tail --line=+2}; open STDIN, q(find / -maxdepth 3 -mindepth 1 |)} $p=$_; do {print join qq(\t), qx(du -s "$_")=~m{(.*)}} unless any {$p=~m{$_} or $_=~m{$p}} @m' | sort -k1 -nrg | head
}

function screenshotdesktop () {
    local l_output=$1
        ffmpeg -f x11grab -s wxga -r 25 -i :0.0 -sameq ${l_output}
}

function getfiles () {
	local l_url=$1

	local l_cutdirs=`echo ${l_url} |awk -F/ '{print NF-4}'`
	
	if [ $# -lt 2 ];then
		wget -r --no-parent -nH --cut-dirs=${l_cutdirs} --level=0 ${l_url}
	else
		local l_u=$2
		local l_p=$3
		wget --user=${l_u} --password=${l_p} -r --no-parent -nH --cut-dirs=${l_cutdirs} --level=0 ${l_url} --restrict-file-names=nocontrol
	fi

}

function getsite () {
	local l_url=$1
	wget -U 'Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.6) Gecko/20070802 SeaMonkey/1.1.4' --recursive --no-clobber --page-requisites --html-extension --convert-links --restrict-file-names=windows --domains ${l_url} --no-parent ${l_url}
}

function getDate () {

        local l_epoch=$1;

	TMP=`date -d "19700101 + ${l_epoch} seconds"`;
	#echo `date -d '$(date -d "$TMP")' +%Y%m%d`;
	echo `date -d "$TMP" +%Y%m%d`;
}

function getDatebyDaysAgo () {

	local l_daysago=$1;
	#2011-Nov-13
	echo `date --date="-${l_daysago} days" +%Y-%b-%d`;

}

function getTime () {
	local l_epoch=$1
	date -d "19700101 + ${l_epoch} seconds GMT"
}

function getEpoch () {

        local l_datetime=$1;
	echo `date -d "${l_datetime}" +%s`;
}


function getCPUps () {
	local l_pid=$1
	top -b -d 1 -n 1 -p ${l_pid} | perl -lane '( ($i) = grep { $F[$_] =~ /CPU/ } 0..$#F ) and do{ $_=<>; @F=split; print $F[$i] };'
}

function getrpmfrombin () {
	local l_bin=$1
	rpm -qf ${l_bin}
}

function getPortStats () {
	local l_port=$1
	netstat -anp |grep -v 'grep' |grep -E "tcp(.*?)[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+:${l_port}(.*?)(LISTEN|ESTABLISHED)*"
}


function getvzdiskbygb () {
	local l_ingb=$1;
	
	result=`echo "scale=2;$l_ingb*1048576" | bc`;
	echo "$result is ${l_ingb}G";
}

function getvzinodesbygb () {
	local l_ingb=$1;
	
	result=`echo "scale=2;$l_ingb*200000" | bc`;
	echo "$result for ${l_ingb}G";
}                                                                                                                                                                              
function getvzmemorybynum () {
	local l_innum=$1;
	
	local l_pagesize=`getconf PAGE_SIZE`;
	echo "$l_innum is $((${l_innum}*${l_pagesize}/1024/1024/1024))G";
}                                                                                                                                                                              
function getvzmemorybygb () {
	local l_ingb=$1;
	
	local l_pagesize=`getconf PAGE_SIZE`;
	#or
	#echo $(($((NUMinMeg * 8 * 1024)) / $(($(getconf PAGE_SIZE) / 1024))))
	echo "${l_ingb}G is $((${l_ingb}*1024*1024*1024/${l_pagesize}))";
}        

#establish ssh tunnel
function tn () {
	local l_port=$1
	local l_rport=$2
	local l_dst=$3
	local l_proxy=$4
	ssh -L ${l_port}:${l_dst}:${l_rport} harrison.teng@${l_proxy}
}

#vnc over ssh tunnel
function tnvbastion1 () {
	local l_dst=$1
	vncviewer ${l_dst} -via harrison.teng@bastion1
}

#vSphere client for linux
function vm () {
	local l_vsphere_winbox=$1
	rdesktop -A -s "c:\seamlessrdp\seamlessrdpshell.exe \"C:\Program Files\VMware\Infrastructure\Virtual Infrastructure Client\Launcher\VpxClient.exe\"" ${l_vsphere_winbox}
}

function srdp () {
	#local l_wincmd=$1
	local l_vsphere_winbox=$1
	rdesktop -A -s "c:\seamlessrdp\seamlessrdpshell.exe \"c:\windows\system32\WindowsPowerShell\v1.0\powershell.exe\"" ${l_vsphere_winbox}
}

function getUt () {
	local l_filename=$1;
	local l_url=$2;
	perl -MWWW::Mechanize -e '$m = WWW::Mechanize->new; $output=$ARGV[0];$_=$ARGV[1]; ($i) = /v=(.+)/; s/%(..)/chr(hex($1))/ge for (($u) = $m->get($_)->content =~ /l_map": .+(?:%2C)?5%7C(.+?)"/); print $i, "\n"; $m->get($u, ":content_file" => "$output.flv")' "${l_filename}" "${l_url}"
}

function getIP () {
	local l_hostname=$1;
	perl -e "print join('.',unpack('W4',(gethostbyname('${l_hostname}'))[4]));";
}

function sipmi () {
	local l_hostname=$1;
	local l_username=$2;
	local l_proxy=$3;

	sudo ssh -L5900:${l_hostname}:5900 -L5901:${l_hostname}:5901 -L443:${l_hostname}:443 -L80:${l_hostname}:80 ${l_username}@${l_proxy};
}

function tviabastion {
	local l_remotehost;

	sudo ssh -L3333:${l_remotehost}:22 harrison.teng@bastion.m4internet.com
}

function showcolors {

	T='gTk'   # The test text

	echo -e "\n                 40m     41m     42m     43m\
	    44m     45m     46m     47m";

	for FGs in '    m' '   1m' '  30m' '1;30m' '  31m' '1;31m' '  32m' \
        	   '1;32m' '  33m' '1;33m' '  34m' '1;34m' '  35m' '1;35m' \
	           '  36m' '1;36m' '  37m' '1;37m';
	  	do FG=${FGs// /}
	  	echo -en " $FGs \033[$FG  $T  "
	  		for BG in 40m 41m 42m 43m 44m 45m 46m 47m;
	    			do echo -en "$EINS \033[$FG\033[$BG  $T  \033[0m";
	  		done
	  	echo;
	done
}

function dellastnlines {

	local l_dir=$1;
	local l_pattern_of_file=$2;
	local l_pattern_in_file=$3;
	local l_line=$4;

	for file in `find ${l_dir} -name "${l_pattern_of_file}" -exec grep -l "${l_pattern_in_file}" {} \;`;do 
		sed -i -e :a -e "$d;N;2,${l_line}ba" -e 'P;D' $file;
	done
}

function delspecificline {

	local l_dir=$1;
	local l_pattern_of_file=$2;
	local l_pattern_in_file=$3;
	local l_line=$4;

	for file in `find ${l_dir} -name "${l_pattern_of_file}" -exec grep -l "${l_pattern_in_file}" {} \;`;do 
		sed -i "${l_line} d" $file;
	done

}

function gom4 {
	local l_host=$1;

        sudo ssh -L 22:${l_host}:22 harrison.teng@bastion.m4internet.com
}

function goemc {
	local l_host=$1;

	sudo ssh -L 22:${l_host}:22 harrison.teng@bastion2.electric.net
}

function switchSVN {

	local l_mode=$1;

	if [ "x${l_mode}" == "x1" ];then
		if ( env |grep -o -P -q 'SVN_ROOT.*127\.0\.0\.1' );then 
			echo "Switch to M4 SVN...";
			export SVN_SSH='ssh -l harrison';
			export SVN_ROOT='svn+ssh://harrison@svn.m4internet.com/data1/svn/';
		fi
        elif [ "x${l_mode}" == "x2" ];then
                echo "Switch to EMC SVN...";
                if ( nc -z 127.0.0.1 2222 2>/dev/null );then
        		export SVN_SSH='ssh -l harrison.teng';
                export SVN_ROOT='svn+ssh://harrison.teng@127.0.0.1/svn/';
        	else
        		echo "No Tunnel to EMC SVN, abort !";
                        return;
                fi
        elif [ "x${l_mode}" == "x3" ];then
        	echo "Switch to EMC svn3a SVN...";
                if ( nc -z 127.0.0.1 2223 2>/dev/null );then
        		export SVN_SSH='ssh -l harrison.teng';
                        export SVN_ROOT='svn+ssh://harrison.teng@127.0.0.1/svn/';
        	else
        		echo "No Tunnel to EMC svn3a SVN, abort !";
                        return;
                fi
        fi

        echo "done with $(echo $SVN_ROOT)";
        return;
}


function emcsvn {

        local l_ticket=$1;
        local l_files=$2;
        local l_comments=$3;

        if ( env |grep -o -P -q 'SVN_ROOT.*127\.0\.0\.1' );then 
		echo "We are in EMC SVN, continue..";
        else
                switchSVN;
        fi

	svn ci -m "[re #${l_ticket} ${l_comments}]" ${l_files};

}

function tport {

	local l_ip=$1;
	local l_port=$2;

	if ( netcat -zw2 ${l_ip} ${l_port} );then
		echo "${l_ip}:${l_port} is connected";
	fi
}

function testSMTPauth {

	local l_input=$1;

	perl -MMIME::Base64 -e "print encode_base64('${l_input}');"
}

function testSMTPauthSSL {

	local l_host=$1;
	local l_port=$2;

	#dont use RCPT TO, but rcpt to, otherwise you will get cut after RENEGOTIATING
	openssl s_client -CApath /etc/ssl/certs -host ${l_host} -port ${l_port}
}

function getConPros {

	sudo /bin/netstat -ept | grep ESTAB | awk '{print $9}' | cut -d: -f1 | sort | uniq -c | sort -nr;
}

function getConProsN {

	sudo netstat -antu | awk '{print $5}' | sed -n -e '/[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}/p' | sed 's/::ffff://' | cut -d: -f1 |xargs -n 1 host |awk '{if ($NF ~ /NXDOMAIN/) {print $0} else {print $NF}}' |sort |uniq -c |sort -nr;

}

#==================================================================
# List IP with too many connections
#netstat -anlp|grep 80|grep tcp|awk '{print $5}'|awk -F: '{print $1}'|sort|uniq -c|sort -nr|head -n20 | netstat -ant |awk '/:80/{split($5,ip,":");++A[ip[1]]}END{for(i in A) print A[i],i}' |sort -rn|head -n20 
#netstat -tulpn
#lsof -Pan -i tcp -i udp
#Display local listening TCP/UDP ports and processes they belong to.
#lsof one is more portable to its cousin netstat
#
#netstat -plnt
#check open ports ( ipv4 and ipv6 )
#sockstat -l4
#check open ports on BSD
#
#netstat -paten
#ports,processes and owners
#
#netstat -l
#Display only listening ports
#
#netstat -l{x,u,t} Unix ports,UDP ports, TCP ports
#
#netstat -pt
#Display processes on the TCP ports
#
#netstat -i{e} with extended info
#List network interfaces
#
#netstat -na
#Display all active Internet connections to the servers and only established connections are included.
#
#netstat -an | grep :80 | sort
#
#Show only active Internet connections to the server at port 80 and sort the results. Useful in detecting single flood by allowing users to recognize many connections coming from one IP.
#
#netstat -n -p|grep SYN_REC | wc -l
#Let users know how many active SYNC_REC are occurring and happening on the server. The number should be pretty low, preferably less than 5. On DoS attack incident or mail bombed, the number can jump to twins. However, the value always depends on system, so a high value may be average in another server.
#
#netstat -n -p | grep SYN_REC | sort -u
#List out the all IP addresses involved instead of just count.
#
#netstat -n -p | grep SYN_REC | awk '{print $5}' | awk -F: '{print $1}'
#List all the unique IP addresses of the node that are sending SYN_REC connection status.
#
#netstat -ntu | awk '{print $5}' | cut -d: -f1 | sort | uniq -c | sort -n
#Use netstat command to calculate and count the number of connections each IP address makes to the server.
#
#netstat -anp |grep 'tcp\|udp' | awk '{print $5}' | cut -d: -f1 | sort | uniq -c | sort -n
#List count of number of connections the IPs are connected to the server using TCP or UDP protocol.
#
#netstat -ntu | grep ESTAB | awk '{print $5}' | cut -d: -f1 | sort | uniq -c | sort -nr
#Check on ESTABLISHED connections instead of all connections, and displays the connections count for each IP.
#
#netstat -plan|grep :80|awk {'print $5'}|cut -d: -f 1|sort|uniq -c|sort -nk 1
#Show and list IP address and its connection count that connect to port 80 on the server. Port 80 is used mainly by HTTP web page request.
#
#netstat -r or netstat -nr
#Columns:
#
#Destination and Gateway: The destination is an address (or address range) we might want to send information to. All data sent to that destination will go to the associated gateway. The gateway knows where to send the data to for its next 'hop' on the journey. If we wish to send data to a destination that has no entry in the routing table, it will go through the default gateway.
#
#Flags: The man/info page lists all the flags. Here are what the settings on my default gateway mean:
#
#UGSc
#U       - RTF_UP           Route usable
# G      - RTF_GATEWAY      Destination requires forwarding by intermediary
#  S     - RTF_STATIC       Manually added
#   c    - RTF_PRCLONING    Protocol-specified generate new routes on use
#That's curious that it claims to be manually added, as it came over DHCP.
#
#Refs: "The refcnt field gives the current number of active uses of the route. Connection oriented protocols normally hold on to a single route for the duration of a connection while connectionless protocols obtain a route while sending to the same destination." (Man page)
#
#Use: "The use field provides a count of the number of packets sent using that route."
#
#Netif: "The interface entry indicates the network interface utilized for the route."
#
#On my Mac,
#
#lo0 is the loopback interface.
#en0 is ethernet.
#en1 is wireless.
#en2 and en3 are used by a virtual machine.
#Expire: From a manpage for a different version of netstat: "Displays the time (in minutes) remaining before the route expires."
#
#netstat -an | grep ESTABLISHED | awk '{print $5}' | awk -F: '{print $1}' | sort | uniq -c | awk '{ printf("%s\t%s\t",$2,$1) ; for (i = 0; i < $1; i++) {printf("*")}; print "" }'
#Graph # of connections for each hosts.
#
#route -Cn | grep eth0 | awk '{print $2}' | awk -F: '{print $1}' | sort | uniq -c | awk '{ printf("%s\t%s\t",$2,$1) ; for (i = 0; i < $1; i++) {printf("*")}; print "" }
#Graph # of above for routing
#
# group by con status , from chinaunix
# netstat -nat|awk '{print awk $NF}'|sort|uniq -c|sort -n
# group by ip , from chinaunix
# netstat -nat|grep ":80"|awk '{print $5}' |awk -F: '{print $1}' | sort| uniq -c|sort -n
#
#==================================================================

function gethex() { 
	bc <<< "obase=16; $1"; 
}

function getdec() { 
	bc <<< "ibase=16; $1"; 
}

# Recall the structure of a IP header with options:
# 
#  0                            15                              31
# -----------------------------------------------------------------
# |  ver  | hlen  | TOS           |       Total Length            |
# -----------------------------------------------------------------
# |        Identification         |IPFlag|      Fragment          |
# |                               | xDM  |      Offset            |
# -----------------------------------------------------------------
# |      TTL      |    Protocol   |       Header Checksum         |
# |               | 1.ICMP 2.IGMP |                               |
# |               | 6.TCP  9.IGRP |                               |
# |               |17.UDP  47.GRE |                               |
# |               |50.ESP  51.AH  |                               |
# |               |57.SKIP88.EIGRP|                               |
# |               |89.OSPF115.L2TP|                               |
# -----------------------------------------------------------------
# |                         Source Address                        |
# -----------------------------------------------------------------
# |                      Destination Address                      |
# -----------------------------------------------------------------
# |  Options (0-40 bytes); padded to 4-byte boundary              |
# |  0. End of Option List           1. No Operation (pad)        |
# |  7. Record route                 68.Timestamp                 |
# |  131. Loose source route         137. Strict source route     |
# -----------------------------------------------------------------
#
# or you can see it in below:
#	0                   1                   2                   3   
#	0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 
#	+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
#	|Version|  IHL  |Type of Service|          Total Length         |
#	+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
#	|         Identification        |Flags|      Fragment Offset    |
#	+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
#	|  Time to Live |    Protocol   |         Header Checksum       |
#	+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
#	|                       Source Address                          |
#	+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
#	|                    Destination Address                        |
#	+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
#	|                    Options                    |    Padding    | <-- optional
#	+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
#	|                            DATA ...                           |
#	+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
#
#ref url is http://www.cnblogs.com/jiangnii/archive/2007/05/15/747013.html
#2012-06-28 13:38:51.231891 IP (tos 0x10, ttl 64, id 13863, offset 0, flags [DF], proto TCP (6), length 116)
#    192.168.3.1.46436 > 192.168.3.5.ssh: Flags [P.], cksum 0xd1da (correct), seq 31814:31878, ack 17356958, win 1002, options [nop,nop,TS val 4080496125 ecr 583820909], length 64
#        0x0000:  4510 0074 3627 4000 4006 7cf6 c0a8 0301  E..t6'@.@.|.....
#        0x0010:  c0a8 0305 b564 0016 544c fc21 9abb 0d1a  .....d..TL.!....
#        0x0020:  8018 03ea d1da 0000 0101 080a f337 6dfd  .............7m.
#        0x0030:  22cc 666d f625 1e58 9ce4 4b0f ff12 777a  ".fm.%.X..K...wz
#        0x0040:  d743 f88b cc75 a486 9eed afb9 46ef d48e  .C...u......F...
#        0x0050:  d69e 5b78 3b41 c634 025b a4b7 4f47 be1f  ..[x;A.4.[..OG..
#        0x0060:  9205 ffe2 02f8 2103 cd16 3b03 da67 fe80  ......!...;..g..
#        0x0070:  fcb9 e793  
#
# 4(4bits)=>version
# 5(4bits)=>IHL Ip Header Length, Max of that is 1111 then 15x4 = 60 bits, here it is 5 then 0101, then 5x4 = 20 bits
# 10(8bits)=>TOS,Precedence(3bits, it is ignored for now,legcy design),TOS(Delay,Throughput,Reliability,cost,4 bits total and can ONLY have one bit got set to 1 in total of 4),Reserved(1bit)
# 0074(16bits)=> Specifies the total length of the IP datagram, in bytes. Since this field is 16 bits wide, the maximum length of an IP datagram is 65,535 bytes, though most are much smaller. so running gethex 0074 => 116 as the total ip datagram length
#
# 3627(16bits)=> This field contains a 16-bit value that is common to each of the fragments belonging to a particular message;
# 3627(16bits)=> for datagrams originally sent unfragmented it is still filled in, so it can be used if the datagram must be fragmented by a router during delivery.
# 3627(16bits)=> This field is used by the recipient to reassemble messages without accidentally mixing fragments from different messages. 
# 3627(16bits)=> This is needed because fragments may arrive from multiple messages mixed together, since IP datagrams can be received out of order from any device. 
# 3627(hex)=>13863(dec)
#
# 4000(16bits)=> 0100 0000, first 3 are flags ( reserved, Dont Frag and More Frag ), rest 13 are the Fragement Offset
# 40(8bits)=>TTL, 40 in decimal is 64, which is the by-default of Linux TTL, if it is 80 then in decimal is 128, which is the by-default of Windows TTL 
# 06(8bits)=>Protocal, 00:Reserved,01:ICMP,02:IGMP,03:GGP,04:Ip-In-Ip Encapsulation,06:TCP,08:EGP,11:UDP,32:Encapsulating Security Payload(ESP),33:Authentication Header(AH)
# 7cf6(Header Checksum)=> Header Checksum
#
# Followings 2x32bits are Source and Destination IP Addresses:
#
# source ip from above is:
# 	C0(hex)=>192(dec), A8(hex)=>168(dec), 03(hex)=>3(dec), 01(hex)=>1(dec)
# destination ip from above is:
# 	C0(hex)=>192(dec), A8(hex)=>168(dec), 03(hex)=>3(dec), 05(hex)=>5(dec)
#

# Recall the structure of a TCP header without options:
# 
#  0                            15                              31
# -----------------------------------------------------------------
# |          source port          |       destination port        |
# -----------------------------------------------------------------
# |                        sequence number                        |
# -----------------------------------------------------------------
# |                     acknowledgment number                     |
# -----------------------------------------------------------------
# |  HL   | rsvd  |C|E|U|A|P|R|S|F|        window size            |
# -----------------------------------------------------------------
# <---
#         CWR:(1 = sender has cut congestion windows in half) 
#         ECE:(1 = receiver cuts congestion window in half)
#
#            Unskilled Attackers Pester Real Security Folks
#
#                |C|E|U|A|P|R|S|F|
#                |---------------|
#                |0 0 0 0 0 0 1 0|
#                |---------------|
#                |7 6 5 4 3 2 1 0|
#
#         URG:(1 = Urgent pointer valid, (aka,Unskilled) )
#         ACK:(1 = Acknowledgement field value valid (aka,Attackers) )
#         PSH:(1 = Push data (aka,Pester) )
#         RST:(1 = Reset connection (aka,Real) )
#         SYN:(1 = Synchronize sequence numbers (aka,Security) )
#         FIN:(1 = no more data, finish connection (aka,Folks) )
#
#         all SYN packets & 2 != 0
#         all RST packets & 4 != 0
#         all ACK packets & 16 != 0
#         all SYNCHRONIZE/ACKNOWLEDGE (SYNACK) packets...
#         & =18 
# --->
# -----------------------------------------------------------------
# |         TCP checksum          |       urgent pointer          |
# -----------------------------------------------------------------
#
# or read tcp header in below format:
#
#	0                   1                   2                   3   
#	0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 
#	+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
#	|          Source Port          |       Destination Port        |
#	+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
#	|                        Sequence Number                        |
#	+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
#	|                    Acknowledgment Number                      |
#	+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
#	|  Data |       |C|E|U|A|P|R|S|F|                               |
#	| Offset|  Res. |W|C|R|C|S|S|Y|I|            Window             | 
#	|       |       |R|E|G|K|H|T|N|N|                               |
#	+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
#	|           Checksum            |         Urgent Pointer        |
#	+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
#	|                    Options                    |    Padding    |
#	+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
#	|                             data                              |
#	+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

function tdumpOutbound() {
 
	local l_interface=$1;

	#we need to capture SYN packets, but we don't care if ACK or any other TCP control bit is set at the same time.
	sudo tcpdump -i ${l_interface} -XS 'tcp[13] & 2==2'

}

function tdumpOutboundOnly() {

	local l_interface=$1;

	#we need to capture SYN packets ONLY
	sudo tcpdump -i ${l_interface} -XS 'tcp[13]==2';

	#tcpdump 'tcp[13] & 2 != 0'
}

function tcpdumpInandOut() {

	local l_dport=$1;
	local l_interface=$2;
	local l_shost=$3;
	local l_dhost=$4;

	#sudo tcpdump -i ${l_interface} -X -l -n -tttt -vvvv "( src ${l_shost} or ${l_dhost} ) and ( dst ${l_shost} or ${l_dhost} ) and port ${l_dport}";
	echo "sudo tcpdump -i ${l_interface} -X -l -n -tttt -vvvv \"( src ${l_shost} or ${l_dhost} ) and ( dst ${l_shost} or ${l_dhost} ) and port ${l_dport}\"";

	#tcpdump -i eth0 -X -s 65535 -tttt -vvvv 'port 3306 and tcp[1] & 7==2 and tcp[3] & 7==2'
}

function tcpdumpInandOutR() {

	local l_dport=$1;
	local l_interface=$2;
	local l_shost=$3;

	tcpdump -i ${l_interface} -l -w - dst port ${l_dport} and src ${l_shost} |strings
}

function tcpdumpInandOutRF() {

	local l_dport=$1;
	local l_interface=$2;
	local l_shost=$3;
	local l_pattern=$4;

	tcpdump -i ${l_interface} -c 2 -s 0 -l -w - dst port ${l_dport} and src ${l_shost} |grep -ai -m 1 -E '${l_pattern}'|strings
}

function dec2bin() {

	local l_input=$1;

	#padding in that regex, otherwise you may get leading zeros
	echo "${l_input}"|perl -e 'my $str = unpack("B32", pack("N", <STDIN>));$str =~ s/^0+(?=\d)//;print $str;';

}

function bin2dec() {

	local l_input=$1;

	echo "${l_input}"|perl -e 'print unpack("N", pack("B32", substr("0" x 32 . <STDIN>, -32)));'

}

function getCSV() {
	
	local l_input=$1;

	#sed 's/\t/,/g;s/\r//g;' ${l_input};
	#sed 's/\t/","/g;s/^/"/;s/$/"/;s/\r//g;' ${l_input};
	#sed 's/\t/","/g;s/^/"/;s/,/","/g;s/$/"/;s/\r//g;' ${l_input};
	sed 's/\t/","/g;s/^/"/;s/$/"/;s/\r//g;' ${l_input};
}

function vgo() {

	local l_host=$1;

	ssh root@${l_host};
}

function mgo() {
	
	if [ $# -lt 2 ];then
		local l_username='harrison.teng';
		local l_host=$1;
	else
		local l_username=$1;
		local l_host=$2;
	fi

	if ! ( echo ${l_host}|egrep '(.*)\.(.*)\.(.*)' >/dev/null 2>&1 );then 
		l_host="${l_host}.m4internet.com";
	fi 

	ssh -t harrison.teng@bastion.m4internet.com "ssh ${l_username}@${l_host}";
	#ssh -t harrison.teng@bastion.m4internet.com "ssh harrison.teng@woodstockw \"mysql -uroot -pdiskmark -e 'show processlist'\" ";

}

function ego() {

	local l_bastion='bastion3ai.electric.net';

	if [ $# -lt 2 ];then
		local l_username='harrison.teng';
		local l_host=$1;
	elif [ $# -eq 3 ];then
		l_bastion="$1.electric.net";
		local l_username=$2;
		local l_host=$3;
	else
		local l_username=$1;
		local l_host=$2;
	fi

	if ! ( echo ${l_host}|egrep '(.*)\.(.*)\.(.*)' >/dev/null 2>&1 );then 
		l_host="${l_host}.electric.net";
	fi 

	ssh -t harrison.teng@${l_bastion} -o "IdentityFile ~/.ssh/id_rsa_bastion2" "ssh ${l_username}@${l_host}";
	#ssh -A -t harrison.teng@${l_bastion} -i ~/.ssh/id_rsa_bastion2 "ssh ${l_username}@${l_host}";

}

function hgo() {

	local l_host=$1;
	local l_username='harrison';
	local l_key='/home/harrison/.ssh/home_id_rsa';

	if ( echo ${l_host}|egrep 'ob' >/dev/null 2>&1 );then 
		ssh -i ${l_key} -p 2222 ${l_username}@${l_host};
	else
		ssh -i ${l_key} ${l_username}@${l_host};
	fi 
}

function gencert() {

	openssl req -x509 -nodes -days 730 -newkey rsa:2048 -subj '/C=COUNTRY/ST=STATE/L=LOCATION/CN=WEBSITE' -keyout NAME.pem -out NAME.pem
	openssl req -x509 -nodes -days 730 -newkey rsa:2048 -keyout mx4.efax.com.2012-06-26.key -out mx4.efax.com.2012-06-26.csr
	#for commodo CSR decode page https://secure.comodo.net/utilities/decodeCSR.html, no need to specify -x509 since the CSR from that wont be processed there
	openssl req -nodes -days 730 -newkey rsa:2048 -keyout mx4.efax.com.2012-06-26.key -out mx4.efax.com.2012-06-26.csr

}

function getPySitePkg() {
	python -c "from distutils.sysconfig import get_python_lib; print(get_python_lib())"
}

function getServerVersion() {
	nmap -sV -T5 -O $1;
}

function opensslfile() {


	local l_mode=$1;
	local l_FILE=$2;

	local l_OUTPUT="`date +%s`-${l_FILE}";
	cp ${l_FILE} "${l_FILE}.bak";

	echo "mode is ${l_mode}";
	echo "backfile is ${l_FILE}.bak";
	echo "output file is ${l_OUTPUT}";
	echo "you will be prompted for salt within 4 seconds...";
	echo "....";
	sleep 4;

	if [ ${l_mode} == 'en' ];then
		openssl aes-256-cbc -a -salt -in ${l_FILE} -out ${l_OUTPUT};
	elif [ ${l_mode} == 'de' ];then
		openssl aes-256-cbc -d -a -salt -in ${l_FILE} -out ${l_OUTPUT};
	fi

}

function isPrime() {
	
	local l_input=$1;

	# Check if a number is a prime
	echo ${l_input} |perl -lne '(1x$_) !~ /^1?$|^(11+?)\1+$/ && print "$_ is prime"'

}

function ah() {
	perl -e 'map(($r=$_,map(($y=$r-$_/3,$l[24-$r].=(" ","\@")[$y**2-20*$y+($_**2)/3<0]),(0..30)),),(0..24));print join("\n", map(reverse($_).$_, @l)), "\n";'
}

function wow() {
	perl -le 'map {$y = $_ / 15; print map {("@", " ")[(-57 > $_ || $_ > -53) && ($_ ** 2 / 1250 + $y ** 2 - 1) ** 3 > $_ ** 2 * $y ** 3 / 2500 && 0.2 * ($_ - 60) ** 2 - 18 > 15 * $y || 15 * $y > ($_ - 60) ** 2 - 15]} -75..75 } reverse -18..18'
}

function japh() {
	perl -e '@P=split//,".URRUU\c8R";@d=split//,"\nrekcah xinU / lreP rehtona tsuJ";sub p{@p{"r$p","u$p"}=(P,P);pipe"r$p","u$p";++$p;($q*=2)+=$f=!fork;map{$P=$P[$f^ord($p{$_})&6];$p{$_}=/ ^$P/ix?$P:close$_}keys%p}p;p;p;p;p;map{$p{$_}=~/^[P.]/&&close$_}%p;wait until$?;map{/^r/&&<$_>}%p;$_=$d[$q];sleep rand(2)if/\S/;print'


#@STATE = split //, ".URRUUxR";
#@data = split//,"\nrekcah xinU / lreP rehtona tsuJ";
#
#sub make_pipe_and_fork {
#  @pipestate{"r$fhno", "u$fhno"}=(P,P);
#  pipe "r$fhno", "u$fhno";
#  ++$fhno;
#  ($pid *= 2) += $is_child = !fork();
#  map {
#    $STATE=$STATE[$is_child ^ ord($pipestate{$_}) & 6];
#    $pipestate{$_} = (/^$STATE/i ? $STATE : close $_);
#  } keys %pipestate
#}
#make_pipe_and_fork;
#make_pipe_and_fork;
#make_pipe_and_fork;
#make_pipe_and_fork;
#make_pipe_and_fork;
#
#map {
#  $pipestate{$_} =~ /^[P.]/ && close $_
#} %pipestate;
#
#wait until $?;
#
#map { /^r/ ? <$_> : 1 } %pipestate; 
#
#$_ = $data[$pid];
#sleep rand(2) if /\S/;
#print
}

function getBID() {
	
	local l_accountid=$1;

	curl -s -u 'billing.api:OmspWYlKceLV8AgYLX' -H 'realm:SystemsLDAP' -H 'Content-Type: application/json' -X POST -d "{\"function\":\"get_customer_nums\", \"parameters\":{\"AccountID\":\"${l_accountid}\"}}" -i -k https://10.84.13.41/billing_api.cgi |tail -1 |sed -n 's/.*"cus_num":"\([0-9]\{1,7\}\)","var_num.*/\1/p'

}

function genDKIM() {

	local l_selector=$1;
	local l_domain=$2;

	openssl genrsa -out ${l_selector}._domainkey.${l_domain}  1024;
	openssl rsa -in ${l_selector}._domainkey.${l_domain} -pubout -out public.${l_domain};

}

function genCSPROJ() {
   
	#usage : makecscope src_path project_name"
   	#I will create cscope db in ~/cscope/project_name"

	local srcpath=$1
	local cscopepath=$2

	mkdir -p $cscopepath;
	cd $cscopepath;
	find $srcpath -name "*.h" -o -name "*.c" -o -name "Makefile" -o -name "makefile" > cscope.files
	cscope -bkq -i ./cscope.files

}

function gpgExportPublicKey() {

	local l_keyid=$1;
	local l_outputpubkey=$2;

	gpg --armor --output ${l_outputpubkey} --export '${l_keyid}';
}

function gpgGenRevoke() {
	
	local l_keyid=$1;
	local l_revoke=$2;

	gpg --output ${l_revoke} --gen-revoke ${l_keyid};
}

function gpgencryptrun() {

	local l_script=$1;

	local l_enc="${l_script}.secure";

	echo "eval \"\$(dd if=\$0 bs=1 skip=XX 2>/dev/null|gpg -d 2>/dev/null)\";exit" > ${l_enc}; sed -i s:XX:$(stat -c%s ${l_enc}): ${l_enc}; gpg -c < ${l_script} >> ${l_enc}; chmod +x ${l_enc};

}

function getXMLtoHash() {

	local l_file=$1;
	local l_key=$2;

	cat ${l_file} |perl /home/harrison/.utils/getXML.pl ${l_key};
}

#function gpgsendemail() {
#
#	local l_recipient=$1;
#
#	gpg -ea -r "Recipient name" -o - filename | mail -s "Subject line"recipient@example.com
#	echo "Your secret message" | gpg -ea -r "Recipient name" | mail -s
#	"Subject" recipient@example.com
#}

function psPrintPname() {

	local l_processname=$1;

	ps -C ${l_processname} -L -o pid,tid,pcpu,state,nlwp,args;
}

function psCountPid() {

	local l_processid=$1;

	ps -o thcount -p ${l_processid};
}

function psCountAll() {
	echo -e "pid\tthreads\t  bid" && ps ax -o pid,nlwp,cmd|awk '/broadcast.*oMTA/ {print $1"\t"$2"\t"$7}'| grep -v '&&'
}

function lstree() {

	local l_dir=$1;

	ls -R ${l_dir} | grep ":$" | sed -e 's/:$//' -e 's/[^-][^\/]*\//--/g' -e 's/^/   /' -e 's/-/|/'
}

function getExtIP() {

	curl icanhazip.com;
}

function terminalClock() {

	watch -t -n1 "date +%T|figlet";
}

function translate() {
	#wget -qO- "http://ajax.googleapis.com/ajax/services/language/translate?v=1.0&q=$1&langpair=$2|${3:-en}" | sed 's/.*"translatedText":"\([^"]*\)".*}/\1\n/';
	lng1="$1";
	lng2="$2";
	shift;
	shift; 
	
	wget -qO- "http://ajax.googleapis.com/ajax/services/language/translate?v=1.0&q=${@///+}&langpair=$lng1|$lng2" | sed 's/.*"translatedText":"\([^"]*\)".*}/\1\n/';
}

function define() {
	#local y="$@";curl -sA"Opera" "http://www.google.com/search?q=define:${y// /+}"|grep -Po '(?<=<li>)[^<]+'|nl|perl -MHTML::Entities -pe 'decode_entities($_)' 2>/dev/null;
	wget -q -U busybox -O- "http://www.google.com/search?ie=UTF8&q=define%3A$1" | tr '<' '\n' | sed -n 's/^li>\(.*\)/\1\n/p'
}

function hlsalt(){

	local l_dir=$1;

	tree -L 1 -ChDit ${l_dir};
}

function hgoogle(){

	u=`perl -MURI::Escape -wle 'print "http://google.com/search?q=".uri_escape(join " ",  @ARGV)' $@`
    w3m -no-mouse -F $u

}

function kc() {

		echo "clean up existing agent";
        ssh-agent -k; 
        sleep 2;

		echo "adding M4 keys...";
        /usr/bin/keychain /home/harrison/.ssh/id_rsa;

		echo "adding EMC keys...";
		ssh-add /home/harrison/.ssh/id_rsa_bastion2;

}

function getDuplicateOnes() {
	
	local l_file1=$1;
	local l_file2=$2;

	perl -ne 'print if ($seen{$_} .= @ARGV) =~ /10$/'  ${l_file1} ${l_file2};
}

function monProcessMem() {

	local l_processname=$1;

	echo -n "starts with:" ;ps aux |awk '{print $5, $11}' | grep ${l_processname} | sort -n; while true; do ps aux | awk '{print $5,$11}' | grep ${l_processname} | sort -n > /tmp/a.txt; sleep 1; diff /tmp/{b,a}.txt; mv /tmp/{a,b}.txt; done;
}

function expandIPv6() {

    local l_ipv6=$1;

    echo "${l_ipv6}"|awk -F: '{for(i=1;i<=8;i++)x=x""sprintf ("%4s:",$i);gsub(/ /,"0",x);print x}' |sed 's/:$//';

}

function mygoget() {

    local l_url=$1;

    go get -u -v -x ${l_url};
}

#dd over ssh
#I wanted to copy everything off the disk and send it over the network. So we can do it with ssh. First zero out the non used space on the running disk to make compressing the image much eaiser. Using the command:
#
#dd if=/dev/zero of=0bits bs=20M; rm 0bits
#
#Then boot knoppix (or any other bootable linux distro like sysrescuecd) from the machine you want to image and give the command:
#
#dd if=/dev/sda | gzip -1 - | ssh user@hostname dd of=image.gz
#
#Assuming sda is your hard drive. This sends the local disks data to the remote machine. To restore the image boot knoppix on the machine to restore and pull the image that you created and dump it back with the command:
#
#ssh user@hostname dd if=image.gz | gunzip -1 - | dd of=/dev/sda

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi

if [ -f ~/.bashrc.local ]; then
    source ~/.bashrc.local
fi

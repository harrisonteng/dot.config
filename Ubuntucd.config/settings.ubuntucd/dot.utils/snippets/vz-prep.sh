#!/bin/bash
PREF=">>>"
BAD="!!!"
AUTHOR="Daniel Robbins (drobbins@funtoo.org)"
die() {
	echo
	echo "$BAD $*. Exiting."
	echo
	exit 1
}

cat << EOF

 OpenVZ Virtual OS Template Prep Script for Gentoo 1.0
  by Daniel Robbins (drobbins@funtoo.org)

  Usage: $0 veid hostname

  Example: $0 800 gentoo-amd64-20071015
  The script will then look in /vz/private/800 and create a normalized
  .tar.gz template in the current directory named gentoo-amd64-20071015.tar.gz,
  ready for distribution.

EOF
if [ $# -ne 2 ]
then
	die "This script requires two arguments"
fi

MYVZ=$1
if [ ! -d /vz/private/$1 ]
then
	echo "Cannot find virtual environment in /vz/private/$1. Exiting."
	exit 1
fi

myvzstat=`vzlist $1 | tail -n 1 | awk '{ print $3 }'`
if [ "$myvzstat" != "stopped" ]
then	
	die "Virtual machine $1 is in $myvzstat state. Please stop first"
fi

HOST=$2
if [ "$2" = "" ]
then
	echo "Please specify a default hostname for this machine. Exiting."
	exit 1
fi


HOSTNAME=$2
echo "$PREF Setting hostname to $2..."
cat > /vz/private/$1/etc/conf.d/hostname << EOF
# /etc/conf.d/hostnme

# Set to the hostname of this machine
HOSTNAME="$2"
EOF
echo "$PREF Setting timezone to UTC..."
cat /vz/private/$1/etc/conf.d/clock | sed -e 's/^#*TIMEZONE.*$/TIMEZONE="UTC"/' > /vz/private/$1/etc/conf.d/clock.new
cat /vz/private/$1/etc/conf.d/clock.new > /vz/private/$1/etc/conf.d/clock
rm /vz/private/$1/etc/conf.d/clock.new
myzone=`( source /vz/private/$1/etc/conf.d/clock; echo $TIMEZONE; )`
if [ "$myzone" = "UTC" ]
then
	echo "$PREF Timezone set to UTC."
else
	die "Timezone not set correctly: $myzone"
fi
echo "$PREF Adding maintainer message to /etc/motd"
mydate=`date -u`
cat > /vz/private/$1/etc/motd << EOF
 
 >>> OpenVZ Template:               $2
 >>> Created on:                    $mydate 
 >>> Created by:                    $AUTHOR 
 
 >>> Send suggestions, improvements, bug reports relating to... 
 
 >>> This OpenVZ template:          $AUTHOR
 >>> Gentoo Linux (general):        Gentoo Linux (http://www.gentoo.org)
 >>> OpenVZ (general):              OpenVZ (http://www.openvz.org)

 Initial setup steps:
 1. nano /etc/resolv.conf, to set up nameservers
 2. set root password
 3. 'vzsplit'/'vzctl' to get/set resource usage (basic config bad for gentoo)
 4. 'emerge --sync' to retrieve a portage tree
 
 NOTE: This message can be removed by deleting /etc/motd.

EOF
echo "$PREF Removing ssh host keys..."
rm -f /vz/private/$1/etc/ssh/ssh_host* || die "ssh key cleanup fail"
echo "$PREF Cleaning /var/tmp..."
rm -rf /vz/private/$1/var/tmp/* || die "/var/tmp cleanup fail"
echo "$PREF Cleaning /tmp..."
rm -rf /vz/private/$1/tmp/* || die "/tmp cleanup fail"
echo "$PREF Removing /root/.bash_history..."
rm -f /vz/private/$1/root/.bash_history || die "bash_history fail"
echo "$PREF Removing resolv.conf..."
rm -f /vz/private/$1/etc/resolv.conf || die "resolv.conf cleanup fail"
echo "$PREF Cleaning misc. Portage logs..."
rm -f /vz/private/$1/var/log{emerge.log,portage/elog/summary.log} || die "Portage cleanup fail"
echo "$PREF Normalizing make.conf..."
cat /vz/private/$1/etc/make.conf | sed -e '/^MAKEOPTS.*/d' > /vz/private/$1/etc/make.conf.new || die "make.conf sed"
cat /vz/private/$1/etc/make.conf.new > /vz/private/$1/etc/make.conf || die "make.conf cat 2"
rm /vz/private/$1/etc/make.conf.new || die "make.conf rm"
echo "$PREF Resetting root password..."
cat /vz/private/$1/etc/shadow | sed -e 's/^root:[^:]*:/root:!:/' > /vz/private/$1/etc/shadow.new
cat /vz/private/$1/etc/shadow.new > /vz/private/$1/etc/shadow
rm /vz/private/$1/etc/shadow.new || die "shadow.new cleanup fail"
myvar=`cat /vz/private/$1/etc/shadow | grep ^root | cut -b1-7`
if [ "$myvar" = 'root:!:' ]
then
	echo "$PREF Root password changed successfully."
else
	cat /vz/private/$1/etc/shadow
	die "Error changing password."
fi
if [ -e $HOSTNAME.tar.gz ]
then
	die "$HOSTNAME.tar.gz already exists in the current directory"
fi
echo "$PREF creating $HOSTNAME.tar.gz in the current directory..."
tar c -C /vz/private/$1 -zf $HOSTNAME.tar.gz . || die "tarball creation failure"
echo "$PREF Complete."
exit 0

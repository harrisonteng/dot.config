#!/bin/bash

MACHINES=`sudo smbstatus -v |grep -A 2 'Service' |grep -v -E '(Service|-)' |awk '{print $3}' |sort -n |uniq`;
SHARES=`sudo smbstatus -v |grep -E -v '(using|Samba|PID|Opened|-|No|Service)'|grep -A 2 'SharePath' |awk '{print $7}'`;
if ! [ -n $MACHINES ]; then
	echo $MACHINES;
fi
if ! [ -n $SHARES ]; then
	echo $SHARES;
fi

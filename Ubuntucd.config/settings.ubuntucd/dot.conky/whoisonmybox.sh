#!/bin/bash

#teamviewer
if tail -10 /var/log/teamviewer11/TeamViewer11_Logfile.log |grep 'Estimated Bandwidth Capacity to' &>/dev/null;then 
	tail -10 /var/log/teamviewer11/TeamViewer11_Logfile.log |grep 'Estimated Bandwidth Capacity to'|awk '{print $1" "$2" Client ID: "$10}' |tail -1;
fi

MYPTS=$(who -m |sed -e "s%^.* \(pts/[0-9]*\).*(\(.*\))%\1%g");
if [ "X$MYPTS" == "X" ];then                                
   usrs=`ps auxwww | grep -E '(sshd|sshd:)' |grep -v 'sshd -D' |grep -v grep |awk '{print $1" "$2" "$9" "$11" "$12}'`;
else    
   usrs=`ps auxwww | grep -E '(sshd|sshd:)' |grep -v -E "($MYPTS|sshd -D)"|grep -v grep |awk '{print $1" "$2" "$9" "$11" "$12}'`;
fi                            

if [ "X$usrs" != "X" ];then                               
      echo "$usrs";
fi                                                                                                                                                                                                              

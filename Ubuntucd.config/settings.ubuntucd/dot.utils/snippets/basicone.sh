#!/bin/bash

TAIL='/usr/bin/tail';
OPTION='-n 0 -F --sleep-interval=2';
#OPTION='-n 1000 --sleep-interval=2';
#SECURE='./samplesecure';
SECURE='/var/log/secure';
GREP='/bin/grep';
SED='/bin/sed';

[ -e $SECURE ] || { echo "Can not locate $SECURE !";exit 999; };

function put {

	local key=$1;
	local value=$2;

	for item in ${summary};do
		case "$item" in
			--$key=*)
				value=`echo "$item" |$SED -e 's/^[^=]*=//'`;
				value=$((value+1));
				found='true';
		esac
	        if [ "$found" == 'true' ]; then break; fi
	done

	hash="`echo "$summary" |$SED -e "s/--$key=[^ ]*//g"` --$key=$value";
	eval summary="\"$hash\"";

}

function get {

	local key=$1;
	local found='false';

	for item in ${summary};do
		case "$item" in
			--$key=*)
				value=`echo "$item" |$SED -e 's/^[^=]*=//'`;
				found='true';
		esac
	        if [ "$found" == 'true' ]; then break; fi
	done

        echo $value;

}


$TAIL $OPTION $SECURE 2>/dev/null |while read line;do

	if ( `echo "$line"|$GREP -q -i '(sshd:auth): authentication failure'` );then
		
		#IP=`echo "$line"|$SED -n 's/.*rhost=\([0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\) user.*/\1/p'`;
		IP=`echo "$line"|$SED -n 's/.*rhost=\(.*\) user.*/\1/p'`;  
		put "$IP" "1";
		count=$(get "$IP");
		echo "$IP=$count";


	fi	
done




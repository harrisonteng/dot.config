#!/bin/bash

date=$(date '+%F');
DAY=${date:8:2};
cal=$(cal -h);
prev=$(cal $(date '+%-m %Y' --date="${date:0:7}-$DAY -1 month")|sed 's/ *$//;/^$/d'|tail -1);
next=$(cal $(date '+%-m %Y' --date="${date:0:7}-$DAY +1 month")|sed '/^ *&/d;1,2d;s/^ *//'|head -1);
if [ ${#next} == 19 ] ;then next=$'\n'"\${color9} $next"
else next="\${color9} $next"
fi
if [ ${#prev} == 20 ]; then prev="$prev"$'\n '
else prev="$prev "
fi
dates=$(remind -s ~/.conky/.remind |cut -d ' ' -f1|uniq|cut -d '/' -f3|sed "/$DAY/d");
dateswithcomment=$(remind -s ~/.conky/.remind |rev |cut -d ' ' -f2- |rev|sed 's/*//g'|cut -d '/' -f3- |sed 's/\s//g');

current=$(echo "${cal:43}"|sed -e '/^ *$/d' -e 's/^/ /' -e 's/$/ /' -e 's/^ *1 / 1 /')

declare -i x=1;
CURRENTDAY=$(date '+%-d');
for i in $dates; do
#current=$(echo "$current"|sed -e /" ${i/#0/} "/s/" ${i/#0/} "/" "'${color green}'"${i/#0/}"'${color}'" "/)
	daywithcomment=`echo $dateswithcomment |cut -d ' ' -f$x`;x=$((x+1));
current=$(echo "$current"|sed -e /" $i "/s/" $i "/" "'${color green}'"$daywithcomment"'${color}'" "/)
done
current=$(echo "$current"|sed -e /" $CURRENTDAY "/s/" $CURRENTDAY "/" "'${color3}'"$CURRENTDAY"'${color}'" "/ -e 's/^ //' -e 's/ *$//')
monthyear=`echo ${cal:0:21}`;
weektitle=`echo ${cal:21:23}|sed 's/\s/\t/g'`;
echo -e "\${color7}$monthyear\n\${color4}$weektitle\n\${color9}$prev\${color}$current$next\n"

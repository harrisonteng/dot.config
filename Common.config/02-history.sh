# /etc/profile.d/02-history.sh
HISTDIR=/usr/share/monitor/.History;
if [ ! -d $HISTDIR ]; then 
    mkdir -p $HISTDIR 
    chmod u=rx,go=x $HISTDIR
    sudo chattr -R +a $HISTDIR 
fi

YM=`date +"%Y-%m"`;
ALL_HISTORY_FILE=$HISTDIR/.[${YM}]all_historys.log;
if [ ! -f $ALL_HISTORY_FILE ]; then
    touch $ALL_HISTORY_FILE
    chmod u=rw,go=w $ALL_HISTORY_FILE
    sudo chattr +a $ALL_HISTORY_FILE
fi

ALL_HISTORY_FILE=$HISTDIR/.[${YM}]all_historys.log;
PROMPT_COMMAND='date "+[%Y/%m/%d %T] [$(who am i |sed -e "s/[()]//g" |awk "{print \$1 \"@\" \$5 \"(\" \$2 \")\"}") $(pwd)]$ $( history 1 | sed -r "s|^[ \t]+[0-9]+[ \t]+||" )" >> $ALL_HISTORY_FILE';
export ALL_HISTORY_FILE PROMPT_COMMAND;

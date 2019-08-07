# /etc/profile.d/history.sh
HISTDIR=/usr/share/monitor/.History # 准备保存历史记录的文件夹，要确保每一级的文件夹对所有用户都开放了 x 权限，让他们能够写入里面的历史文件
if [ ! -d $HISTDIR ]; then # 若文件夹未被创建
    mkdir -p $HISTDIR #创建文件夹
    chmod u=rx,go=wx $HISTDIR #对管理员开放 rx读取访问 权限，其他用户只开放 x访问 权限
    chattr -R +a $HISTDIR #只能追加，防止删除
fi

YM=`date +"%Y-%m"` # 获取当前 年-月
ALL_HISTORY_FILE=$HISTDIR/.[${YM}]all_historys.log # 该月的历史记录文件名，之所以按月起不同的文件名，是为了避免一个文件过大，查看，清理都不方便。
if [ ! -f $ALL_HISTORY_FILE ]; then # 如果该月的历史记录文件未被创建
    touch $ALL_HISTORY_FILE # 创建文件
    chmod u=rw,go=w $ALL_HISTORY_FILE # 对管理员开放 rw读写 权限，其他用户只开放 w写 权限
    chattr +a $ALL_HISTORY_FILE # 其他用户拥有写权限，理论上也有了删除权限，因此这里设置为只允许追加文件，不允许修改或删除文件。
fi

PROMPT_COMMAND='date "+[%Y/%m/%d %T] [$(who am i |sed -e "s/[()]//g" |awk "{print \$1 \"@\" \$5 \"(\" \$2 \")\"}") $(pwd)]$ $( history 1 | sed -r "s|^[ \t]+[0-9]+[ \t]+||" )" >> $ALL_HISTORY_FILE'
# 样例：[2019/08/05 15:32:10] [root@192.168.1.1(pts/10) /root]$ top
export ALL_HISTORY_FILE PROMPT_COMMAND

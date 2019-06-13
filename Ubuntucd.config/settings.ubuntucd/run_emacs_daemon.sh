#!/bin/bash

echo "Gen Master Robot Tags ...";
find ~/projects.work/repo/GitLab/FortiRobot -name '*.robot' -print | xargs etags -o ~/TAGS/ROBOTMASTER.TAGS --regex='/^[^ \t]\([^\(Library|Resource|Suite|Documentation|#|\$|\*|\[|&|\t|\.|\s\)]*+[A-Z0-9]*+[A-Z0-9]*\).*$/\2/i';

echo "Gen Master Python/Groovy/Shell Tags ...";
find ~/projects.work/repo/GitLab/FortiRobot /usr/lib/python2.7/dist-packages /home/harrison/projects.work/repo/github/robotframework -type d \( -name '*branches*' -o -name '*tag*' -o -name '*\.ori' -o -name '*\.svn' -o -name '*tmp' -o -name '*temp' \) -prune -o \( -name '*.py' -o -name '*.groovy' -o -name '*.sh' \) -print |xargs -d '\n' etags -a --declarations -o ~/TAGS/PYROBOTMASTER.TAGS;


pkill emacs-snapshot;sleep 4;emacs-snapshot --daemon --eval "(setq default-frame-alist '((font-backend . \"xft\") (set-background-color \"black\") (set-foreground-color \"white\")))"

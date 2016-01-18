#!/bin/bash

#sudo NOPASSWD
#get 2 biggest only
/home/harrison/.conky/ps_mem.py |grep "=" |egrep -v -e "=====" |tail -3 |tac;

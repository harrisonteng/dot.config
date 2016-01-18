#!/bin/bash
# binary.sh
# copyright 2010 by Mobilediesel
#This program is free software: you can redistribute it and/or modify
#it under the terms of the GNU General Public License as published by
#the Free Software Foundation, either version 3 of the License, or
#(at your option) any later version.

#This program is distributed in the hope that it will be useful,
#but WITHOUT ANY WARRANTY; without even the implied warranty of
#MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#GNU General Public License for more details.

#You should have received a copy of the GNU General Public License
#along with this program.  If not, see <http://www.gnu.org/licenses/>.
cd ${0%/*}
case ${1-12} in
12)H="I";;
24)H="H";;
esac
BINARY=( {0..1}{0..1}{0..1}{0..1} )
DATE=$(date +%Y%m%d%$H%M)
COLOR="\${color@}"
CURRENT=" 40ff40"
DEFAULT=" 606060"
TEXT=" 99ccff"
YEAR=( ${BINARY[${DATE:0:1}]} ${BINARY[${DATE:1:1}]} ${BINARY[${DATE:2:1}]} ${BINARY[${DATE:3:1}]} )
MONTHDAY=( ${BINARY[${DATE:4:1}]} ${BINARY[${DATE:5:1}]} ${BINARY[${DATE:6:1}]} ${BINARY[${DATE:7:1}]} )
TIME=( ${BINARY[${DATE:8:1}]} ${BINARY[${DATE:9:1}]} ${BINARY[${DATE:10:1}]} ${BINARY[${DATE:11:1}]} )
dot=( "=" "${COLOR/@/$CURRENT}=${COLOR/@/$DEFAULT}" )
for i in {0..3};do
BYEAR="$BYEAR${dot[${YEAR[0]:$i:1}]}${dot[${YEAR[1]:$i:1}]}${dot[${YEAR[2]:$i:1}]}${dot[${YEAR[3]:$i:1}]}"$'\n'
BMONTHDAY="$BMONTHDAY${dot[${MONTHDAY[0]:$i:1}]}${dot[${MONTHDAY[1]:$i:1}]}${dot[${MONTHDAY[2]:$i:1}]}${dot[${MONTHDAY[3]:$i:1}]}"$'\n'
BTIME="$BTIME${dot[${TIME[0]:$i:1}]}${dot[${TIME[1]:$i:1}]}${dot[${TIME[2]:$i:1}]}${dot[${TIME[3]:$i:1}]}"$'\n'
done
echo "\${font webdings:size=12}${COLOR/@/$DEFAULT}"
paste --delimiters=@ <(echo "$BYEAR") <(echo "$BMONTHDAY") <(echo "$BTIME") | sed -e 's/@/   /g' -e '/^ *$/d'
echo "\${font}${COLOR/@/$TEXT}     Year         Month/Day        Time"

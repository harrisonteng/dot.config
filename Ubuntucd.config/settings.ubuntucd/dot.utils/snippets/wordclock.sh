#!/bin/bash
# wordclock.sh
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
DATE=$(date '+%-I:%-M')
HOUR=${DATE%:*}
MIN=${DATE#*:}
COLOR="\${color@}"
ON=" white"
OFF=" 606060"
case ${MIN} in
[0-4]) OCLOCK=${COLOR/@/$ON}
HOURS[${HOUR}]=${COLOR/@/$ON}
;;
[5-9]) FIVE=${COLOR/@/$ON}
PAST=${COLOR/@/$ON}
HOURS[${HOUR}]=${COLOR/@/$ON}
;;
1[0-4]) TEN=${COLOR/@/$ON}
PAST=${COLOR/@/$ON}
HOURS[${HOUR}]=${COLOR/@/$ON}
;;
1[5-9]) QUARTER=${COLOR/@/$ON}
PAST=${COLOR/@/$ON}
HOURS[${HOUR}]=${COLOR/@/$ON}
;;
2[0-4]) TWENTY=${COLOR/@/$ON}
PAST=${COLOR/@/$ON}
HOURS[${HOUR}]=${COLOR/@/$ON}
;;
2[5-9]) TWENTY=${COLOR/@/$ON}
FIVE=${COLOR/@/$ON}
PAST=${COLOR/@/$ON}
HOURS[${HOUR}]=${COLOR/@/$ON}
;;
3[0-4]) HALF=${COLOR/@/$ON}
PAST=${COLOR/@/$ON}
HOURS[${HOUR}]=${COLOR/@/$ON}
;;
3[5-9]) TWENTY=${COLOR/@/$ON}
FIVE=${COLOR/@/$ON}
HOURS[$((${HOUR/#12/0}+1))]=${COLOR/@/$ON}
TO=${COLOR/@/$ON}
;;
4[0-4]) TWENTY=${COLOR/@/$ON}
HOURS[$((${HOUR/#12/0}+1))]=${COLOR/@/$ON}
TO=${COLOR/@/$ON}
;;
4[5-9]) QUARTER=${COLOR/@/$ON}
HOURS[$((${HOUR/#12/0}+1))]=${COLOR/@/$ON}
TO=${COLOR/@/$ON}
;;
5[0-4]) TEN=${COLOR/@/$ON}
HOURS[$((${HOUR/#12/0}+1))]=${COLOR/@/$ON}
TO=${COLOR/@/$ON}
;;
5[5-9]) FIVE=${COLOR/@/$ON}
HOURS[$((${HOUR/#12/0}+1))]=${COLOR/@/$ON}
TO=${COLOR/@/$ON}
;;
esac
cat<<:EOF
${COLOR/@/$OFF}A S ${COLOR/@/$ON}I T${COLOR/@/$OFF} L ${COLOR/@/$ON}I S${COLOR/@/$OFF} T I M E
D ${QUARTER}A${QUARTER/$ON/$OFF} C ${QUARTER}Q U A R T E R${QUARTER/$ON/$OFF} C
${TWENTY}T W E N T Y${TWENTY/$ON/$OFF} X ${FIVE}F I V E${FIVE/$ON/$OFF}
${HALF}H A L F${HALF/$ON/$OFF} B ${TEN}T E N${TEN/$ON/$OFF} F ${TO}T O${TO/$ON/$OFF}
${PAST}P A S T${PAST/$ON/$OFF} E R ${HOURS[9]}N I N E${HOURS[9]/$ON/$OFF} U
${HOURS[1]}O N E${HOURS[1]/$ON/$OFF} ${HOURS[6]}S I X${HOURS[6]/$ON/$OFF} ${HOURS[3]}T H R E E${HOURS[3]/$ON/$OFF}
${HOURS[4]}F O U R${HOURS[4]/$ON/$OFF} ${HOURS[5]}F I V E${HOURS[5]/$ON/$OFF} ${HOURS[2]}T W O${HOURS[2]/$ON/$OFF}
${HOURS[8]}E I G H T${HOURS[8]/$ON/$OFF} ${HOURS[11]}E L E V E N${HOURS[11]/$ON/$OFF}
${HOURS[7]}S E V E N${HOURS[7]/$ON/$OFF} ${HOURS[12]}T W E L V E${HOURS[12]/$ON/$OFF}
${HOURS[10]}T E N${HOURS[10]/$ON/$OFF} S E ${OCLOCK}O C L O C K${OCLOCK/$ON/$OFF}
:EOF

#!/bin/bash
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
cd $(dirname $0)
# horizontal calendar for conky by ans
# Updated by: mobilediesel, dk75, Bruce, Crinos512, et al.
# locale depend week day names
DOW=("Lu" "Ma" "Mi" "Ju" "Vi" "Sá" "Do")
if [ -f lang ]; then
    . lang
fi
COLOROLD="778899" #LightSlateGrey
COLORTODAY="FF8C00" #Darkorange
COLORREST="778899" #LightSlateGrey
COLORNEXT="445566" #MidSlateGrey
COLORSATURDAY="FFFF00"
COLORSUNDAY="FF8C00"
COLOR=("" "" "" "" "" "\${color $COLORSATURDAY}" "\${color $COLORSUNDAY}")
COLOREND=("" "" "" "" "" "\${color}" "\${color}")

TODAY=$(date +%-d)
LASTDAY=$(date -d "-$TODAY days +1 month" +%d)
FIRSTDAY=$(date -d "-$[$TODAY-1] days" +%u)

# Build $TOPLINE
k=$FIRSTDAY
for j in $(seq 31); do
  x=$[j+LASTDAY/j]
  case $j in
    ${j/#$x})   TOPLINE="$TOPLINE ${COLOR[$[k-1]]}${DOW[$[k-1]]}${COLOREND[$[k-1]]}";;
    $[LASTDAY+1])   TOPLINE="$TOPLINE \${color $COLORNEXT}${DOW[$[k-1]]}";;
    *)      TOPLINE="$TOPLINE ${DOW[$[k-1]]}";;
  esac
  k=$[${k/#7/0}+1]
done


BOTTOM=" \${color $COLOROLD}$(seq -w -s ' ' $LASTDAY|sed "s/.$TODAY \?/\${color $COLORTODAY}&\${color $COLORREST}/") \${color $COLORNEXT}$(seq -w -s ' ' 0$[31-$LASTDAY])"

echo "$TOPLINE\${tab 20}"
echo "$BOTTOM\${color}\${tab 20}"

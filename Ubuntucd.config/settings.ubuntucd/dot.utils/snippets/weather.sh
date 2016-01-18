#!/bin/bash
# weather.sh
# copyright 2011 by Mobilediesel
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

weather=$(echo -en "$(conkyForecast -i --location=48174 --template=$HOME/conky/conkyForecast.template)" | sed -e "s/\${HEAD}/\${color grey}/g" -e "s/\${SUBHEAD}/\${color 808080}/g" -e "s/\${RESET}/\${color 99ccff}/g")
echo "$weather"

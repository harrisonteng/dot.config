#!/bin/sh

# USAGE: weather.sh <location code>

METRIC=c # Use f for F, c for C

if [ -z $1 ]; then
	echo
	echo "USAGE: weather.sh <locationcode>"
	echo
	exit 0;

fi


#curl -s "http://weather.yahooapis.com/forecastrss?w=$1&u=$METRIC" |grep -A 2 -E '(Current Conditions|Forecast):'|sed -n 's/<BR \/>/pI' |grep -v -E '(Current Conditions|Forecast):' |tr '\n' '|';
curl -s "http://weather.yahooapis.com/forecastrss?w=$1&u=$METRIC" |grep -A 2 -E '(Current Conditions|Forecast):'|sed -n 's/<[Bb][Rr] \/>//;s/<b>//;s/<\/b>//;s/<[Bb][Rr] \/>//;p;';
#curl -s http://weather.yahooapis.com/forecastrss\?w=\$1\&u=\$METRIC | sed -n '/Current Conditions:/ s/.*: \(.*\): \([0-9]*\)\([CF]\).*/\2°\3, \L\1/p'

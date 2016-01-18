#!/bin/bash

while read line;do
	if ( grep "$line" 0.csv );then
		echo "$line is find";
	echo $line;
done<1.csv

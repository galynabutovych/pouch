#!/bin/bash

find .  -name *.log -print0 | while IFS= read -r -d '' file;
do
	echo "$file";
	ctail="tail -1 $file"
	l=`eval $ctail`
	if [[ "$l" == *"Normal termination"* ]]; then
		fileo="${file%.*}.txyz"
		cobabel="obabel -ig16 $file -O$fileo"
		`eval $cobabel`
		cdist="/usr/bin/python3.9 d.py --ifile $fileo --ofile ${file%.*}.dist.txt"
		echo "$cdist"
		`eval $cdist`
	fi
done


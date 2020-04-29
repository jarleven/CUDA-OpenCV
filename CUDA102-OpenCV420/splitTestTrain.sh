#!/bin/bash


#
# Split a folder containing jpg/xml pairs of training data
#
#


rm -rf testFiles.txt
rm -rf trainFiles.txt

touch testFiles.txt
touch trainFiles.txt

COUNTER=0
TEST=5      # 1/5th of the files into testfolder

find ./keepThis/ -name '*.jpg'  -print0 |
    while IFS= read -r -d '' line; do
#            file "$line"
             var=`basename $line .jpg`
             
             echo The counter is $COUNTER
             let COUNTER=COUNTER+1 
             
	     if [ "$COUNTER" -eq "$TEST" ]; then
                echo "   They're equal"
                echo $var".xml" >> testFiles.txt
                echo $var".jpg" >> testFiles.txt

                file=testFiles.txt
                folder="./test/"
		COUNTER=0
	     else
		echo "Normal"
                echo $var".xml" >> trainFiles.txt
                echo $var".jpg" >> trainFiles.txt
                file=trainFile.txt
                folder="./train/"
	     fi

             echo $var".xml" >> $file
             echo $var".jpg" >> $file

             cp "./keepThis/"$var".xml" $folder
             cp "./keepThis/"$var".jpg" $folder
	     

    done

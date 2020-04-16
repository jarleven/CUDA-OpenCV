#!/bin/bash


#
# Keep jpg/xml pair matching filenames in the debug/preview folder
#
#


# TODO - Exit if folders are missing

rm -rf filesToKeep.txt

touch filesToKeep.txt


find ./annotateddebug/ -name '*.png'  -print0 |
    while IFS= read -r -d '' line; do
#            file "$line"
             var=`basename $line .png`
	     echo $var".xml" >> filesToKeep.txt
             echo $var".jpg" >> filesToKeep.txt
             

             cp "./annotated/"$var".xml" "./keepThis/"
             cp "./annotated/"$var".jpg" "./keepThis/"
	     

    done

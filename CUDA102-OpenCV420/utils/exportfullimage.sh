#!/bin/bash

#
# the file [list.txt] is on in this format
# syd__2019-06-24__13-30-01.mp4 11557
# syd__2019-06-24__20-30-01.mp4 17651
# syd__2019-06-24__20-45-01.mp4 18405
# syd__2019-06-25__06-45-01.mp4 10827
#

while read p; do

  FILENAME=$(echo $p |awk '{print $1}')
  FRAME=$(echo $p |awk '{print $2}')


  cd ~/laksenArcive/Archive/

  INFILEPATH=$(find . -name $FILENAME)

  OUTFILE=$FILENAME"_"$FRAME".png"

  echo "Filename[$FILENAME] path[$INFILEPATH] frame[$FRAME] out[$OUTFILE]"


  ffmpeg -loglevel panic -i $INFILEPATH -vf "select=eq(n\,$FRAME)" -vframes 1 $OUTFILE < /dev/null &
  wait $!
  sleep 1 

done <list.txt


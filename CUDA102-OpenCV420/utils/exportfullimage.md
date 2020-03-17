



rm -rf files.txt && rm -rf list.txt && ls *.jpg -1 > files.txt && awk -F ".mp4_" '{print $1".mp4  " $2}' files.txt | awk -F "_crop_" '{print $1"  "$2}' | awk -F "  " '{print $1" "$2}' > list.txt



#!/bin/bash


while read p; do
  echo "$p"


  FILENAME=$(echo $p |awk '{print $1}')
  FRAME=$(echo $p |awk '{print $2}')


  echo "Filename[$FILENAME] frame[$FRAME]"

  cd laksenArcive/Archive/
  find . -name $EXPFILE

  EXPFILEPATH=$(find . -name $EXPFILE)

  OUTFILE=$EXPFILE"_"$EXPFILEFRAME".png"

  ffmpeg -i $EXPFILEPATH -vf "select=eq(n\,$EXPFILEFRAME)" -vframes 1 "/home/jarleven/"$OUTFILE

done <list.txt





ffmpeg -i ./2019-07-09/syd__2019-07-09__13-45-00.mp4 -vf "select=eq(n\,7326)" -vframes 1 /home/jarleven/out.png^C                               jarleven@eidselva:~/laksenArcive/Archive$ EXPFILE=syd__2019-07-09__13-45-00.mp4
jarleven@eidselva:~/laksenArcive/Archive$ ffmpeg -i ./2019-07-09/syd__2019-07-09__13-45-00.mp4 -vf "select=eq(n\,34)" -vframes 1 out.png~^C
jarleven@eidselva:~/laksenArcive/Archive$ find . -name $EXPFILE
./2019-07-09/syd__2019-07-09__13-45-00.mp4
jarleven@eidselva:~/laksenArcive/Archive$ EXPFILEPATH="find . -name $EXPFILE"
jarleven@eidselva:~/laksenArcive/Archive$ echo $EXPFILEPATH
find . -name syd__2019-07-09__13-45-00.mp4
jarleven@eidselva:~/laksenArcive/Archive$ EXPFILEPATH=$(find . -name $EXPFILE)
jarleven@eidselva:~/laksenArcive/Archive$ echo $EXPFILEPATH
./2019-07-09/syd__2019-07-09__13-45-00.mp4


	


EXPFILE=$1
EXPFILEFRAME=$2

cd laksenArcive/Archive/

find . -name $EXPFILE

find . -name "~/laksenArcive/Archive"$EXPFILE

EXPFILEPATH=$(find . -name $EXPFILE)

OUTFILE=$EXPFILE"_"$EXPFILEFRAME".png"


ffmpeg -i $EXPFILEPATH -vf "select=eq(n\,$EXPFILEFRAME)" -vframes 1 "/home/jarleven/"$OUTFILE




FILENAME=$(echo $|awk '{print $2}')
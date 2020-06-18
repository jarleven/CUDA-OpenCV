#!/bin/bash

# The full length movies

#ARCHIVEROOT="/home/jarleven/NFSARCHIVE"
#OUTPUTROOT="/media/jarleven/Extended/ExportV2"
ARCHIVEROOT="/media/jarleven/STORE"
OUTPUTROOT="/media/jarleven/STORE/Export"

FILEEXT=".png"

# The JPGs folder is passed on the CLI


PRETIME=5
POSTTIME=5
FPS=25

MAXGAP=200
MIN_NUMSECTIONS=1
# ---------------------------------------------


INPUTFOLDER=$1

NUMSECTIONS=0

PREFRAMES=$((FPS*PRETIME))
POSTFRAMES=$((FPS*POSTTIME))



prev_file=""
prev_frameOff=""


# file [nord__2020-05-23__05-00-00]   date []  fbname [nord__2020-05-23__05-00-00.mp4_03940]  loopvar [nord__2020-05-23__05-00-00.mp4_03940.png]    frameoffset [3940]


createColck(){

    CAMERA=$1
    DATE=$2
    TIMEA=$3
    echo ""
    echo $CAMERA
    echo $DATE
    echo $TIMEA
    echo ""


    # Pretty date [Mandag 25. Mai 2020]
    PRETTYDATE=$(date -d $DATE +"%A %d. %B %Y")
    PRETTYDATE=$(sed -r 's/\<./\U&/g' <<<"$PRETTYDATE")
    echo "Pretty date [$PRETTYDATE]"

#CAMERA=$(echo $filename | awk -F"__" '{print $1}')
#DATE=$(echo $filename | awk -F"__" '{print $2}')
#TIMEA=$(echo $filename | awk -F"__" '{print $3}' | awk -F".mp4" '{print $1}')
H=$(echo $TIMEA | awk -F"-" '{print $1}')


TIME=${TIMEA//-/:}
H12=$(date +"%I:%M" --date="$TIME" | awk -F: '{print $1}')
M12=$(date +"%I:%M" --date="$TIME" | awk -F: '{print $2}')
AMPM="AM"
NIGHTTIME=1
#1,2,3,4,5,6,7,8,9,10,11,12 AM
#13,14,15,16,17,18,19,20,21,22,23 PM
#0,24 --

echo "Testing with H:[$H]"
if [ "$H" -gt 12 ]; then
        AMPM="PM"
	NIGHTTIME=0
fi
if [ "$H" -eq 00 ]; then
        AMPM=""
fi


echo "$CAMERA  [$PRETTYDATE]  12Hour H:[$H12] M:[$M12] AMPM:[$AMPM] "


rm -f ~/timeTmp.png
rm -f time.svg ~/time.svg
rm -f ~/time.png
echo "A"
rm -f ~/output.png
echo "B"
rm -f ~/small_time.png

echo "Make clock"
python3 ~/pythonClock.py $H12 -d "$M12"


#cp ./time.svg ~/
echo "Convert inkscape"
inkscape ~/time.svg --export-filename ~/timeTmp.png </dev/null >/dev/null 2>>/home/jarleven/inkscape.log
wait $!
#echo "text 480,425 '$AMPM' text 220,800 '$DATE' "

#convert -pointsize 80 -fill black -draw "text 480,425 'AM' text 220,800 '2020-05-21'" timeTmp.png time.png
echo "Add text"
convert -pointsize 80 -fill black -draw "text 480,425 '$AMPM' text 20,800 '$PRETTYDATE' " ~/timeTmp.png ~/time.png </dev/null >/dev/null 2>>/home/jarleven/convert.log
wait $!
#convert -pointsize 80 -fill black -draw 'text 480,425 "AM" text 220,800 "21.05.2020" ' timeTmp.png time.png

if [ "$NIGHTTIME" == 1 ]; then

  convert ~/time.png -channel RGB -negate ~/output.png </dev/null >/dev/null 2>>/home/jarleven/convert.log
  wait $!
  cp ~/output.png ~/time.png
fi


echo "Make 720p image"
convert ~/time.png -resize 200X200 ~/small_time.png </dev/null >/dev/null 2>>/home/jarleven/convert.log
wait $!

sleep 4



}



processSequence(){
  inFile=$1
  outFile=$2
  startTS=$((10#$3))
  endTS=$((10#$4))
  camera=$5



  NUMFRAMES=""
  NUMFRAMES=$(ffprobe -v error -select_streams v:0 -show_entries stream=nb_frames -of default=nokey=1:noprint_wrappers=1 $inFile)
  echo "Frames in file [$NUMFRAMES]"

  FFFPS=$(ffprobe -v error -select_streams v -of default=noprint_wrappers=1:nokey=1 -show_entries stream=r_frame_rate $inFile)

    echo "FFMPEG FPS in file [$FFFPS]"


  if (( startTS > PREFRAMES )); then
    exportStart=$((startTS-PREFRAMES))
  else
    exportStart=0
  fi

  exportEnd=$((endTS+POSTFRAMES))
  if (( exportend > NUMFRAMES )); then
    exportEnd=$NUMFRAMES
  fi

  echo "FRAMES to extract $exportStart to $exportEnd"

  FPS=25
  startSecs=$((exportStart / FPS))
  startTime=$(printf '%02d:%02d:%02d' $(($startSecs/3600)) $(($startSecs%3600/60)) $(($startSecs%60)))

  endSecs=$((exportEnd / FPS))
  endTime=$(printf '%02d:%02d:%02d' $(($endSecs/3600)) $(($endSecs%3600/60)) $(($endSecs%60)))

  echo "Starttime $startTime  seconds $startSecs framenum $startTS  FPS=$FPS"
  echo "Endtime   $endTime    seconds $endSecs  framenum $endTS  FPS=$FPS"



#  ffmpeg -i $filename -i ~/time.png -filter_complex "overlay=x=main_w-overlay_w-(main_w*0.01):y=main_h*0.01" -q 15 $outpath"/"$filename &


##  ffmpeg -strict 2 -hwaccel auto -i $inFile -vf select="between(n\,$exportStart\,$exportEnd)" -c:v hevc_nvenc -rc vbr -cq 24 -qmin 24 -qmax 24 $outFile &
 

  # ffmpeg -strict 2 -c:v hevc_cuvid -ss $startTime -to $endTime -i $inFile -i ~/time.png -filter_complex "overlay=x=main_w-overlay_w-(main_w*0.01):y=main_h*0.01" -c:v hevc_nvenc -rc vbr -cq 24 -qmin 24 -qmax 24 $outFile &

  echo $inFile
  echo $outFile
  echo $exportStart
  echo $exportEnd
  echo $camera

   if [ "$camera" == "4Ks" ]
   then
       echo "Encode 4K"
       echo "ffmpeg -strict 2 -c:v hevc_cuvid  -i $inFile -filter_complex '[0]select=between(n\,$exportStart\,$exportEnd)[x];movie=/home/jarleven/time.png[wm];[x][wm]overlay=x=main_w-overlay_w-(main_w*0.01):y=main_h*0.01[out]' -map [out] -c:a null -c:v hevc_nvenc -rc vbr -cq 24 -qmin 24 -qmax 24 $outFile" >> /home/jarleven/ffmpeg.txt
       ffmpeg -strict 2 -c:v hevc_cuvid  -i $inFile -filter_complex "[0]select=between(n\,$exportStart\,$exportEnd)[x];movie=/home/jarleven/time.png[wm];[x][wm]overlay=x=main_w-overlay_w-(main_w*0.01):y=main_h*0.01[out]" -map [out] -c:a null -c:v hevc_nvenc -rc vbr -cq 24 -qmin 24 -qmax 24 $outFile &
       wait $!

   else
      echo "Encode 720p"
      echo "ffmpeg -strict 2 -c:v h264_cuvid  -i $inFile -filter_complex '[0]select=between(n\,$exportStart\,$exportEnd)[x];movie=/home/jarleven/small_time.png[wm];[x][wm]overlay=x=main_w-overlay_w-(main_w*0.01):y=main_h*0.01[out]' -map [out] -c:a null -c:v h264_nvenc -pix_fmt yuv420p -preset slow -rc vbr_hq -b:v 8M -maxrate:v 10M $outFile" >> /home/jarleven/ffmpeg.txt
      ffmpeg -strict 2 -c:v h264_cuvid  -i $inFile -filter_complex "[0]select=between(n\,$exportStart\,$exportEnd)[x];movie=/home/jarleven/small_time.png[wm];[x][wm]overlay=x=main_w-overlay_w-(main_w*0.01):y=main_h*0.01[out]" -map [out] -c:a null -c:v h264_nvenc -pix_fmt yuv420p -preset slow -rc vbr_hq -b:v 8M -maxrate:v 10M $outFile </dev/null >/dev/null 2>>/home/jarleven/convert.log
      wait $!
	   
  fi




  #  ffmpeg -strict 2 -c:v hevc_cuvid  -i $inFile -i ~/time.png -filter_complex "[0:v]select=between(n\,$exportStart\,$exportEnd)[x];[x][1:v]overlay=x=main_w-overlay_w-(main_w*0.01):y=main_h*0.01[out]" -map [out] -c:a null -c:v hevc_nvenc -rc vbr -cq 24 -qmin 24 -qmax 24 -vsync 0 $outFile &


# -c:v h264_nvenc -pix_fmt yuv420p -preset slow -rc vbr_hq -b:v 8M -maxrate:v 10M -c:a null


#  [cut][1:v]overlay=x=2000:y=2000[out]

#[0:v]select=between(n\,$exportStart\,$exportEnd)[cut]


# ffmpeg -c:v hevc_cuvid  -i $inFile -i ~/time.png -filter_complex "[0]select=between(n\,$exportStart\,$exportEnd)[final];[final][1]overlay=x=main_w-overlay_w-(main_w*0.01):y=main_h*0.01[out]" -map [out] -c:a null -c:v hevc_nvenc -rc vbr -cq 24 -qmin 24 -qmax 24 $outFile &








#  sleep 5
#  ffmpeg -strict 2 -hwaccel auto -i /home/jarleven/NFSARCHIVE/2020-05-23/4Ks__2020-05-23__01-45-02.mp4 -vf select="between(n\,2500\,2600)" -c:v hevc_nvenc -rc vbr -cq 24 -qmin 24 -qmax 24  testmeg.mp4 &





}





cd $INPUTFOLDER

start_FrameOff=0
STARTED="False"


NUMFILES=$(ls -v *$FILEEXT | wc -l)

for i in $(ls -v *$FILEEXT | sort -n) ; do

   processedFiles=$((processedFiles+1))	
   NUMSECTIONS=$((NUMSECTIONS+1))


   fbname=$(basename "$i" $FILEEXT)

   file=$(echo $fbname | awk -F ".mp4_" '{print $1}' )
   frameOff_=$(echo $fbname | awk -F ".mp4_" '{print $2}' )
   frameOff=$(expr $frameOff_ + 0)
   filedate=$(echo $fbname | awk -F "__" '{print $2}' )

   PROCESSFILE=0

   if [ "$STARTED" == "False" ]
   then
        echo "Initial setup"
	echo ""
        STARTED="True"
        mkdir $OUTPUTROOT"/"$filedate
   fi




   if [ "$file" != "$prev_file" ]
   then
      echo "NEW FILE"

      
      # The frame difference is now of course 0
      # Set the previous frame offset to current frame offset
#     prev_frameOff=$frameOff
      PROCESSFILE=1
   fi

   delta=$((frameOff - prev_frameOff))
   if (( delta > MAXGAP ))
   then
      echo "GAP"
      PROCESSFILE=1
   fi

   if (( processedFiles == NUMFILES ))
   then
     echo "LAST FILE"
     PROCESSFILE=1
  fi

   if (( PROCESSFILE == 1 ))
   then


          if [ ! -z $prev_file ]
          then

             echo ""
	     echo " PROCESS "
             echo "File [$prev_file] Frame from-to [$start_FrameOff]-[$prev_frameOff]  Number of images in this sequence [$NUMSECTIONS] "

	     foo_start_FrameOff=$(printf "%05d" $start_FrameOff)

             INPUTFILE=$ARCHIVEROOT"/"$filedate"/"$prev_file".mp4"
	     OUTPUTFILE=$OUTPUTROOT"/"$filedate"/"$prev_file".mp4_"$foo_start_FrameOff".mp4"
	     echo "Inputfile  [$INPUTFILE]"
	     echo "Outputfile [$OUTPUTFILE]"
             echo ""

	     file_cam=$(echo $prev_file | awk -F"__" '{print $1}')
#	     filedate=$(echo $file | awk -F"__" '{print $2}')
	     file_time=$(echo $prev_file | awk -F"__" '{print $3}' | awk -F".mp4" '{print $1}')



             if (( NUMSECTIONS > MIN_NUMSECTIONS ))
             then

		createColck $file_cam $filedate $file_time

                processSequence $INPUTFILE $OUTPUTFILE $start_FrameOff $prev_frameOff $file_cam
             fi

         fi
      # We are starting a new section store the starting point
      start_FrameOff=$frameOff
      NUMSECTIONS=0
   fi


   echo "File [$file]   date [$filedate]  fbname [$fbname]  loopvar [$i]    frameoffset [$frameOff]   sections [$NUMSECTIONS] framedelta [$delta] "

   prev_file=$file
   prev_frameOff=$frameOff

done





cd $OUTPUTROOT"/"$filedate"/"

pwd

CAMERANAME="Syd4K"
exportFilename=$(date -d $filedate +"%d.-%B-%Y-$CAMERANAME.mp4")
echo "Exporting as name [$exportFilename]"


find "`pwd`" -maxdepth 1 -name "*.mp4" | grep "4Ks" | awk '{print "file "$1}' > 4K_movielist.txt
sort 4K_movielist.txt > 4K_sorted_movielist.txt

ffmpeg -f concat -safe 0 -i 4K_sorted_movielist.txt -c copy $exportFilename </dev/null >/dev/null 2>>/home/jarleven/convert.log
wait $!

echo "Exporting as name [$exportFilename]"

echo "List completed - Process  $NUMSECTIONS "


CAMERANAME="Syd"
exportFilename=$(date -d $filedate +"%d.-%B-%Y-$CAMERANAME.mp4")
echo "Exporting as name [$exportFilename]"


find "`pwd`" -maxdepth 1 -name "*.mp4" | grep  "syd" | awk '{print "file "$1}' > syd_movielist.txt
sort syd_movielist.txt > syd_sorted_movielist.txt

ffmpeg -f concat -safe 0 -i syd_sorted_movielist.txt -c copy $exportFilename </dev/null >/dev/null 2>>/home/jarleven/convert.log
wait $!


CAMERANAME="Nord"
exportFilename=$(date -d $filedate +"%d.-%B-%Y-$CAMERANAME.mp4")
# Capitalize first letter in every word
exportFilename=$(sed -r 's/\<./\U&/g' <<<"$exportFilename")


echo "Exporting as name [$exportFilename]"


find "`pwd`" -maxdepth 1 -name "*.mp4" | grep  "nord" | awk '{print "file "$1}' > nord_movielist.txt
sort nord_movielist.txt > nord_sorted_movielist.txt

ffmpeg -f concat -safe 0 -i nord_sorted_movielist.txt -c copy $exportFilename </dev/null >/dev/null 2>>/home/jarleven/convert.log
wait $!



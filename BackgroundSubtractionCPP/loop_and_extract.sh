#/bin/bash

STARTDATE=$(date)
STARTTIME=$(date +'%s')

set -e  # Exit immediately if a command exits with a non-zero status. (Exit on error)
#set -x  # Print commands and their arguments as they are executed.
set -u  # Treat unset variables as an error when substituting.





SCORE=0.9


function analyseImages {
	python3 ~/CUDA-OpenCV/CUDA102-OpenCV420/test_model_v21.py -m $MODELPATH -o $OUTPUTDIR -d $DEBUGDIR -l $SCORE
}


function printhelp {
	echo " Run like hell"
	exit
}

function exitFailiure {
    exit "Missing files folders or write permissions"
    exit
}



# Allow for passing of CUDA architecture when startring the script
while [ $# -gt 0 ] ; do
  case $1 in
    -i | --inputdir) INPUTDIR="$2" ;;
    -o | --outputdir) OUTPUTBASEDIR="$2" ;;
    -m | --model) MODELPATH="$2" ;;
    -d | --debugdir) DEBUGDIR="$2" ;;
    -s | --score) SCORE="$2" ;;

  esac
  shift
done


if [ -z $INPUTDIR ]; then
 echo "No inputdir scpecified"
 printhelp
fi

if [ -z $OUTPUTBASEDIR ]; then
    echo "No inputdir scpecified"
    printhelp
fi

if [ -z $MODELPATH ]; then
    echo "No model scpecified"
    printhelp
fi



RAMDISK=/tmp/ramdisk/full


INPUTDIR=$(realpath ${INPUTDIR})
OUTPUTBASEDIR=$(realpath ${OUTPUTBASEDIR})
RAMDISK=$(realpath ${RAMDISK})


#INPUTDIR=$A
#OUTPUTBASEDIR=$B



RAMDISK=/tmp/ramdisk/full



#  TODO check write permission

# Check files
if [ ! -f "$MODELPATH" ]; then
    echo "$MODELPATH does not exist"
    exitFailiure
fi

# Check folders

if [ ! -d "$INPUTDIR" ]; then
    echo "$INPUTDIR does not exist"
    exitFailiure
fi

if [ ! -d "$OUTPUTBASEDIR" ]; then
    echo "$OUTPUTBASEDIR does not exist"
    exitFailiure
fi


if [ ! -d "$RAMDISK" ]; then
    echo "$RAMDISK does not exist"
    exitFailiure
fi





rm -f /tmp/ramdisk/full/*
rm -f bgsub.log
rm -f samplefile.txt






LOGFILENAME=$(basename $INPUTDIR)

WORKNAME=$LOGFILENAME

OUTPUTDIR=$OUTPUTBASEDIR/$WORKNAME"-Annotated"
DEBUGDIR=$OUTPUTBASEDIR/$WORKNAME"-Debug"

TOUCHFILE=$(realpath ${INPUTDIR})/$LOGFILENAME".txt"
TOUCHFILE=logfile-$WORKNAME.txt



echo ""
echo "cleanup"
echo "rm -rf $OUTPUTDIR && rm -rf $DEBUGDIR && rm $TOUCHFILE"
echo ""


mkdir $OUTPUTDIR
mkdir $DEBUGDIR


TOUCHFILE=$(realpath ${INPUTDIR})/$LOGFILENAME".txt"
TOUCHFILE=logfile-$WORKNAME.txt



# realpath returns path WITHOUT trailing slash
FILELIST=$(realpath ${OUTPUTDIR})/"filelist.txt"
MOVIE=$(realpath ${OUTPUTDIR})"/"$WORKNAME".mp4"
SUMMARY=$(realpath ${OUTPUTDIR})"/"$WORKNAME".txt"


INPUTPATHx=$(realpath ${INPUTDIR})
INPUTFILESx=$(ls -l $INPUTPATHx/*.mp4 | wc -l)



echo "Inputdir         : "$INPUTDIR
echo "Outputdir        : "$OUTPUTDIR
echo ""
echo "Num files        : "$INPUTFILESx
echo "Output jpg/xml   : "$OUTPUTDIR
echo "Output debug png : "$DEBUGDIR
echo "Logfile          : "$TOUCHFILE
echo "Movie out        : "$MOVIE
echo "Model            : "$MODELPATH
echo "Score (min)      : "$SCORE


echo "TODO : frame divisor for bgsub"
echo "TODO : Magic numbers in BGSUB and log it"
echo "TODO : Get the modefile info.txt and log it"
echo "TODO : One line per file AI and GBSUB"
echo "TODO : Clean up all the printing in AI"
echo "TODO : Cleanup all the printing in BGSUB"
echo "TODO : Investigate the issue with the RAMDRIVE"

echo "DEBUG, will sleep 10 seconds"
sleep 10





# Exit if we already processed this folder.
if test -f "$TOUCHFILE"; then
    echo "File already created $TOUCHFILE"
    touch "FAILED-"$LOGFILENAME".txt"
    exit
fi

# Some kind of gurad against parallel processing race confition (The obscure way)
touch $TOUCHFILE

LOOPNUM=0

FILENUM=0
DETECTIONFILES=0
find $INPUTDIR -name '*.mp4'  -print0 |
while IFS= read -r -d '' line; do
    echo $line >> $FILELIST
    let "FILENUM=FILENUM+1"


    ENDTIME=$(date +'%s')
    ELAPSEDTIME=$(date -u -d "0 $ENDTIME seconds - $STARTTIME seconds" +"%H:%M:%S")

    echo ""
    echo "Processing file $FILENUM of $INPUTFILESx. Input archive size is XXXX. Processtime $ELAPSEDTIME  file is $line"

    ./background_subtraction "$line"
    freespace=$(df -hl | grep '/tmp/ramdisk' | awk '{print $5}' | awk -F'%' '{print $1}')
    if [ "$freespace" -lt "70" ];then
       echo "Plenty of storage left, using $freespace%' Processed images $LOOPNUM times analysed images $DETECTIONFILES ";
      continue      
    fi


    motion=$(ls -1 /tmp/ramdisk/full/*.jpg | wc -l)
    let "DETECTIONFILES=DETECTIONFILES+motion"


    analyseImages
    rm -f /tmp/ramdisk/full/*.jpg
    let "LOOPNUM=LOOPNUM+1"


done

# In case we exit the loop without without analysing the extracted images

motion=$(ls -1 /tmp/ramdisk/full/*.jpg | wc -l)
let "DETECTIONFILES=DETECTIONFILES+motion"


analyseImages
rm -f /tmp/ramdisk/full/*.jpg




# Stop the timers
ENDDATE=$(date)
ENDTIME=$(date +'%s')



# Calculate time and filesize
NUMFILES=$(cat $FILELIST | wc -l)
FILESIZE=$(du -ch `cat $FILELIST` | tail -1 | cut -f 1)
HITS=$( ls -l *.jpg $OUTPUTDIR/*.jpg | wc -l)

ELAPSEDTIME=$(date -u -d "0 $ENDTIME seconds - $STARTTIME seconds" +"%H:%M:%S")


if [ "$HITS" -gt "0" ];then
    ffmpeg -f image2 -framerate 2 -i $DEBUGDIR/%*.png -c:v h264_nvenc -preset slow -qp 18 -pix_fmt yuv420p $MOVIE
fi



# Echo to the user
echo " "
echo "Num files   : "$NUMFILES
echo "Filesize    : "$FILESIZE
echo "Hits        : "$HITS
echo "Processtime : "$ELAPSEDTIME
echo " "

# Log some stats we have collected
echo "############### " >> $TOUCHFILE
echo "# Input dir     : $LOGFILENAME" >> $TOUCHFILE
echo "# Hits          : $HITS" >> $TOUCHFILE
echo "# MP4 files     : $NUMFILES" >> $TOUCHFILE
echo "# Motion # files: $DETECTIONFILES" >> $TOUCHFILE
echo "# Header ver.   : v0.12" >> $TOUCHFILE
echo "# Filesize      : $FILESIZE" >> $TOUCHFILE
echo "# Started       : $STARTDATE" >> $TOUCHFILE
echo "# Completed     : $ENDDATE" >> $TOUCHFILE
echo "# Processtime   : $ELAPSEDTIME" >> $TOUCHFILE
echo "# " >> $TOUCHFILE
echo "# Model         : $MODELPATH" >> $TOUCHFILE
echo "# Score         : $SCORE" >> $TOUCHFILE
echo "# " >> $TOUCHFILE
echo "# " >> $TOUCHFILE
echo " " >> $TOUCHFILE

cat ~/EXPORTED5/ModelInfo.txt >> $TOUCHFILE
echo " " >> $TOUCHFILE
echo " " >> $TOUCHFILE

# Concatonate the file we stored in the RAMdrive
cat bgsub.log >> $TOUCHFILE
cat samplefile.txt >> $TOUCHFILE

cp $TOUCHFILE $SUMMARY

cat $SUMMARY

#/bin/bash

STARTDATE=$(date)
STARTTIME=$(date +'%s')

set -e  # Exit immediately if a command exits with a non-zero status. (Exit on error)
#set -x  # Print commands and their arguments as they are executed.
set -u  # Treat unset variables as an error when substituting.




#INPUTDIR=/home/jarleven/NFSARCHIVE/2019-09-01/


SCORE=0.9


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

#if [ -z $MOTIONDIR ]; then
#    echo "No motion fullframe dir (preferance is RAMdrive) scpecified"
#    echo " This is temp storage for the logfile"
##    printhelp
#fi


if [ -z $OUTPUTBASEDIR ]; then
    echo "No inputdir scpecified"
    printhelp
fi

#if [ -z $DEBUGDIR ]; then
#    echo "No debugdir scpecified"
#    printhelp
#fi


if [ -z $MODELPATH ]; then
    echo "No model scpecified"
#    printhelp
fi









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

#if [ ! -d "$DEBUGDIR" ]; then
#    echo "$DEBUGDIR does not exist"
#    exitFailiure
#fi





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

#echo "Logfilename " $LOGFILENAME

#LOGFILE=$(realpath ${OUTPUTDIR})/$LOGFILENAME".txt"
#echo "Logfile path "$LOGFILE

TOUCHFILE=$(realpath ${INPUTDIR})/$LOGFILENAME".txt"
TOUCHFILE=logfile-$WORKNAME.txt



# realpath returns path WITHOUT trailing slash
FILELIST=$(realpath ${OUTPUTDIR})/"filelist.txt"
MOVIE=$(realpath ${OUTPUTDIR})"/"$WORKNAME".mp4"



INPUTPATHx=$(realpath ${INPUTDIR})

INPUTFILESx=$(ls -l $INPUTPATHx/*.mp4 | wc -l)


echo "Inputdir  : "$INPUTDIR
echo "Num files : "$INPUTFILESx
echo "Outputdir : "$OUTPUTDIR
echo "Debugfold : "$DEBUGDIR
echo "Logfile   : "$TOUCHFILE
echo "Movie out : "$MOVIE

echo "Model     : "$MODELPATH

echo "Score     : "$SCORE



echo "TODO : frame divisor for bgsub"
echo "TODO : Magic numbers in BGSUB and log it"
echo "TODO : Get the modefile info.txt and log it"
echo "TODO : One line per file AI and GBSUB"
echo "TODO : Clean up all the printing in AI"
echo "TODO : Cleanup all the printing in BGSUB"
echo "TODO : Investigate the issue with the RAMDRIVE"

sleep 5





#make a logfile in the output dir if it does exis exit.

if test -f "$TOUCHFILE"; then
    echo "File already created $TOUCHFILE"
    touch "FAILED-"$LOGFILENAME".txt"
    exit
fi

# Some kind of gurad against parallel processing race confition (The obscure way)
touch $TOUCHFILE

#touch $LOGFILE


FILENUMx=0

find $INPUTDIR -name '*.mp4'  -print0 |
while IFS= read -r -d '' line; do
    echo $line >> $FILELIST
    let "FILENUMx=FILENUMx+1"


    ENDTIME=$(date +'%s')
    ELAPSEDTIME=$(date -u -d "0 $ENDTIME seconds - $STARTTIME seconds" +"%H:%M:%S")

    echo "Processing file $FILENUMx of $INPUTFILESx. Input archive size is XXXX. Processtime $ELAPSEDTIME"

    ./background_subtraction "$line"
    freespace=$(df -hl | grep '/tmp/ramdisk' | awk '{print $5}' | awk -F'%' '{print $1}')
    if [ "$freespace" -lt "70" ];then
       echo "Plenty of storage left, using $freespace%'";
      continue      
    fi

    python3 ~/CUDA-OpenCV/CUDA102-OpenCV420/test_model_v21.py -m $MODELPATH -o $OUTPUTDIR -d $DEBUGDIR

    rm -f /tmp/ramdisk/full/*.jpg
done

# TODO : In case we exit the loop without without analysing the extracted images
python3 ~/CUDA-OpenCV/CUDA102-OpenCV420/test_model_v21.py -m $MODELPATH -o $OUTPUTDIR -d $DEBUGDIR
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

# Log some stats
echo "############### " >> $TOUCHFILE
echo "# Processed     : $LOGFILENAME" >> $TOUCHFILE
echo "# Header ver.   : v0.11" >> $TOUCHFILE
echo "# Found # files : $NUMFILES" >> $TOUCHFILE
echo "# Filesize      : $FILESIZE" >> $TOUCHFILE
echo "# Hits          : $HITS" >> $TOUCHFILE
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

cat $TOUCHFILE

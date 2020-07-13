#/bin/bash

STARTDATE=$(date)
STARTTIME=$(date +'%s')

set -e  # Exit immediately if a command exits with a non-zero status. Exit on error
set -x  # Print commands and their arguments as they are executed.
set -u  # Treat unset variables as an error when substituting.


# Default values
SCORE=0.9
VIDEOSUMMARY=""
EMAILLIST=""
RAMDISKUSAGE="60"

RAMDISKROOT=/tmp/ramdisk
RAMDISK=/tmp/ramdisk/full
RAMDISKLOG=/tmp/ramdisk/log

RAMDISKROOT=$(realpath ${RAMDISKROOT})
RAMDISK=$(realpath ${RAMDISK})
RAMDISKLOG=$(realpath ${RAMDISKLOG})

rm -f $RAMDISK/*
rm -f $RAMDISKLOG/*

rm -f bgsub.log
rm -f samplefile.txt




function analyseImages {
	echo "python3 ~/CUDA-OpenCV/CUDA102-OpenCV420/test_model_v21.py -m $MODELPATH -o $OUTPUTDIR -d $DEBUGDIR -l $SCORE"
	python3 ~/CUDA-OpenCV/CUDA102-OpenCV420/test_model_v21.py -m $MODELPATH -o $OUTPUTDIR -d $DEBUGDIR -l $SCORE
        rm -f $RAMDISK/*.jpg
	echo "Done analysing images" 
}


function printhelp {
	echo " Run like hell"
	exit
}

function exitFailiure {
    exit "Missing files folders or write permissions"
    sleep 3
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
    -v | --videosummary) VIDEOSUMMARY="$2" ;;
    -e | --email) EMAILLIST="$2" ;;
	    
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



INPUTDIR=$(realpath ${INPUTDIR})
OUTPUTBASEDIR=$(realpath ${OUTPUTBASEDIR})
RAMDISK=$(realpath ${RAMDISK})



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
    echo "sudo mkdir -p /tmp/ramdisk && sudo chmod 777 /tmp/ramdisk && sudo mount -t tmpfs -o size=4G myramdisk /tmp/ramdisk && mkdir /tmp/ramdisk/full"
    exitFailiure
fi

MODELDIR=$(dirname "${MODELPATH}")

LOGFILENAME=$(basename $INPUTDIR)
WORKNAME=$LOGFILENAME
OUTPUTDIR=$OUTPUTBASEDIR/$WORKNAME"-Annotated"
DEBUGDIR=$OUTPUTBASEDIR/$WORKNAME"-Debug"

NFSDIR="/nfs/storage/DateOutput"


TOUCHFILE=logfile-$WORKNAME.txt


# realpath returns path WITHOUT trailing slash
FILELIST=$(realpath ${RAMDISKLOG})/"filelist.txt"
OKFILELIST=$(realpath ${RAMDISKLOG})/"okfilelist.txt"
ERRORFILELIST=$(realpath ${RAMDISKLOG})/"errorfilelist.txt"
SMALLFILELIST=$(realpath ${RAMDISKLOG})/"smallfilelist.txt"
MOTIONFILE=$(realpath ${RAMDISKLOG})/"motionfile.txt"
LOOPFILE=$(realpath ${RAMDISKLOG})/"loopfile.txt"

SUMMARY=$(realpath ${OUTPUTDIR})"/"$WORKNAME".txt"


MOVIE="Not created"
# TODO
# What a messy logic
if [ ! -z "$VIDEOSUMMARY" ]; then
    if [ ! -d "$VIDEOSUMMARY" ]; then
        echo "$VIDEOSUMMARY does not exist"
        exitFailiure
    else
        MOVIE=$(realpath ${VIDEOSUMMARY})"/"$WORKNAME".mp4"
    fi
fi


# Sanitycheck the email list
if [ ! -z "$EMAILLIST" ]; then

    if [ ! -f "$EMAILLIST" ]; then
        echo "$EMAILLIST does not exist"
        exitFailiure
    fi
fi


# Check if the INPUT DIR IS being modified the last two minutes
while true
do
  INPUTAGE=$(find $INPUTDIR/ -cmin -2 | wc -l)
  if [ "$INPUTAGE" -eq "0" ]; then
    echo "No fresh files, we can assume noone is writing to this folder"
    break
  fi
  echo "Wait a bit and check the directory again. $INPUTAGE files have been written lateley"
  sleep 20
done



echo ""
echo "cleanup"
echo "rm -rf $OUTPUTDIR && rm -rf $DEBUGDIR && rm $TOUCHFILE"
echo ""


INPUTFILES=$(find $INPUTDIR -maxdepth 1 -name "*.mp4" | wc -l)


echo "Inputdir         : "$INPUTDIR
echo "Outputdir        : "$OUTPUTDIR
echo ""
echo "Num files        : "$INPUTFILES
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



# Exit if we already processed this folder.
#if test -f "$TOUCHFILE"; then
if test -f "$SUMMARY"; then

    echo "File already created $SUMMARY"
    #touch "FAILED-"$LOGFILENAME".txt"
    exit 0
fi

if test -f "$TOUCHFILE"; then

    echo "File already created $TOUCHFILE"
    echo "Deleting this output"
    sleep 2

    rm -rf $OUTPUTDIR && rm -rf $DEBUGDIR && rm $TOUCHFILE

fi


mkdir -p $OUTPUTDIR
mkdir -p $DEBUGDIR

touch $FILELIST
touch $OKFILELIST
touch $ERRORFILELIST
touch $SMALLFILELIST

touch $MOTIONFILE
touch $LOOPFILE
echo "0" >> $LOOPFILE

# Some kind of gurad against parallel processing race confition (The obscure way)
touch $TOUCHFILE

LOOPNUM=0

FILENUM=0
DETECTIONFILES=0

OKFILESIZE=0
ERRORFILESIZE=0
SMALLFILESIZE=0

OKFILES=0
ERRORFILES=0
SMALLFILES=0



find $INPUTDIR -maxdepth 1 -name '*.mp4'  -print0 |
while IFS= read -r -d '' line; do

    echo $line >> $FILELIST
    FILENUM=$(cat $FILELIST | wc -l)

    ENDTIME=$(date +'%s')
    ELAPSEDTIME=$(date -u -d "0 $ENDTIME seconds - $STARTTIME seconds" +"%H:%M:%S")

    echo ""
    date
    echo "Processing file $FILENUM of $INPUTFILES. Input archive size is XXXX. Processtime $ELAPSEDTIME  file is $line"
    echo "Files  OK $OKFILES  -  Error $ERRORFILES  -  small $SMALLFILES      Loop number $LOOPNUM"


    # Check the integrity of the MPG file
    echo "Line is $line"
    MPGFILENAME=$(basename $line)
    echo "File is $MPGFILENAME"

    minimumsize=1000
    actualsize=$(du -k "$line" | cut -f 1)


    if [ $actualsize -ge $minimumsize ]; then
       echo size is over $minimumsize kilobytes
    else
       echo size is under $minimumsize kilobytes
       echo $line >> $SMALLFILELIST
       let "SMALLFILES=SMALLFILES+1"

       continue
   fi


    echo "background_subtraction "$line
    # disable exitting on error temporarily
    set +e
    background_subtraction "$line"
    RESULT=$?
     if [ ! $RESULT -eq 0 ]; then
        echo "BGSUB FAILED"
        echo $line >> $ERRORFILELIST
       let "ERRORFILES=ERRORFILES+1"

     fi
    set -e  # Exit immediately if a command exits with a non-zero status. (Exit on error)

    echo $line >> $OKFILELIST
    let "OKFILES=OKFILES+1"

    freespace=$(df -hl | grep "$RAMDISKROOT" | awk '{print $5}' | awk -F'%' '{print $1}')
    if [ "$freespace" -lt $RAMDISKUSAGE ];then
      echo "Plenty of storage left, using $freespace% reserverd $RAMDISKUSAGE%. Processed images $LOOPNUM times analysed images $DETECTIONFILES "
      continue      
    fi


    motion=$(find $RAMDISK/ -maxdepth 1 -type f -name "*.jpg" | wc -l)
    echo $motion >> $MOTIONFILE
    let "DETECTIONFILES=DETECTIONFILES+motion"

    analyseImages

    echo $motion >> $MOTIONFILE
    let "LOOPNUM=LOOPNUM+1"
    echo $LOOPNUM >> $LOOPFILE
done

# In case we exit the loop without without analysing the extracted images
motion=$(find $RAMDISK/ -maxdepth 1 -type f -name "*.jpg" | wc -l)
echo "Test in"
echo $motion >> $MOTIONFILE


echo "Test out"
echo "There are $motion .jpg files to analyse"
analyseImages
echo "Done, do the logs now"



# Stop the timers
ENDDATE=$(date)
ENDTIME=$(date +'%s')

echo "Test filesize"

# Calculate time and filesize
NUMFILES=$(cat $FILELIST | wc -l)
if [ -s "$FILELIST" ]
then
    FILESIZE=$(du -ch `cat $FILELIST` | tail -1 | cut -f 1)
    FILESIZEBYTE=$(du -c `cat $FILELIST` | tail -1 | cut -f 1)
else
    FILESIZE=0
    FILESIZEBYTE=0
fi

OKFILES=$(cat $OKFILELIST | wc -l)
if [ -s "$OKFILELIST" ]
then
    OKFILESIZE=$(du -ch `cat $OKFILELIST` | tail -1 | cut -f 1)
else
    OKFILESIZE=0
fi

ERRORFILES=$(cat $ERRORFILELIST | wc -l)
if [ -s "$ERRORFILELIST" ]
then
    ERRORFILESIZE=$(du -ch `cat $ERRORFILELIST` | tail -1 | cut -f 1)
else
    ERRORFILESIZE=0
fi

SMALLFILES=$(cat $SMALLFILELIST | wc -l)
if [ -s "$SMALLFILELIST" ] 
then
    SMALLFILESIZE=$(du -ch `cat $SMALLFILELIST` | tail -1 | cut -f 1)
else
    SMALLFILESIZE=0
fi

LOOPNUM=$(tail -1 $LOOPFILE)
DETECTIONFILES=$(awk '{s+=$1} END {print s}' $MOTIONFILE)

HITS=$(find $OUTPUTDIR/ -maxdepth 1 -type f -name "*.jpg" | wc -l)

echo "Test time"

ELAPSEDTIME=$(date -u -d "0 $ENDTIME seconds - $STARTTIME seconds" +"%H:%M:%S")
let "ELAPSEDTIMESEC=ENDTIME-STARTTIME"

echo "Test version"

# Some info about Tensorflow and the GPU used.
TENSORFLOWVERSION=$(python3 -c 'import tensorflow as tf; print("Tensorflow version : %s" % tf.__version__)')
GPUINFO=$(python3 -c "from tensorflow.python.client import device_lib; print(device_lib.list_local_devices())" | grep "physical_device_desc:" | grep "name: ")


echo "Make movie"

#if [ ! -z $MOVIE ]; then
#    if [ "$HITS" -gt "0" ];then
#        ffmpeg -f image2 -framerate 2 -i $DEBUGDIR/%*.png -c:v h264_nvenc -preset slow -qp 18 -pix_fmt yuv420p $MOVIE
#    fi
#fi


# Log some stats we have collected

echo "Make timetracker log"

BGSUBTIME=$(awk '{sum+=$13 } END { printf("%.2f\n",sum)}' < bgsub.log)
TFTIME=$(awk '{sum+=$6 } END { printf("%.2f\n",sum)}' < samplefile.txt)

let "KBSEC=FILESIZEBYTE/ELAPSEDTIMESEC"


echo "Build the summary file"

echo "################################################### " >> $TOUCHFILE
echo "# Input dir      : $LOGFILENAME" >> $TOUCHFILE
echo "# Hits           : $HITS" >> $TOUCHFILE
echo "# MP4 files      : $NUMFILES" >> $TOUCHFILE
echo "#   OK           : $OKFILES" >> $TOUCHFILE
echo "#   OK kbytes    : $OKFILESIZE" >> $TOUCHFILE
echo "#   Small        : $SMALLFILES" >> $TOUCHFILE
echo "#   Small kbytes : $SMALLFILESIZE" >> $TOUCHFILE
echo "#   Error        : $ERRORFILES" >> $TOUCHFILE
echo "#   Error kbytes : $ERRORFILESIZE" >> $TOUCHFILE
echo "# Motion # files : $DETECTIONFILES" >> $TOUCHFILE
echo "# Header ver.    : v0.20" >> $TOUCHFILE
echo "# Filesize       : $FILESIZE  ($FILESIZEBYTE)" >> $TOUCHFILE
echo "# Started        : $STARTDATE" >> $TOUCHFILE
echo "# Completed      : $ENDDATE" >> $TOUCHFILE
echo "# Processtime    : $ELAPSEDTIME   ($ELAPSEDTIMESEC)" >> $TOUCHFILE
echo "#   BGSUB        : $BGSUBTIME" >> $TOUCHFILE
echo "#   TF           : $TFTIME" >> $TOUCHFILE
echo "#   Byte/sec     : $KBSEC" >> $TOUCHFILE
echo "# Loops          : $LOOPNUM" >> $TOUCHFILE
echo "# " >> $TOUCHFILE
echo "# Model          : $MODELPATH" >> $TOUCHFILE
echo "# Score          : $SCORE" >> $TOUCHFILE
echo "# " >> $TOUCHFILE
echo "# " >> $TOUCHFILE
echo " " >> $TOUCHFILE
echo "$TENSORFLOWVERSION" >> $TOUCHFILE
echo "$GPUINFO" >> $TOUCHFILE
echo " " >> $TOUCHFILE
cat $MODELDIR/ModelInfo.txt >> $TOUCHFILE
echo " " >> $TOUCHFILE
echo " " >> $TOUCHFILE

# Concatonate the file we stored in the RAMdrive

cat bgsub.log >> $TOUCHFILE
echo ""  >> $TOUCHFILE
cat samplefile.txt >> $TOUCHFILE
echo ""  >> $TOUCHFILE
sed 's/^/File with ERROR:/' $ERRORFILELIST >> $TOUCHFILE
echo ""  >> $TOUCHFILE
sed 's/^/File to small  :/' $SMALLFILELIST >> $TOUCHFILE
echo ""  >> $TOUCHFILE
echo "End of log"  >> $TOUCHFILE


echo "Stash away the summary file"
cp $TOUCHFILE $SUMMARY

cat $SUMMARY




echo "Send email"

if [ ! -z "$EMAILLIST" ]; then

    echo "Send e-mail"
    # Compose an e-mail
    cat $EMAILLIST > mail2.txt
    echo  "subject: Eidselva $WORKNAME summary" >> mail2.txt
    echo  "Hei det er nye filmar paa :" >> mail2.txt
    echo  "https://www.dropbox.com/sh/jdpb8it96sezysu/AAAmXSxE8bW7RULq0ofAJ8N-a?dl=0" >> mail2.txt
    echo  "" >> mail2.txt
    cat $SUMMARY >> mail2.txt
    sendmail -f laksar@eidselva.no -t < mail2.txt
    echo "e-mail sent"
fi

#TODO if backup to NFS if not already using NFS ad output dir
echo "Copy files to NFS"

echo "Output base dir " $OUTPUTBASEDIR
echo "NFS directory " $NFSDIR

if [ "$OUTPUTBASEDIR" = "$NFSDIR" ]; then
    echo "Source and destination are the same."
else
    echo "Copy to NFS."
    cp -r $OUTPUTDIR $NFSDIR
    cp -r $DEBUGDIR $NFSDIR
fi

sleep 3
echo "Done copying"

echo "Exit this folder"


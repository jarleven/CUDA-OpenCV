#/bin/bash

STARTDATE=$(date)
STARTTIME=$(date +'%s')

set -e  # Exit immediately if a command exits with a non-zero status. (Exit on error)
#set -x  # Print commands and their arguments as they are executed.
set -u  # Treat unset variables as an error when substituting.



# Default values
SCORE=0.9
VIDEOSUMMARY=""
EMAILLIST=""
RAMDISKUSAGE="70"


RAMDISK=/tmp/ramdisk/full

rm -f /tmp/ramdisk/full/*
rm -f bgsub.log
rm -f samplefile.txt




function analyseImages {
	python3 ~/CUDA-OpenCV/CUDA102-OpenCV420/test_model_v21.py -m $MODELPATH -o $OUTPUTDIR -d $DEBUGDIR -l $SCORE
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
TOUCHFILE=logfile-$WORKNAME.txt


# realpath returns path WITHOUT trailing slash
FILELIST=$(realpath ${OUTPUTDIR})/"filelist.txt"
SUMMARY=$(realpath ${OUTPUTDIR})"/"$WORKNAME".txt"


INPUTPATH=$(realpath ${INPUTDIR})
INPUTFILES=$(find $INPUTPATH/ -maxdepth 1 -type f -name "*.mp4" | wc -l)




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
  echo "Wait a bit and check the directory again $INPUTAGE files have been written lateley"
  sleep 20
done




echo ""
echo "cleanup"
echo "rm -rf $OUTPUTDIR && rm -rf $DEBUGDIR && rm $TOUCHFILE"
echo ""





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

echo "DEBUG, will sleep 3 seconds"
#sleep 3





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


mkdir $OUTPUTDIR
mkdir $DEBUGDIR




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


find $INPUTDIR -name '*.mp4'  -print0 |
while IFS= read -r -d '' line; do
    echo $line >> $FILELIST
    let "FILENUM=FILENUM+1"


    ENDTIME=$(date +'%s')
    ELAPSEDTIME=$(date -u -d "0 $ENDTIME seconds - $STARTTIME seconds" +"%H:%M:%S")

    echo ""
    echo "Processing file $FILENUM of $INPUTFILES. Input archive size is XXXX. Processtime $ELAPSEDTIME  file is $line"
    echo "Files  OK $OKFILES  -  Error $ERRORFILES  -  small $SMALLFILES"


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
       let "SMALLFILES=SMALLFILES+1"
       let "SMALLFILESIZE=SMALLFILESIZE+actualsize"

       continue
   fi


    touch $MPGFILENAME.log
    #ffmpeg -v error -i $line -f null - 2>$MPGFILENAME.log < /dev/null &
    # All this  > and < is to make sure ffmpeg runs fine inside the script
    ffmpeg -v error -i $line -f null - </dev/null >/dev/null 2>>$MPGFILENAME.log
    wait
    sleep 2
   
    echo "Done checking file"

    if [ ! -f $MPGFILENAME.log ]
    then
        echo "No FFMPEG logfile found, file is probably OK continue processing this file"
	continue
    fi
    if [ -s $MPGFILENAME.log ]
    then
        echo "Errors found in MPG file. Skip this file."

        let "ERRORFILES=ERRORFILES+1"
        let "ERRORFILESIZE=ERRORFILESIZE+actualsize"

	#ffmpeg -i $line -c copy output.mp4 - </dev/null >/dev/null 2>>$MPGFILENAME-fixed.log
        #line=output.mp4
	continue
    else
	    # Remove the empty log files
	    rm -f $MPGFILENAME.log
    fi
    # Integrity check done

    let "OKFILES=OKFILES+1"
    let "OKFILESIZE=OKFILESIZE+actualsize"


    ./background_subtraction "$line"
    freespace=$(df -hl | grep '/tmp/ramdisk' | awk '{print $5}' | awk -F'%' '{print $1}')
    if [ "$freespace" -lt $RAMDISKUSAGE ];then
      echo "Plenty of storage left, using $freespace% reserverd $RAMDISKUSAGE%. Processed images $LOOPNUM times analysed images $DETECTIONFILES "
      continue      
    fi



    motion=$(find /tmp/ramdisk/full/ -maxdepth 1 -type f -name "*.jpg" | wc -l)
    #motion=$(ls -1 /tmp/ramdisk/full/*.jpg | wc -l)
    let "DETECTIONFILES=DETECTIONFILES+motion"


    analyseImages
    rm -f /tmp/ramdisk/full/*.jpg


    let "LOOPNUM=LOOPNUM+1"
done

# In case we exit the loop without without analysing the extracted images

# Better solution ! ls fails when directory is empty

# find . -maxdepth 1 -type f -name "*.jpg" | wc -l

motion=$(find /tmp/ramdisk/full/ -maxdepth 1 -type f -name "*.jpg" | wc -l)
#motion=$(ls -1 /tmp/ramdisk/full/*.jpg | wc -l)
let "DETECTIONFILES=DETECTIONFILES+motion"


analyseImages
rm -f /tmp/ramdisk/full/*.jpg




# Stop the timers
ENDDATE=$(date)
ENDTIME=$(date +'%s')



# Calculate time and filesize
NUMFILES=$(cat $FILELIST | wc -l)
FILESIZE=$(du -ch `cat $FILELIST` | tail -1 | cut -f 1)
#HITS=$( ls -l *.jpg $OUTPUTDIR/*.jpg | wc -l)
HITS=$(find $OUTPUTDIR/ -maxdepth 1 -type f -name "*.jpg" | wc -l)


ELAPSEDTIME=$(date -u -d "0 $ENDTIME seconds - $STARTTIME seconds" +"%H:%M:%S")

# Some info about Tensorflow and the GPU used.
TENSORFLOWVERSION=$(python3 -c 'import tensorflow as tf; print("Tensorflow version : %s" % tf.__version__)')
GPUINFO=$(python3 -c "from tensorflow.python.client import device_lib; print(device_lib.list_local_devices())" | grep "physical_device_desc:" | grep "name: ")




if [ ! -z $MOVIE ]; then
    if [ "$HITS" -gt "0" ];then
        ffmpeg -f image2 -framerate 2 -i $DEBUGDIR/%*.png -c:v h264_nvenc -preset slow -qp 18 -pix_fmt yuv420p $MOVIE
    fi
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
echo "#   MP4 OK      : $OKFILES $OKFILESIZE kBytes" >> $TOUCHFILE
echo "#   MP4 error   : $ERRORFILES $ERRORFILESIZE kBytes" >> $TOUCHFILE
echo "#   MP4 small   : $SMALLFILES $SMALLFILESIZE kBytes" >> $TOUCHFILE
echo "# Motion # files: $DETECTIONFILES" >> $TOUCHFILE
echo "# Header ver.   : v0.13" >> $TOUCHFILE
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
echo "$TENSORFLOWVERSION" >> $TOUCHFILE
echo "$GPUINFO" >> $TOUCHFILE
echo " " >> $TOUCHFILE
cat $MODELDIR/ModelInfo.txt >> $TOUCHFILE
echo " " >> $TOUCHFILE
echo " " >> $TOUCHFILE

# Concatonate the file we stored in the RAMdrive
cat bgsub.log >> $TOUCHFILE
cat samplefile.txt >> $TOUCHFILE

cp $TOUCHFILE $SUMMARY


if [ ! -z "$EMAILLIST" ]; then

    # Compose an e- mail
    cat $EMAILLIST > mail2.txt
    echo  "subject: Eidselva $WORKNAME summary" >> mail2.txt
    echo  "Hei det er nye filmar paa :" >> mail2.txt
    echo  "https://www.dropbox.com/sh/jdpb8it96sezysu/AAAmXSxE8bW7RULq0ofAJ8N-a?dl=0" >> mail2.txt
    echo  "" >> mail2.txt
    cat $SUMMARY >> mail2.txt
    sendmail -f laksar@eidselva.no -t < mail2.txt

fi

cat $SUMMARY

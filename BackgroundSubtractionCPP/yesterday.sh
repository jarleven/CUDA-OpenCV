#!/bin/bash

set -e  # Exit immediately if a command exits with a non-zero status. (Exit on error)
set -x  # Print commands and their arguments as they are executed.
#set -u  # Treat unset variables as an error when substituting.



MYNAME=`basename "$0"`

#sleep 4h

echo "Script name is "$MYNAME
#sleep 15

status=`ps -efww | grep -w $MYNAME | grep -v grep | grep -v $$ | awk '{ print $2 }'`
if [ ! -z "$status" ]; then
        echo "[`date`] : $MYNAME : Process is already running"
        exit 1;
fi




#MODEL=/home/jarleven/faster_rcnn_inception_v2_coco_2018_01_28__Exportdate__2020-05-11__11-49-07/frozen_inference_graph.pb
#MODEL=~/EXPORTED4/frozen_inference_graph.pb

#MODEL=/home/jarleven/EXPORTED9/home/jarleven/faster_rcnn_resnet101_coco_2018_01_28__Exportdate__2020-04-30__20-08-54/frozen_inference_graph.pb

MODEL=/home/jarleven/MODELS/faster_rcnn_resnet101_coco_2018_01_28__Exportdate__2020-04-30__20-08-54/frozen_inference_graph.pb
#MODEL=/home/jarleven/MODELS/faster_rcnn_inception_v2_coco_2018_01_28_AT_1000000_Exportdate__2020-05-15__08-09-56/frozen_inference_graph.pb


OUTPUTROOT=/home/jarleven/DateOutput
OUTPUTVIDEOROOT=/home/jarleven/DateVideo

mkdir -p $OUTPUTROOT
mkdir -p $OUTPUTVIDEOROOT


#if [ "$1" -gt "1" ]; then
	DATE=$1
#else
#	DATE=$(date +"%Y-%m-%d" --date="1 days ago")
#fi



if [[ ! $DISPLAY ]]; then 
	echo "No display"
        export DISPLAY=:0
fi


cd $HOME/CUDA-OpenCV/BackgroundSubtractionCPP/


function doDate() {

   echo $DATE
   sleep 10
   ./loop_and_extract.sh -o $OUTPUTROOT -m $MODEL -s 0.9 -i /nfs/storage/$DATE -v $OUTPUTVIDEOROOT
   #   ./loop_and_extract.sh -o $OUTPUTROOT -m $MODEL -s 0.9 -i /media/jarleven/STORE/$DATE -v $OUTPUTVIDEOROOT

}




  echo "Yesyerday "$DATE
  doDate



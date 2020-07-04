#!/bin/bash


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

#MODEL=/home/jarleven/MODELS/faster_rcnn_resnet101_coco_2018_01_28__Exportdate__2020-04-30__20-08-54/frozen_inference_graph.pb
MODEL=/home/jarleven/MODELS/faster_rcnn_inception_v2_coco_2018_01_28_AT_1000000_Exportdate__2020-05-15__08-09-56/frozen_inference_graph.pb


OUTPUTROOT=/home/jarleven/DateOutput
OUTPUTVIDEOROOT=/home/jarleven/DateVideo

mkdir -p $OUTPUTROOT
mkdir -p $OUTPUTVIDEOROOT

# After this, startdate and enddate will be valid ISO 8601 dates,
# or the script will have aborted when it encountered unparseable data
# such as input_end=abcd
startdate=$(date -I -d "$input_start") || exit -1
enddate=$(date -I -d "$input_end")     || exit -1




source ../CUDA102-OpenCV420/environmet.sh

if [[ ! $DISPLAY ]]; then 
	echo "No display"
        export DISPLAY=:0
fi


cd $HOME/CUDA-OpenCV/BackgroundSubtractionCPP/


echo $DATE
#./loop_and_extract.sh -o $OUTPUTROOT -m $MODEL -s 0.9 -i ~/NFSARCHIVE/$DATE -v $OUTPUTVIDEOROOT
./loop_and_extract.sh -o $OUTPUTROOT -m $MODEL -s 0.9 -i /media/jarleven/STORE/test





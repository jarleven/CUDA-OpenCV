#!/bin/bash



# slightly malformed input data
input_start=2019-7-04
input_end=2019-7-31

# After this, startdate and enddate will be valid ISO 8601 dates,
# or the script will have aborted when it encountered unparseable data
# such as input_end=abcd
startdate=$(date -I -d "$input_start") || exit -1
enddate=$(date -I -d "$input_end")     || exit -1



#export DISPLAY=:0
source ../CUDA102-OpenCV420/environmet.sh


if [[ ! $DISPLAY ]]; then 
	echo "No display"
       	exit -1
fi


cd $HOME/CUDA-OpenCV/BackgroundSubtractionCPP/


function doDate() {

   echo $DATE

   #./loop_and_extract.sh -o /media/jarleven/Extended/tmp -m ~/EXPORTED4/frozen_inference_graph.pb -s 0.9 -i ~/NFSARCHIVE/$DATE -v ~/Dropbox/2020 -e ~/liste.eml
   #./loop_and_extract.sh -o /media/jarleven/Extended/tmp -m /home/jarleven/EXPORTED9/home/jarleven/faster_rcnn_resnet101_coco_2018_01_28__Exportdate__2020-04-30__20-08-54/frozen_inference_graph.pb -s 0.9 -i ~/NFSARCHIVE/$DATE -v ~/Dropbox/2020 



   ./loop_and_extract.sh -o /media/jarleven/Extended/tmp -m /home/jarleven/MY_MODELS/faster_rcnn_inception_v2_coco_2018_01_28_AT_200000_Exportdate__2020-05-01__12-20-29/frozen_inference_graph.pb -s 0.9 -i ~/NFSARCHIVE/$DATE -v ~/Dropbox/2020

}






d="$startdate"
while [ "$d" != "$enddate" ]; do

  YESTERDAY=$(date +"%Y-%m-%d" --date="1 days ago")

  #echo "Yesyerday "$YESTERDAY
  DATE=$YESTERDAY
  doDate

  DATE=$d
  doDate

  #echo "That other day "$d

  d=$(date -I -d "$d + 1 day")
done



#echo $YESTERDAY


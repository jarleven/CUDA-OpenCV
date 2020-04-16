#!/bin/bash

set -e  # Exit immediately if a command exits with a non-zero status. (Exit on error)
set -x  # Print commands and their arguments as they are executed.
set -u  # Treat unset variables as an error when substituting.


cd ~


helptext()  {

   echo "Please provide parameters"
   echo ""
   echo "./export_inference_graph.sh -o /home/$USER/EXPORT4 -n ssd_mobilenet_v2_quantized_300x300_coco_2019_01_03"
   echo ""

   exit
}


# Pass parameters on the CLI.
while [ $# -gt 0 ] ; do
  case $1 in
    -o | --outputdir) OUTDIR="$2" ;;
    -n | --modelname) MODELNAME="$2" ;;
  esac
  shift
done


if [ -z $OUTDIR ]; then
 helptext
fi

if [ -z $MODELNAME ]; then
 helptext
fi

echo "Dir "$OUTDIR
echo "MODEL "$MODELNAME


# Verify that the pretrained modelname is the one we have used
# A crude assumption and requires that the model is extracted and intact in your home dir
cd /home/$USER/$MODELNAME
md5sum * > /home/$USER/TensorFlow/workspace/training_demo/pre-trained-model/verify.md5

cd /home/$USER/TensorFlow/workspace/training_demo/pre-trained-model/
# pipeline.config have been modified by us
sed -i '/pipeline.config/d' verify.md5

if md5sum -c verify.md5; then
    echo "Modelname probably OK"
else
    echo "Model name does not match"
    exit
fi


# Copy the pipeline.config to the git repo

# 326f9550154d33916a8539f3791061c2  ./training/pipeline.config
# 326f9550154d33916a8539f3791061c2  ./training/ssd_mobilenet_v2_quantized_pipeline.config
# 62ccaa21aed491055847ad5b7ee5d81f  ./pre-trained-model/pipeline.config

# cp pipeline.config /home/$USER/CUDA???/$MODELNAME__pipeline.config 



#OUTDIR="/home/$USER/EXPORT4"
#MODELNAME="ssd_mobilenet_v2_quantized_300x300_coco_2019_01_03"

###  ----


mkdir $OUTDIR

PIPELINE="/home/$USER/TensorFlow/workspace/training_demo/training/pipeline.config"


# 
cp $PIPELINE "$OUTDIR/"
cp "/home/$USER/CUDA-OpenCV/CUDA102-OpenCV420/label_map.pbtxt" "$OUTDIR/"



INFOFILE=$OUTDIR"/ModelInfo.txt"
touch $INFOFILE
BUILDDATE=$(date +'%Y-%m-%d')


# Get the latest data from the training

ls -lht ~/TensorFlow/workspace/training_demo/training/ | grep meta | awk -F "." '{print $2}' | awk -F "-" '{print $2}' | head -1
CKPT=$(ls -lht ~/TensorFlow/workspace/training_demo/training/ | grep meta | awk -F "." '{print $2}' | awk -F "-" '{print $2}' | head -1)
NUM_CKPT=$(ls -lht ~/TensorFlow/workspace/training_demo/training/ | grep $CKPT | wc -l)

# TODO - CHECK IF ALL 3 files are present

echo "Found $NUM_CKPT files at CKPT $CKPT"
sleep 3

echo "Exported date           : $BUILDDATE" >> $INFOFILE
echo "Model is based on       : $MODELNAME" >> $INFOFILE
echo "Training checkpoint CKPT: $CKPT" >> $INFOFILE



cd /home/$USER/TensorFlow/models/research/object_detection


python3 export_inference_graph.py \
  --input_type image_tensor \
  --pipeline_config_path $PIPELINE \
  --trained_checkpoint_prefix /home/$USER/TensorFlow/workspace/training_demo/training/model.ckpt-$CKPT \
  --output_directory $OUTDIR


# For simplicity show where to get the frozen_inference_graph.pb file :-)
echo ""
echo ""


for iface in $( ip --brief link show | awk '{print $1}' )
do
    #printf "$iface%s\n"
    IPADDR=$(ip -4 -o addr show $iface | awk '{print $4}' | awk -F"/" '{print $1}')
    #echo $IPADDR
    #declare -a array_test=["$iface"]
    if [ -n "${IPADDR}"  -a  "127.0.0.1" != "${IPADDR}" ]; then
        echo "scp $USER@$IPADDR:$OUTDIR/frozen_inference_graph.pb ."
    fi

done


echo ""



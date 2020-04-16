#!/bin/bash


cd ~

OUTDIR="/home/$USER/EXPORT4"
MODELNAME="ssd_mobilenet_v2_quantized_300x300_coco_2019_01_03"

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



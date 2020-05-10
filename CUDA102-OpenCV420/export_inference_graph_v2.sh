#!/bin/bash

set -e  # Exit immediately if a command exits with a non-zero status. (Exit on error)
#set -x  # Print commands and their arguments as they are executed.
set -u  # Treat unset variables as an error when substituting.


cd ~

MODELNAME=""
EXPORTDATE=$(date +'Exportdate__%Y-%m-%d__%H-%M-%S')
MODELNAME=$(cat ~/TensorFlow/workspace/training_demo/training/modelName.txt | head -1)

echo ""
echo $MODELNAME"__"$EXPORTDATE
echo ""



PIPELINE="/home/$USER/TensorFlow/workspace/training_demo/training/pipeline.config"

# Check if the pipeline.config file is empty or missing. Training the model sometimes erase the file

if [ ! -f "$PIPELINE" ]
then
	echo "File $PIPELINE does not exist"
	echo ""
	echo "cp $HOME/CUDA-OpenCV/CUDA102-OpenCV420/pipeline_config/$MODELNAME.config $HOME/TensorFlow/workspace/training_demo/training/pipeline.config"
	echo ""
	exit
fi


if [ ! -s $PIPELINE ]
then
	echo "pipeline.config is empty"
	echo ""
	echo "cp $HOME/CUDA-OpenCV/CUDA102-OpenCV420/pipeline_config/$MODELNAME.config $HOME/TensorFlow/workspace/training_demo/training/pipeline.config"
	echo ""
	exit
fi

# TODO : THIS MIGHT BE A BIT DODGY...
#PIPELINE_CKPT=$(cat /home/jarleven/CUDA-OpenCV/CUDA102-OpenCV420/pipeline_config/faster_rcnn_inception_v2_coco_2018_01_28.config | grep "num_steps:" | awk '{print $2}')
PIPELINE_CKPT=$(cat $HOME/TensorFlow/workspace/training_demo/training/pipeline.config | grep "num_steps:" | awk '{print $2}')

echo "Configfile was configured to run to checkpint $PIPELINE_CKPT"




OUTDIR=$HOME"/"$MODELNAME"__"$EXPORTDATE



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

#if [ -z $MODELNAME ]; then
# helptext
#fi

echo "Output folder : "$OUTDIR
echo "Base model    : "$MODELNAME


# Verify that the pretrained modelname is the one we have used
# A crude assumption and requires that the model is extracted and intact in your home dir
#cd /home/$USER/$MODELNAME
#md5sum * > /home/$USER/TensorFlow/workspace/training_demo/pre-trained-model/verify.md5

#cd /home/$USER/TensorFlow/workspace/training_demo/pre-trained-model/
# pipeline.config have been modified by us
#sed -i '/pipeline.config/d' verify.md5

#if md5sum -c verify.md5; then
#    echo "Modelname probably OK"
#else
#    echo "Model name does not match"
#    exit
#fi


# Copy the pipeline.config to the git repo

# 326f9550154d33916a8539f3791061c2  ./training/pipeline.config
# 326f9550154d33916a8539f3791061c2  ./training/ssd_mobilenet_v2_quantized_pipeline.config
# 62ccaa21aed491055847ad5b7ee5d81f  ./pre-trained-model/pipeline.config

# cp pipeline.config /home/$USER/CUDA???/$MODELNAME__pipeline.config 



#OUTDIR="/home/$USER/EXPORT4"
#MODELNAME="ssd_mobilenet_v2_quantized_300x300_coco_2019_01_03"

###  ----


mkdir $OUTDIR




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


cd /home/$USER/TensorFlow/models/research/object_detection


python3 export_inference_graph.py \
  --input_type image_tensor \
  --pipeline_config_path $PIPELINE \
  --trained_checkpoint_prefix /home/$USER/TensorFlow/workspace/training_demo/training/model.ckpt-$CKPT \
  --output_directory $OUTDIR


TENSORFLOWVERSION=$(python3 -c 'import tensorflow as tf; print("Tensorflow version : %s" % tf.__version__)')
GPUINFO=$(python3 -c "from tensorflow.python.client import device_lib; print(device_lib.list_local_devices())" | grep "physical_device_desc:" | grep "name: ")

echo "Exported date           : $BUILDDATE" >> $INFOFILE
echo "Model is based on       : $MODELNAME" >> $INFOFILE
echo "Tensorflow ZOO models   : https://github.com/tensorflow/models/blob/master/research/object_detection/g3doc/detection_model_zoo.md" >> $INFOFILE
echo "Training checkpoint CKPT: $CKPT" >> $INFOFILE
echo "Config checkpoint CKPT  : $PIPELINE_CKPT" >> $INFOFILE
echo "" >> $INFOFILE
echo "$TENSORFLOWVERSION" >> $INFOFILE
echo "$GPUINFO" >> $INFOFILE
echo "" >> $INFOFILE
cat ~/TensorFlow/workspace/training_demo/images/datasetInfo.txt >> $INFOFILE



# For simplicity show where to get the frozen_inference_graph.pb file :-)
echo ""
echo ""

echo "Will create tra.bz2 from $OUTDIR"
cd ~
TARFILE=$MODELNAME"_AT_"$CKPT"_"$EXPORTDATE".tar.bz2"
tar -cvjSf $TARFILE -C $OUTDIR .


for iface in $( ip --brief link show | awk '{print $1}' )
do
    #printf "$iface%s\n"
    IPADDR=$(ip -4 -o addr show $iface | awk '{print $4}' | awk -F"/" '{print $1}')
    #echo $IPADDR
    #declare -a array_test=["$iface"]
    if [ -n "${IPADDR}"  -a  "127.0.0.1" != "${IPADDR}" ]; then
        echo "scp $USER@$IPADDR:$OUTDIR/ModelInfo.txt ."
        echo "scp $USER@$IPADDR:$OUTDIR/frozen_inference_graph.pb ."
        echo "scp $USER@$IPADDR:~/$TARFILE ."

	echo ""
    fi

done

echo ""
du -hs $OUTDIR
ls -alh $OUTDIR
echo ""
echo "cp $HOME/CUDA-OpenCV/CUDA102-OpenCV420/pipeline_config/$MODELNAME.config $HOME/TensorFlow/workspace/training_demo/training/pipeline.config"
echo ""
echo "tar xvfj $MODELNAME"_AT_"$CKPT".tar.bz2""

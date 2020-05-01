#!/bin/bash


#
#   RESTART = DEFAUT
#   RESTART WILL CHECK IF PIPELINE CONFIG IS PRESENT
#   CHECK IF tar and folders are present
#
#   NEW DELETES EVERYTHING


set -e  # Exit immediately if a command exits with a non-zero status. (Exit on error)
#set -x  # Print commands and their arguments as they are executed.
set -u  # Treat unset variables as an error when substituting.





#######
# All the ZOO models
# https://github.com/tensorflow/models/blob/master/research/object_detection/g3doc/detection_model_zoo.md
#
# Removed ( ) and / then did a grep to get only the model name
# grep -o '[^ ]*tar\.gz[^ ]*' thefile.txt
#


#####
# Links to tips regarding fixing the configuration files
# 
# ERROR:raise ValueError('First step cannot be zero.') ValueError: First step cannot be zero.
# https://github.com/EdjeElectronics/TensorFlow-Object-Detection-API-Tutorial-Train-Multiple-Objects-Windows-10/issues/51
#




#
# Working
#MODEL=ssd_mobilenet_v1_coco_2018_01_28

# ssd_mobilenet_v1_0.75_depth_300x300_coco14_sync_2018_07_03
# ssd_mobilenet_v1_quantized_300x300_coco14_sync_2018_07_18
# ssd_mobilenet_v1_0.75_depth_quantized_300x300_coco14_sync_2018_07_18
# ssd_mobilenet_v1_ppn_shared_box_predictor_300x300_coco14_sync_2018_07_03
# ssd_mobilenet_v1_fpn_shared_box_predictor_640x640_coco14_sync_2018_07_03
# ssd_resnet50_v1_fpn_shared_box_predictor_640x640_coco14_sync_2018_07_03
# ssd_mobilenet_v2_coco_2018_03_29

#Working
#MODEL=ssd_mobilenet_v2_quantized_300x300_coco_2019_01_03

# ssdlite_mobilenet_v2_coco_2018_05_09

#Working
#MODEL=ssd_inception_v2_coco_2018_01_28

#Working
#MODEL=faster_rcnn_inception_v2_coco_2018_01_28

# faster_rcnn_resnet50_coco_2018_01_28
# faster_rcnn_resnet50_lowproposals_coco_2018_01_28

#Working
MODEL=rfcn_resnet101_coco_2018_01_28

#Working
#MODEL=faster_rcnn_resnet101_coco_2018_01_28


# faster_rcnn_resnet101_lowproposals_coco_2018_01_28
# faster_rcnn_inception_resnet_v2_atrous_coco_2018_01_28
# faster_rcnn_inception_resnet_v2_atrous_lowproposals_coco_2018_01_28
# faster_rcnn_nas_coco_2018_01_28
# faster_rcnn_nas_lowproposals_coco_2018_01_28
# mask_rcnn_inception_resnet_v2_atrous_coco_2018_01_28
# mask_rcnn_inception_v2_coco_2018_01_28
# mask_rcnn_resnet101_atrous_coco_2018_01_28
# mask_rcnn_resnet50_atrous_coco_2018_01_28






#source ~/.bash_profile

#cd ~/TensorFlow/models/research/
#protoc object_detection/protos/*.proto --python_out=.

#cd ~/TensorFlow/workspace/training_demo/
#python3 train.py --logtostderr --train_dir=training/ --pipeline_config_path=training/pipeline.config


cd ~

rm -rf ~/TensorFlow/workspace/training_demo/pre-trained-model/*
rm -rf ~/TensorFlow/workspace/training_demo/training/*

rm -rf ~/$MODEL

if [ ! -f ~/$MODEL.tar.gz ]; then
    echo "File not found download!"
    wget http://download.tensorflow.org/models/object_detection/$MODEL.tar.gz
fi

tar xvzf $MODEL.tar.gz
cd ~/$MODEL
cp -r * ~/TensorFlow/workspace/training_demo/pre-trained-model/


# Let us see if we already have a configuration in our repository
PIPELINE_CONFIG=~/CUDA-OpenCV/CUDA102-OpenCV420/pipeline_config/$MODEL.config
if [ -f $PIPELINE_CONFIG ]; then
   echo "File $PIPELINE_CONFIG exists."
   sleep 3
   cp $PIPELINE_CONFIG ~/TensorFlow/workspace/training_demo/training/pipeline.config
else
   echo "File $PIPELINE_CONFIG does not exist."
   cp pipeline.config ~/TensorFlow/workspace/training_demo/training/pipeline.config
   ~/CUDA-OpenCV/CUDA102-OpenCV420/pipeline_config_massage.sh
   cp ~/TensorFlow/workspace/training_demo/training/pipeline.config $PIPELINE_CONFIG
   sleep 3
fi


# Store the model name so we can make a description when exporting the model later
echo $MODEL > ~/TensorFlow/workspace/training_demo/training/modelName.txt


# Do actual training 
cd ~/TensorFlow/workspace/training_demo/
python3 train.py --logtostderr --train_dir=training/ --pipeline_config_path=training/pipeline.config

echo ""
echo "Now run :"
echo "python3 train.py --logtostderr --train_dir=training/ --pipeline_config_path=training/pipeline.config"
echo "vi ~/CUDA-OpenCV/CUDA102-OpenCV420/pipeline_config/$MODEL.config"
echo "cp ~/CUDA-OpenCV/CUDA102-OpenCV420/pipeline_config/$MODEL.config ~/TensorFlow/workspace/training_demo/training/pipeline.config"



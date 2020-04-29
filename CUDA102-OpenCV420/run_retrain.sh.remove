#!/bin/bash


#
#   RESTART = DEFAUT
#   RESTART WILL CHECK IF PIPELINE CONFIG IS PRESENT
#   CHECK IF tar and folders are present
#
#   NEW DELETES EVERYTHING



# Echo each command.
set -x




#######
# All the ZOO models
# https://github.com/tensorflow/models/blob/master/research/object_detection/g3doc/detection_model_zoo.md
#
# Removed ( ) and / then did a grep to get only the model name
# grep -o '[^ ]*tar\.gz[^ ]*' thefile.txt
#
#
MODEL=ssd_mobilenet_v1_coco_2018_01_28
# ssd_mobilenet_v1_0.75_depth_300x300_coco14_sync_2018_07_03
# ssd_mobilenet_v1_quantized_300x300_coco14_sync_2018_07_18
# ssd_mobilenet_v1_0.75_depth_quantized_300x300_coco14_sync_2018_07_18
# ssd_mobilenet_v1_ppn_shared_box_predictor_300x300_coco14_sync_2018_07_03
# ssd_mobilenet_v1_fpn_shared_box_predictor_640x640_coco14_sync_2018_07_03
# ssd_resnet50_v1_fpn_shared_box_predictor_640x640_coco14_sync_2018_07_03
# ssd_mobilenet_v2_coco_2018_03_29
# ssd_mobilenet_v2_quantized_300x300_coco_2019_01_03
# ssdlite_mobilenet_v2_coco_2018_05_09
# ssd_inception_v2_coco_2018_01_28
# faster_rcnn_inception_v2_coco_2018_01_28
# faster_rcnn_resnet50_coco_2018_01_28
# faster_rcnn_resnet50_lowproposals_coco_2018_01_28
# rfcn_resnet101_coco_2018_01_28
# faster_rcnn_resnet101_coco_2018_01_28
# faster_rcnn_resnet101_lowproposals_coco_2018_01_28
# faster_rcnn_inception_resnet_v2_atrous_coco_2018_01_28
# faster_rcnn_inception_resnet_v2_atrous_lowproposals_coco_2018_01_28
# faster_rcnn_nas_coco_2018_01_28
# faster_rcnn_nas_lowproposals_coco_2018_01_28
# mask_rcnn_inception_resnet_v2_atrous_coco_2018_01_28
# mask_rcnn_inception_v2_coco_2018_01_28
# mask_rcnn_resnet101_atrous_coco_2018_01_28
# mask_rcnn_resnet50_atrous_coco_2018_01_28






source ~/.bash_profile

cd ~/TensorFlow/models/research/
protoc object_detection/protos/*.proto --python_out=.

cd ~/TensorFlow/workspace/training_demo/
python3 train.py --logtostderr --train_dir=training/ --pipeline_config_path=training/pipeline.config


cd ~

########################rm -rf ~/TensorFlow/workspace/training_demo/pre-trained-model/*
#########################rm ~/TensorFlow/workspace/training_demo/pre-trained-model/pipeline.config
#############################rm -rf ~/TensorFlow/workspace/training_demo/training/*

################ wget http://download.tensorflow.org/models/object_detection/$MODEL.tar.gz
###############tar xvzf $MODEL.tar.gz
cd ~/$MODEL



################### cp -r * ~/TensorFlow/workspace/training_demo/pre-trained-model/
cp pipeline.config ~/TensorFlow/workspace/training_demo/training/pipeline.config


cd ~/TensorFlow/workspace/training_demo/training

~/CUDA-OpenCV/CUDA102-OpenCV420/pipeline_config_massage.sh

cd ~/TensorFlow/workspace/training_demo/
python3 train.py --logtostderr --train_dir=training/ --pipeline_config_path=training/pipeline.config

exit

#
#
#
#
#
#
#
#
#
#


rm -rf ~/TensorFlow/workspace/training_demo/pre-trained-model/*

#rm ~/ssd_mobilenet_v2_quantized_300x300_coco_2019_01_03.tar.gz
#rm -rf ~/ssd_mobilenet_v2_quantized_300x300_coco_2019_01_03

#rm ~/xvzf ssd_mobilenet_v1_quantized_300x300_coco14_sync_2018_07_18.tar.gz
#rm -rf ~/ssd_mobilenet_v1_quantized_300x300_coco14_sync_2018_07_18

cd ~
#wget http://download.tensorflow.org/models/object_detection/ssd_mobilenet_v1_quantized_300x300_coco14_sync_2018_07_18.tar.gz
#tar xvzf ssd_mobilenet_v1_quantized_300x300_coco14_sync_2018_07_18.tar.gz
cd ~/ssd_mobilenet_v1_quantized_300x300_coco14_sync_2018_07_18
cp -r * ~/TensorFlow/workspace/training_demo/pre-trained-model/

#cp ~/CUDA-OpenCV/CUDA102-OpenCV420/ssd_mobilenet_v1_quantized_pipeline.config ~/TensorFlow/workspace/training_demo/training/pipeline.config

exit


#cd ~
#wget http://download.tensorflow.org/models/object_detection/ssd_mobilenet_v2_quantized_300x300_coco_2019_01_03.tar.gz
#tar xvzf ssd_mobilenet_v2_quantized_300x300_coco_2019_01_03.tar.gz
#cd ~/ssd_mobilenet_v2_quantized_300x300_coco_2019_01_03
#cp -r * ~/TensorFlow/workspace/training_demo/pre-trained-model/


#cp ~/CUDA-OpenCV/CUDA102-OpenCV420/ssd_mobilenet_v2_quantized_pipeline.config ~/TensorFlow/workspace/training_demo/training/pipeline.config



source ~/.bash_profile 
#cp ~/CUDA-OpenCV/CUDA102-OpenCV420/ssd_mobilenet_v2_quantized_pipeline.config ~/TensorFlow/workspace/training_demo/training/pipeline.config

cd ~/TensorFlow/models/research/
protoc object_detection/protos/*.proto --python_out=.


cd ~/TensorFlow/workspace/training_demo/
python3 train.py --logtostderr --train_dir=training/ --pipeline_config_path=training/pipeline.config


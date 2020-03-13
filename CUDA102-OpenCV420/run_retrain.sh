#!/bin/bash

# Echo each command.
set -x


#MODEL=ssd_miobilenet_v2_quantized_300x300_coco_2019_01_03
#MODEL=ssd_mobilenet_v1_0.75_depth_300x300_coco14_sync_2018_07_03
#MODEL=ssd_mobilenet_v1_ppn_shared_box_predictor_300x300_coco14_sync_2018_07_03

#MODEL=faster_rcnn_inception_v2_coco_2018_01_28

# Working 100ms / step
MODEL=ssd_mobilenet_v1_coco_2018_01_28




source ~/.bash_profile

cd ~/TensorFlow/models/research/
protoc object_detection/protos/*.proto --python_out=.

cd ~/TensorFlow/workspace/training_demo/
python3 train.py --logtostderr --train_dir=training/ --pipeline_config_path=training/pipeline.config


cd ~

rm -rf ~/TensorFlow/workspace/training_demo/pre-trained-model/*
rm ~/TensorFlow/workspace/training_demo/pre-trained-model/pipeline.config
rm -rf ~/TensorFlow/workspace/training_demo/training/*

wget http://download.tensorflow.org/models/object_detection/$MODEL.tar.gz
tar xvzf $MODEL.tar.gz
cd ~/$MODEL



cp -r * ~/TensorFlow/workspace/training_demo/pre-trained-model/
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


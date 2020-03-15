#!/bin/bash


# Exit script on error.
set -e
# Echo each command.
set -x

# Generate the pipeline.config files

MODEL=ssd_mobilenet_v1_coco_2018_01_28


cd ~
wget http://download.tensorflow.org/models/object_detection/$MODEL.tar.gz
tar xvzf $MODEL.tar.gz
cd ~/$MODEL

mkdir newconfig


cp pipeline.config newconfig/

cd newconfig

~/CUDA-OpenCV/CUDA102-OpenCV420/pipeline_config_massage.sh

cd ..


export DISPLAY=:0
kdiff3 pipeline.config newconfig/pipeline.config


#!/bin/bash



# Download and unzip the Balloon files outside the container (Convinient if you mess things up)
#
# wget https://github.com/matterport/Mask_RCNN/releases/download/v2.1/balloon_dataset.zip
# unzip balloon_dataset.zip 
# 
# wget https://github.com/matterport/Mask_RCNN/releases/download/v2.1/mask_rcnn_balloon.h5
#

# docker pull nvidia/cuda:10.0-cudnn7-devel-ubuntu18.04

# From https://www.tensorflow.org/install/source#gpu
# Version			Python version	Compiler	Build tools	cuDNN	CUDA
# -------------------------------------------------------------------------------------------
# tensorflow_gpu-1.15.0		2.7, 3.3-3.7	GCC 7.3.1	Bazel 0.26.1	7.4	10.0

	
# sudo docker run --runtime=nvidia --shm-size=1g --ulimit memlock=-1 --ulimit stack=67108864 --env CUDA_VISIBLE_DEVICES='1' -it -p 8888:8888 -p 6006:6006 -v ~/:/host nvidia/cuda:10.0-cudnn7-devel-ubuntu18.04




apt update
apt install -y python3 python3-pip git vim
apt install -y libgl1-mesa-glx
pip3 install --upgrade pip
git clone https://github.com/matterport/Mask_RCNN
cd Mask_RCNN

rm requirements.txt
wget --output-document=requirements.txt https://raw.githubusercontent.com/jarleven/CUDA-OpenCV/master/CUDA-Docker/requirements-1.15.txt

	
pip3 install -r requirements.txt
python3 setup.py install

cp /host/mask_rcnn_balloon.h5 .


cd samples/balloon/
echo "To run the training do :"
echo "python3 balloon.py train --dataset=/host/balloon --weights=coco"
echo ""


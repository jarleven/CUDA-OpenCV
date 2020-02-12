#!/bin/bash

# Before you start
sudo apt install -y vim ssh git

# Download OpenCV

cd ~
wget -O opencv.zip https://github.com/opencv/opencv/archive/4.2.0.zip
wget -O opencv_contrib.zip https://github.com/opencv/opencv_contrib/archive/4.2.0.zip
wget -O opencv_extra.zip https://github.com/opencv/opencv_extra/archive/4.2.0.zip

# Download CUDA

wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/cuda-ubuntu1804.pin
wget http://developer.download.nvidia.com/compute/cuda/10.2/Prod/local_installers/cuda-repo-ubuntu1804-10-2-local-10.2.89-440.33.01_1.0-1_amd64.deb

# Unpack OpenCV

unzip opencv.zip
unzip opencv_contrib.zip
unzip opencv_extra.zip

mv opencv-4.2.0 opencv
mv opencv_contrib-4.2.0 opencv_contrib
mv opencv_extra-4.2.0 opencv_extra


mkdir ~/opencv/build

cd ~/opencv/build


# https://developer.nvidia.com/cuda-downloads?target_os=Linux&target_arch=x86_64&target_distro=Ubuntu&target_version=1804&target_type=deblocal
# From CUDA 10.2 Installation Instructions:

sudo mv cuda-ubuntu1804.pin /etc/apt/preferences.d/cuda-repository-pin-600
sudo dpkg -i cuda-repo-ubuntu1804-10-2-local-10.2.89-440.33.01_1.0-1_amd64.deb
sudo apt-key add /var/cuda-repo-10-2-local-10.2.89-440.33.01/7fa2af80.pub
sudo apt-get update
sudo apt-get -y install cuda


# A few commands to test
# nvidia-smi


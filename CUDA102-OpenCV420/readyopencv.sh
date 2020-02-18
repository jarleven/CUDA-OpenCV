#!/bin/bash

# https://unix.stackexchange.com/questions/389156/how-to-fix-held-broken-packages
# sudo dpkg --configure -a

# sudo apt-get install -f

# sudo apt-get clean && sudo apt-get update

# sudo apt-get upgrade -y

cd /media/jarleven/CUDA/

pwd

cp Video_Codec_SDK_9.1.23.zip ~/
cp cudnn-10.0-linux-x64-v7.6.5.32.tgz ~/
cp cudnn-10.2-linux-x64-v7.6.5.32.tgz ~/

cd ~

cd ~&& sudo apt install -y git && git clone https://github.com/jarleven/CUDA-OpenCV.git && cd CUDA-OpenCV/CUDA102-OpenCV420/ && ./setup

git config --global user.email "jarleven@gmail.com"
git config --global user.name "Jarl Even Englund"

cd ~
git clone https://github.com/jarleven/CUDA-OpenCV.git
cd CUDA-OpenCV/CUDA102-OpenCV420/
./setup.sh





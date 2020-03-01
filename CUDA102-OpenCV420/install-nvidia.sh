#!/bin/bash

# Following this guide
# https://devtalk.nvidia.com/default/topic/1069698/cuda-setup-and-installation/installing-cuda-toolkit-10-0-on-ubuntu-18-results-in-black-boot-screen/
# sudo apt install -y nvidia-driver-430
# When installing CUDA do "sudo apt-get install -y cuda-toolkit-10-0" not just "sudo apt-get install -y cuda"

source .setupvars

cd ~

#echo "What drivers are available ?  Just for information."
#ubuntu-drivers devices
#sleep 30

echo "Adding PPA and installing nvidia-driver-$SCRIPT_NVIDIAVER"

sudo add-apt-repository -y ppa:graphics-drivers/ppa
sudo apt update
sudo apt install -y nvidia-driver-$SCRIPT_NVIDIAVER


sudo apt-mark nvidia-driver-$SCRIPT_NVIDIAVER
# To reverse this operation run:
# sudo apt-mark unhold package_name


sudo apt update
sudo apt upgrade -y
 

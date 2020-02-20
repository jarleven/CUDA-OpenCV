#!/bin/bash

# Following this guide
# https://devtalk.nvidia.com/default/topic/1069698/cuda-setup-and-installation/installing-cuda-toolkit-10-0-on-ubuntu-18-results-in-black-boot-screen/
# sudo apt install -y nvidia-driver-430


echo "What drivers are available ?  Just for information."
sleep 10
ubuntu-drivers devices
sleep 30

sudo add-apt-repository ppa:graphics-drivers/ppa
sudo apt install -y nvidia-driver-$SCRIPT_NVIDIAVER

sudo apt-get update
sudo reboot



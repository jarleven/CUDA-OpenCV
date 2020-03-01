#!/bin/bash

# Following this guide
# https://devtalk.nvidia.com/default/topic/1069698/cuda-setup-and-installation/installing-cuda-toolkit-10-0-on-ubuntu-18-results-in-black-boot-screen/
# sudo apt install -y nvidia-driver-430
# When installing CUDA do "sudo apt-get install -y cuda-toolkit-10-0" not just "sudo apt-get install -y cuda"


source .setupvars

cd ~

echo "What drivers are available ?  Just for information."
ubuntu-drivers devices
sleep 5

echo "Adding PPA and installing nvidia-driver-$SCRIPT_NVIDIAVER"

sudo add-apt-repository -y ppa:graphics-drivers/ppa
sudo apt update
sudo apt install -y nvidia-driver-$SCRIPT_NVIDIAVER


sudo apt-mark nvidia-driver-$SCRIPT_NVIDIAVER
# To reverse this operation run:
# sudo apt-mark unhold package_name


sudo apt update
sudo apt upgrade -y
 

# I REALLY DOUBT THE VERSION IS CONSIDERED WHEN INSTALLING !!!
# WHEN INSTALLING version 418 !

#
# +-----------------------------------------------------------------------------+
# | NVIDIA-SMI 440.59       Driver Version: 440.59       CUDA Version: 10.2     |
# |-------------------------------+----------------------+----------------------+
# | GPU  Name        Persistence-M| Bus-Id        Disp.A | Volatile Uncorr. ECC |
# | Fan  Temp  Perf  Pwr:Usage/Cap|         Memory-Usage | GPU-Util  Compute M. |
# |===============================+======================+======================|
# |   0  GeForce GTX 106...  Off  | 00000000:01:00.0  On |                  N/A |
# |  0%   34C    P8     5W / 120W |    186MiB /  3018MiB |      0%      Default |
# +-------------------------------+----------------------+----------------------+
#
# +-----------------------------------------------------------------------------+
# | Processes:                                                       GPU Memory |
# |  GPU       PID   Type   Process name                             Usage      |
# |=============================================================================|
# |    0      1080      G   /usr/lib/xorg/Xorg                           113MiB |
# |    0      1281      G   /usr/bin/gnome-shell                          69MiB |
# +-----------------------------------------------------------------------------+

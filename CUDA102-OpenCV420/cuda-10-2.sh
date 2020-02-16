#!/bin/bash

# CUDA 10.2
# sudo apt --purge remove -y "*cublas*" "cuda*"

sudo apt update
sudo apt upgrade -y

cp cuda-10-2.md5 ~/
cd ~

if md5sum -c cuda-10-2.md5; then
    echo "CUDA 10.2 already downloaded"
else
    echo "Get the CUDA 10.2 files from NVIDIA"

    wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/cuda-ubuntu1804.pin
    wget http://developer.download.nvidia.com/compute/cuda/10.2/Prod/local_installers/cuda-repo-ubuntu1804-10-2-local-10.2.89-440.33.01_1.0-1_amd64.deb
fi

sudo cp cuda-ubuntu1804.pin /etc/apt/preferences.d/cuda-repository-pin-600
sudo dpkg -i cuda-repo-ubuntu1804-10-2-local-10.2.89-440.33.01_1.0-1_amd64.deb
sudo apt-key add /var/cuda-repo-10-2-local-10.2.89-440.33.01/7fa2af80.pub
sudo apt update
sudo apt -y install cuda

sudo apt update
sudo apt upgrade -y


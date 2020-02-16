#!/bin/bash



# CUDA 10.0
# sudo apt --purge remove -y "*cublas*" "cuda*"

sudo apt update
sudo apt upgrade -y

cp cuda-10-0.md5 ~/
cd ~

if md5sum -c cuda-10-0.md5; then
    echo "CUDA 10.0 already downloaded"
else
    echo "Get the CUDA 10.0 files from NVIDIA"

    wget https://developer.nvidia.com/compute/cuda/10.0/Prod/local_installers/cuda-repo-ubuntu1804-10-0-local-10.0.130-410.48_1.0-1_amd64
    wget http://developer.download.nvidia.com/compute/cuda/10.0/Prod/patches/1/cuda-repo-ubuntu1804-10-0-local-nvjpeg-update-1_1.0-1_amd64.deb
    mv cuda-repo-ubuntu1804-10-0-local-10.0.130-410.48_1.0-1_amd64 cuda-repo-ubuntu1804-10-0-local-10.0.130-410.48_1.0-1_amd64.deb

fi

sudo dpkg -i cuda-repo-ubuntu1804-10-0-local-10.0.130-410.48_1.0-1_amd64.deb
sudo apt-key add /var/cuda-repo-10-0-local-10.0.130-410.48/7fa2af80.pub
sudo apt-get update

sudo apt-get install -y cuda-10-0
sudo dpkg -i cuda-repo-ubuntu1804-10-0-local-nvjpeg-update-1_1.0-1_amd64.deb

sudo apt update
sudo apt upgrade -y


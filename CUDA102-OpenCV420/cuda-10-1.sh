#!/bin/bash

# CUDA 10.1

# ubuntu-drivers devices

sudo apt update
sudo apt upgrade -y

cd ~

if md5sum -c cuda-10-1.md5; then
    echo "CUDA 10.1 already downloaded"
else
    echo "Get the CUDA 10.1 files from NVIDIA"

    #wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/cuda-ubuntu1804.pin
    #wget http://developer.download.nvidia.com/compute/cuda/10.2/Prod/local_installers/cuda-repo-ubuntu1804-10-2-local-10.2.89-440.33.01_1.0-1_amd64.deb
fi



#sudo cp cuda-ubuntu1804.pin /etc/apt/preferences.d/cuda-repository-pin-600
#sudo dpkg -i cuda-repo-ubuntu1804-10-2-local-10.2.89-440.33.01_1.0-1_amd64.deb
#sudo apt-key add /var/cuda-repo-10-2-local-10.2.89-440.33.01/7fa2af80.pub
#sudo apt update
#sudo apt -y install cuda


#### In case you run the script multiple times remove the stuff potentially added in bashrc ....
sed -i '/#Add CUDA environment/d' ~/.bashrc
sed -i '/\/usr\/local\/cuda/d' ~/.bashrc

echo '#Add CUDA environment' >> ~/.bashrc 
echo 'LD_LIBRARY_PATH=/usr/local/cuda-10.1/lib${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}' >> ~/.bashrc
echo 'PATH=/usr/local/cuda-10.1/bin${PATH:+:${PATH}}' >> ~/.bashrc




sudo dpkg -i cuda-repo-ubuntu1804-10-0-local-10.0.130-410.48_1.0-1_amd64.deb
sudo apt-key add /var/cuda-repo-10.0/7fa2af80.pub
sudo apt-get update
# sudo apt-get install cuda
sudo apt-get install cuda-toolkit-10-0


export PATH=/usr/local/cuda-10.0/bin${PATH:+:${PATH}}
export LD_LIBRARY_PATH=/usr/local/cuda-10.0/lib64${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}





sudo apt update
sudo apt upgrade -y


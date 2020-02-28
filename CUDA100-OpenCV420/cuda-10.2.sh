#!/bin/bash

# CUDA 10.2

sudo apt update
sudo apt upgrade -y

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

# This is the essence, just install the toolkit. If you install cuda-10-2 then the NVIDIA driver in the package will be installed!
sudo apt-get install -y cuda-toolkit-10-2


#### In case you run the script multiple times remove the stuff potentially added in bashrc ....
sed -i '/# Added by CUDA setupscript/d' ~/.bashrc
sed -i '/\/usr\/local\/cuda/d' ~/.bashrc

echo '# Added by CUDA setupscript' >> ~/.bashrc 
echo 'LD_LIBRARY_PATH=/usr/local/cuda-10.2/lib${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}' >> ~/.bashrc
echo 'PATH=/usr/local/cuda-10.2/bin${PATH:+:${PATH}}' >> ~/.bashrc

#echo 'LD_LIBRARY_PATH=/usr/local/cuda-10.2/extras/CUPTI/lib64${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}' >> ~/.bashrc


sudo apt update
sudo apt upgrade -y


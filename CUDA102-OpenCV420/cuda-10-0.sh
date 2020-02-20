#!/bin/bash

# CUDA 10.0

sudo apt update
sudo apt upgrade -y

cd ~

if md5sum -c cuda-10-0.md5; then
    echo "CUDA 10.0 already downloaded"
else
    echo "Get the CUDA 10.0 files from NVIDIA"
    wget -O cuda-repo-ubuntu1804-10-0-local-10.0.130-410.48_1.0-1_amd64.deb https://developer.nvidia.com/compute/cuda/10.0/Prod/local_installers/cuda-repo-ubuntu1804-10-0-local-10.0.130-410.48_1.0-1_amd64
    wget http://developer.download.nvidia.com/compute/cuda/10.0/Prod/patches/1/cuda-repo-ubuntu1804-10-0-local-nvjpeg-update-1_1.0-1_amd64.deb
fi

sudo dpkg -i cuda-repo-ubuntu1804-10-0-local-10.0.130-410.48_1.0-1_amd64.deb
sudo apt-key add /var/cuda-repo-10-0-local-10.0.130-410.48/7fa2af80.pub
sudo apt-get update

# This is the essence, just install the toolkit. If you install cuda-10-0 then the NVIDIA driver in the package will be installed!
sudo apt-get install -y cuda-toolkit-10-0

sudo dpkg -i cuda-repo-ubuntu1804-10-0-local-nvjpeg-update-1_1.0-1_amd64.deb
sudo apt update


#### In case you run the script multiple times remove the stuff potentially added in bashrc ....
sed -i '/# Added by CUDA setupscript/d' ~/.bashrc
sed -i '/\/usr\/local\/cuda/d' ~/.bashrc

echo '# Added by CUDA setupscript' >> ~/.bashrc 
echo 'LD_LIBRARY_PATH=/usr/local/cuda-10.0/lib${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}' >> ~/.bashrc
echo 'PATH=/usr/local/cuda-10.0/bin${PATH:+:${PATH}}' >> ~/.bashrc

#echo 'LD_LIBRARY_PATH=/usr/local/cuda-10.0/extras/CUPTI/lib64${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}' >> ~/.bashrc


sudo apt update
sudo apt upgrade -y


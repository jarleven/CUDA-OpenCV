New year, new relaeses and new possibilities

Trying CUDA 10.0 and OpenCV 4.2.0 on Ubuntu 18.04
```
Ubuntu 18.04.4
OpenCV 4.2.0
CUDA 10.0
Python 3
cuDNN - cuDNN v7.6.5 (November 18th, 2019), for CUDA 10.2
Tensorflow 2.0.0
```


```
Install Ubuntu 18.04  (Set login without password)

Copy cuDNN and a few other files requiering NVIDIA login to ~/
Then do the following. After setup is executed the script will reboot your machine a few times

Assuming the NVIDIA files are already on a USB thumbdrive named CUDA

cd ~&& sudo apt install -y git && git clone https://github.com/jarleven/CUDA-OpenCV.git && cd CUDA-OpenCV/CUDA102-OpenCV420/ && ./setup



cd /media/jarleven/NYTT\ VOLUM/
cp * ~/

sudo apt install -y vim ssh git screen

#!/bin/bash

sudo apt install -y git
cd ~
git clone https://github.com/jarleven/CUDA-OpenCV.git
cd CUDA-OpenCV/CUDA102-OpenCV420/
./setup.sh


prepare
OPencv
cuDNN
ffmpeg

```
# sudo apt --purge remove -y "*cublas*" "cuda*"



#export PATH=/usr/local/cuda-10.2/bin${PATH:+:${PATH}}
#export LD_LIBRARY_PATH=/usr/local/cuda-10.2/lib${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}

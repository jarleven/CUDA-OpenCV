#!/bin/sh

FILE=./cuda-repo-ubuntu1604-8-0-local-ga2_8.0.61-1_amd64.deb
if [ -f $FILE ]; then
   echo "File $FILE exists."
else
   echo "File $FILE does not exist. Downloading"
   wget -O ./cuda-repo-ubuntu1604-8-0-local-ga2_8.0.61-1_amd64.deb https://developer.nvidia.com/compute/cuda/8.0/Prod2/local_installers/cuda-repo-ubuntu1604-8-0-local-ga2_8.0.61-1_amd64-deb
fi

FILE=./cuda-repo-ubuntu1604-8-0-local-cublas-performance-update_8.0.61-1_amd64.deb
if [ -f $FILE ]; then
   echo "File $FILE exists."
else
   echo "File $FILE does not exist. Downloading"
   wget -O ./cuda-repo-ubuntu1604-8-0-local-cublas-performance-update_8.0.61-1_amd64.deb https://developer.nvidia.com/compute/cuda/8.0/Prod2/patches/2/cuda-repo-ubuntu1604-8-0-local-cublas-performance-update_8.0.61-1
fi

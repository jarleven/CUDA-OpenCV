#!/bin/bash

cp -r /usr/local/cuda-10.1/samples /home/jarleven/cuda-samples
cd /home/jarleven/cuda-samples/1_Utilities/deviceQuery
make clean
make

#/home/jarleven/cuda-samples/bin/x86_64/linux/release/deviceQuery

COMPUTE_CAPABILITY=$(/home/jarleven/cuda-samples/bin/x86_64/linux/release/deviceQuery | grep "CUDA Capability Major/Minor version number" | awk -F ':' '{print $2}' | sed 's/ //g')


sed -i '/SCRIPT_CUDA_ARCH_BIN/d' /home/jarleven/CUDA-OpenCV/CUDA102-OpenCV420/.setupvars
sed -i '/SCRIPT_CUDA_ARCH_PTX/d' /home/jarleven/CUDA-OpenCV/CUDA102-OpenCV420/.setupvars


echo SCRIPT_CUDA_ARCH_BIN='"'$COMPUTE_CAPABILITY'"' >> /home/jarleven/CUDA-OpenCV/CUDA102-OpenCV420/.setupvars
echo SCRIPT_CUDA_ARCH_PTX='"'$COMPUTE_CAPABILITY'"' >> /home/jarleven/CUDA-OpenCV/CUDA102-OpenCV420/.setupvars


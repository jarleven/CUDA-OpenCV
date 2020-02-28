#!/bin/bash

echo -e "\n\n\n   ---------------------   Ubuntu version     ---------------------   "
cat /etc/issue

echo -e "\n\n\n    ---------------------   Python version     ---------------------   "
python --version

echo -e "\n\n\n    ---------------------   Python 3 version   ---------------------   "
python3 --version

echo -e "\n\n\n    ---------------------   pip version        ---------------------   "
pip --version

echo -e "\n\n\n    ---------------------   nvcc version       ---------------------   "
nvcc -V

echo -e "\n\n\n    ---------------------   NVIDIA driver      ---------------------   "
nvidia-smi 

echo -e "\n\n\n    ---------------------   FFMPEG version     ---------------------   "
ffmpeg -version

echo -e "\n\n\n    ---------------------   Tensorflow         ---------------------   "
python3 -c "import tensorflow as tf;print(tf.reduce_sum(tf.random.normal([1000, 1000])))"

echo -e "\n\n\n    ---------------------   cuDNN              ---------------------   "
cd  $HOME/cudnn_samples_v7/mnistCUDNN
./mnistCUDNN
sleep 10

echo -e "\n\n\n    ---------------------   GPU bgfg           ---------------------   "

cd ~/opencv/build/bin/
./example_gpu_bgfg_segm


# https://stackoverflow.com/questions/52337791/verify-that-cublas-is-installed
# You could copy an example of C code that uses cuBLAS from https://docs.nvidia.com/cuda/cublas/index.html and then try to compile it: nvcc cublas_test.c -o cublas_test.out -lcublas and then run it: ./cublas_test.out.


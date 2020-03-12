#!/bin/bash

echo -e "\n#####\n#\n#  Versions found \n#" >> dump_versions.txt

echo -e "\n#####\n#\n#  Tensorflow \n#" >> dump_versions.txt
python3 -c 'import tensorflow as tf; print("Tensorflow version : %s" % tf.__version__)' >> dump_versions.txt

echo -e "\n#####\n#\n#  NVIDIA CUDA \n#" >> dump_versions.txt
cat /usr/local/cuda/version.txt  >> dump_versions.txt

echo -e "\n#####\n#\n#\n#  NVIDIA cuDNN\n#" >> dump_versions.txt
cat /usr/include/cudnn.h | grep "define CUDNN_MAJOR" -A 2 >> dump_versions.txt

echo -e "\n#####\n#\n#  NVIDIA TensorRT \n#" >> dump_versions.txt
dpkg -l | grep nvinfer >> dump_versions.txt

echo -e "\n#####\n#\n#  Ubuntu release \n#" >> dump_versions.txt
cat /etc/issue >> dump_versions.txt

echo -e "\n#####\n#\n#  Python versions \n#" >> dump_versions.txt
python --version >> dump_versions.txt
python3 --version >> dump_versions.txt
pip --version >> dump_versions.txt
pip3 --version >> dump_versions.txt

echo -e "\n#####\n#\n#  NVCC version \n#" >> dump_versions.txt
nvcc -V >> dump_versions.txt

echo -e "\n#####\n#\n#  NVIDIA driver \n#" >> dump_versions.txt
nvidia-smi >> dump_versions.txt


echo -e "\n#####\n#\n#  FFMPEG version \n#" >> dump_versions.txt
ffmpeg -version >> dump_versions.txt




cat dump_versions.txt

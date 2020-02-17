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

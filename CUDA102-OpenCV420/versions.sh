#!/bin/bash

echo "   ---------------------   Ubuntu version     ---------------------   "
cat /etc/issue

echo "   ---------------------   Python version     ---------------------   "
python --version

echo "   ---------------------   Python 3 version   ---------------------   "
python3 --version

echo "   ---------------------   pip version        ---------------------   "
pip --version

echo "   ---------------------   nvcc version       ---------------------   "
nvcc -V

echo "   ---------------------   NVIDIA driver      ---------------------   "
nvidia-smi 

echo "   ---------------------   FFMPEG version     ---------------------   "
ffmpeg -version

echo "   ---------------------   Tensorflow         ---------------------   "
python -c "import tensorflow as tf;print(tf.reduce_sum(tf.random.normal([1000, 1000])))"

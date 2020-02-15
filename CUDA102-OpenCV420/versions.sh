#!/bin/bash

cat /etc/issue
python --version
python3 --version
pip --version

nvcc -V

nvidia-smi 
python -c "import tensorflow as tf;print(tf.reduce_sum(tf.random.normal([1000, 1000])))"

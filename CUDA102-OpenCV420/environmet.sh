#!/bin/bash

# Export the environment variables needed for CUDA OpenCV Tensorflow and so on
# It will only run once 


#if !OPENCV_ENV_EXPORTED == TRUE

#export OPENCV_ENV_EXPORTED

#CUDAVERSION

#
# export TEST="${TEST:+${TEST}:}/A/B/C"
#

export PATH="${PATH:+${PATH}:}/usr/local/cuda-10.2/bin"

export CUDA_ROOT="${CUDA_ROOT:+${CUDA_ROOT}:}/usr/local/cuda-10.2"
export CUDA_HOME="${CUDA_HOME:+${CUDA_HOME}:}/usr/local/cuda-10.2"

export PATH="${PATH:+${PATH}:}/usr/local/cuda-10.2/bin"


export LD_LIBRARY_PATH="${LD_LIBRARY_PATH:+${LD_LIBRARY_PATH}:}/usr/local/cuda-10.2/lib64"
export LD_LIBRARY_PATH="${LD_LIBRARY_PATH:+${LD_LIBRARY_PATH}:}/usr/local/cuda/extras/CUPTI/lib64"



export PYTHONPATH="${PYTHONPATH:+${PYTHONPATH}:}$HOME/TensorFlow/models/research/object_detection"
export PYTHONPATH="${PYTHONPATH:+${PYTHONPATH}:}$HOME/TensorFlow/models/research"
export PYTHONPATH="${PYTHONPATH:+${PYTHONPATH}:}$HOME/TensorFlow/models/research/slim"



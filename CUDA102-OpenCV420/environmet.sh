#!/bin/bash

# Export the environment variables needed for CUDA OpenCV Tensorflow and so on
# It will only run once 

CUDAVERSION="cuda-10.1"

if test ${OPENCV_ENV_EXPORTED+defined};
then
	echo "Variable OPENCV_ENV_EXPORTED exists!"
	echo "To clear the variable:"
	echo "unset OPENCV_ENV_EXPORTED"
else
	echo "Environment not created, setting up now!"
	export OPENCV_ENV_EXPORTED="TRUE"

	#
	# export TEST="${TEST:+${TEST}:}/A/B/C"
	#

	export PATH="${PATH:+${PATH}:}/usr/local/$CUDAVERSION/bin"
        export PATH="${PATH:+${PATH}:}$HOME/.local/bin"
	export PATH="${PATH:+${PATH}:}/home/linuxbrew/.linuxbrew/bin"

	export CUDA_ROOT="${CUDA_ROOT:+${CUDA_ROOT}:}/usr/local/$CUDAVERSION"
	export CUDA_HOME="${CUDA_HOME:+${CUDA_HOME}:}/usr/local/$CUDAVERSION"

	export PATH="${PATH:+${PATH}:}/usr/local/$CUDAVERSION/bin"


        export LD_LIBRARY_PATH="${LD_LIBRARY_PATH:+${LD_LIBRARY_PATH}:}/usr/local/$CUDAVERSION/lib64"
	export LD_LIBRARY_PATH="${LD_LIBRARY_PATH:+${LD_LIBRARY_PATH}:}/usr/local/$CUDAVERSION/lib"
	export LD_LIBRARY_PATH="${LD_LIBRARY_PATH:+${LD_LIBRARY_PATH}:}/usr/local/cuda/extras/CUPTI/lib64"

	# FFMPEG
	export LD_LIBRARY_PATH="${LD_LIBRARY_PATH:+${LD_LIBRARY_PATH}:}/usr/local/lib/"



	export PYTHONPATH="${PYTHONPATH:+${PYTHONPATH}:}$HOME/TensorFlow/models/research/object_detection"
	export PYTHONPATH="${PYTHONPATH:+${PYTHONPATH}:}$HOME/TensorFlow/models/research"
	export PYTHONPATH="${PYTHONPATH:+${PYTHONPATH}:}$HOME/TensorFlow/models/research/slim"


	export MANPATH="${MANPATH:+${MANPATH}:}/home/linuxbrew/.linuxbrew/share/man"
	export INFOPATH="${INFOPATH:+${INFOPATH}:}/home/linuxbrew/.linuxbrew/share/info"

fi


#MANPATH
#INFOPATH

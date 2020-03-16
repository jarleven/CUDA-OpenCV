#!/bin/bash

# Export the environment variables needed for CUDA OpenCV Tensorflow and so on
# It will only run once 

#CUDAVERSION



#export LD_LIBRARY_PATH=/usr/local/cuda-10.0/lib${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}
#export PATH=/usr/local/cuda-10.0/bin${PATH:+:${PATH}}
#export LD_LIBRARY_PATH=/usr/local/cuda-10.0/extras/CUPTI/lib64${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}


#echo 'export PYTHONPATH="${PYTHONPATH:+${PYTHONPATH}:}$HOME/TensorFlow/models/research/object_detection:$HOME/TensorFlow/models/research:$HOME/TensorFlow/models/research/slim"' >> ~/.bash_profile

# 
# "export PYTHONPATH=$PYTHONPATH:`pwd`:`pwd`/slim"     is done above
# Print-working-directory pwd should be done from within the TensorFlow/models/research/ folder according the guides.

#echo 'export PATH="${PATH:+${PATH}:}/home/linuxbrew/.linuxbrew/bin"' >> ~/.bash_profile

#echo 'export MANPATH="${MANPATH:+${MANPATH}:}/home/linuxbrew/.linuxbrew/share/man"' >> ~/.bash_profile

#echo 'export INFOPATH="${INFOPATH:+${INFOPATH}:}/home/linuxbrew/.linuxbrew/share/info"' >> ~/.bash_profile




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

	export PATH="${PATH:+${PATH}:}/usr/local/cuda-10.2/bin"
        export PATH="${PATH:+${PATH}:}$HOME/.local/bin"


	export CUDA_ROOT="${CUDA_ROOT:+${CUDA_ROOT}:}/usr/local/cuda-10.2"
	export CUDA_HOME="${CUDA_HOME:+${CUDA_HOME}:}/usr/local/cuda-10.2"

	export PATH="${PATH:+${PATH}:}/usr/local/cuda-10.2/bin"


        export LD_LIBRARY_PATH="${LD_LIBRARY_PATH:+${LD_LIBRARY_PATH}:}/usr/local/cuda-10.2/lib64"
	export LD_LIBRARY_PATH="${LD_LIBRARY_PATH:+${LD_LIBRARY_PATH}:}/usr/local/cuda-10.2/lib"
	export LD_LIBRARY_PATH="${LD_LIBRARY_PATH:+${LD_LIBRARY_PATH}:}/usr/local/cuda/extras/CUPTI/lib64"



	export PYTHONPATH="${PYTHONPATH:+${PYTHONPATH}:}$HOME/TensorFlow/models/research/object_detection"
	export PYTHONPATH="${PYTHONPATH:+${PYTHONPATH}:}$HOME/TensorFlow/models/research"
	export PYTHONPATH="${PYTHONPATH:+${PYTHONPATH}:}$HOME/TensorFlow/models/research/slim"

fi


#MANPATH
#INFOPATH

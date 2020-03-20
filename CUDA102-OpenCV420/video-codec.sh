#!/bin/bash

set -e  # Exit immediately if a command exits with a non-zero status. Exit on error
set -x  # Print commands and their arguments as they are executed.
set -u  # Treat unset variables as an error when substituting.

echo "Copy Video SDK files"

#cp /media/$USER/CUDA/CUDAFILES/Video_Codec_SDK_9.1.23.zip

unzip -n Video_Codec_SDK_9.1.23.zip
cd ~/Video_Codec_SDK_9.1.23/include

sudo cp -u nvcuvid.h /usr/local/$CUDAVERSION/include/
sudo cp -u cuviddec.h /usr/local/$CUDAVERSION/include/


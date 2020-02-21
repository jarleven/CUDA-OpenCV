#!/bin/bash

# Files that need login from NVIDIA !

# cuDNN
# Video Codec

# Copy all the md5 files so we can check them with ease later
cp md5/*.md5 ~/

# Assume we have the files
MissingFiles=0


cd ~


# TODO the USB should have a folder named CUDA-files
cp /media/jarleven/CUDA/cudnn-10.0-linux-x64-v7.6.5.32.tgz ~/
cp /media/jarleven/CUDA/cudnn-10.2-linux-x64-v7.6.5.32.tgz ~/



if [ $SCRIPT_FFMPEG== "ON" ]
then
	# TODO be smarter than this.
	# The files are locaded on a USB drive named CUDA
    	cp /media/jarleven/CUDA/Video_Codec_SDK_9.1.23.zip ~/

	if md5sum -c videocodecsdk.md5; then
	    echo "Nvidia video Codec SDK already downloaded"
	else
	    echo "Videocodec needed!"
	    MissingFiles=1
	fi
fi


if md5sum -c cudnn-$SCRIPT_CUDAVER.md5; then
	# The MD5 sum matched
	echo "OK, found cuDNN file"
else
	echo "cuDNN installer not found, please download from link below"
	echo "https://developer.nvidia.com/rdp/cudnn-download"
	MissingFiles=1
fi


exit $MissingFiles

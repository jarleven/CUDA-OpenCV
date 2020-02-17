#!/bin/bash

# Files that need login from NVIDIA !

# cuDNN
# Video Codec

OK=T

MissingFiles=0

cd ~

if md5sum -c videocodecsdk.md5; then
    echo "Nvidia video Codec SDK already downloaded"
else

    echo "Videocodec needed!"
    MissingFiles=1
fi


if md5sum -c cudnn-10-0.md5; then
    # The MD5 sum matched
    echo "OK, found cuDNN files"
else
    echo "cuDNN installer not found, please download from link below"
    echo "https://developer.nvidia.com/rdp/cudnn-download"
    MissingFiles=1
fi

if md5sum -c cudnn-10-2.md5; then
    # The MD5 sum matched
    echo "OK, found cuDNN files"
else
    echo "cuDNN installer not found, please download from link below"
    echo "https://developer.nvidia.com/rdp/cudnn-download"
    MissingFiles=1
fi


exit $MissingFiles


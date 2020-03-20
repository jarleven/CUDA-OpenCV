#!/bin/bash

# Download OpenCV

set -e  # Exit immediately if a command exits with a non-zero status. (Exit on error)
set -x  # Print commands and their arguments as they are executed.
set -u  # Treat unset variables as an error when substituting.


OPENCV_VER="4.2.0"
#OPENCV_VER="3.4.9"

cd ~

if md5sum -c opencv.md5; then
    echo "OpenCV already downloaded"
else
    wget -O opencv.zip https://github.com/opencv/opencv/archive/$OPENCV_VER.zip
    wget -O opencv_contrib.zip https://github.com/opencv/opencv_contrib/archive/$OPENCV_VER.zip
    wget -O opencv_extra.zip https://github.com/opencv/opencv_extra/archive/$OPENCV_VER.zip
fi

# Unpack OpenCV

unzip opencv.zip
unzip opencv_contrib.zip
unzip opencv_extra.zip

mv opencv-$OPENCV_VER opencv
mv opencv_contrib-$OPENCV_VER opencv_contrib
mv opencv_extra-$OPENCV_VER opencv_extra



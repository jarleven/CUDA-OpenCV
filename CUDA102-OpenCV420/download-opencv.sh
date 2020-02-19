#!/bin/bash

# Download OpenCV

cp opencv.md5 ~/
cd ~
if md5sum -c opencv.md5; then
    echo "OpenCV already downloaded"
else
    wget -O opencv.zip https://github.com/opencv/opencv/archive/4.2.0.zip
    wget -O opencv_contrib.zip https://github.com/opencv/opencv_contrib/archive/4.2.0.zip
    wget -O opencv_extra.zip https://github.com/opencv/opencv_extra/archive/4.2.0.zip
fi

# Unpack OpenCV

unzip opencv.zip
unzip opencv_contrib.zip
unzip opencv_extra.zip

mv opencv-4.2.0 opencv
mv opencv_contrib-4.2.0 opencv_contrib
mv opencv_extra-4.2.0 opencv_extra



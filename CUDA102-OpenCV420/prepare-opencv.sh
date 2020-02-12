#!/bin/bash

sudo apt-add-repository universe
sudo apt-get update



sudo apt-get install -y cmake cmake-qt-gui
sudo apt install --assume-yes build-essential cmake git pkg-config unzip ffmpeg qtbase5-dev
sudo apt install -y libhdf5-dev
sudo apt install --assume-yes libgtk-3-dev libdc1394-22 libdc1394-22-dev libjpeg-dev libpng12-dev libtiff5-dev libjasper-dev
sudo apt install --assume-yes libavcodec-dev libavformat-dev libswscale-dev libxine2-dev libgstreamer0.10-dev libgstreamer-plugins-base0.10-dev
sudo apt install --assume-yes libv4l-dev libtbb-dev libfaac-dev libmp3lame-dev libopencore-amrnb-dev libopencore-amrwb-dev libtheora-dev
sudo apt install --assume-yes libvorbis-dev libxvidcore-dev v4l-utils
sudo apt-get install -y libglm-dev
sudo apt-get install -y libgtkglext1 libgtkglext1-dev
sudo apt-get install -y libglew-dev libtiff5-dev zlib1g-dev libjpeg-dev libpng12-dev libjasper-dev libavcodec-dev libavformat-dev libavutil-dev libpostproc-dev libswscale-dev libeigen3-dev libtbb-dev libgtk2.0-dev pkg-config


# Added 2019
sudo apt -y install ccache 
sudo apt -y install libopenblas-dev, libopenblas-base
#sudo ln -s /usr/include/lapacke.h /usr/include/x86_64-linux-gnu # corrected path for the library 
sudo apt -y install flake8
sudo apt install -y libatlas-base-dev libatlas3-base
sudo apt install -y libopencv-dev



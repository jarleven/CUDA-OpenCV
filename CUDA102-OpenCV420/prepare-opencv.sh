#!/bin/bash

# Keep this file clean with the following check, it will list duplicates.
# sed s/' '/\\n/g prepare-opencv.sh | sort | uniq -c | sort -n

source .setupvars
cd ~

sudo apt-get install -y screen vim
sudo apt-get install -y build-essential cmake unzip pkg-config
sudo apt-get install -y gcc-6 g++-6
sudo apt-get install -y libxmu-dev libxi-dev libglu1-mesa libglu1-mesa-dev
sudo apt-get install -y libjpeg-dev libpng-dev libtiff-dev
sudo apt-get install -y libavcodec-dev libavformat-dev libswscale-dev libv4l-dev
sudo apt-get install -y libxvidcore-dev libx264-dev
sudo apt-get install -y libopenblas-dev libatlas-base-dev liblapack-dev gfortran
sudo apt-get install -y libhdf5-serial-dev


sudo apt-get install -y python3-dev python3-tk python-imaging-tk
sudo apt-get install -y libgtk-3-dev





#sudo apt update
#sudo apt upgrade -y


libatk-bridge2.0-dev libatspi2.0-dev libdbus-1-dev libepoxy-dev 
#  libxkbcommon-dev libxtst-dev wayland-protocols x11proto-record-dev

	
# $ sudo apt-get install libv4l-dev libxvidcore-dev libx264-dev




sudo apt install -y cmake-qt-gui
sudo apt install -y build-essential cmake git pkg-config unzip qtbase5-dev
sudo apt install -y libhdf5-dev
sudo apt install -y libgtk-3-dev libdc1394-22 libdc1394-22-dev libjpeg-dev libpng12-dev libtiff5-dev libjasper-dev
sudo apt install -y libavcodec-dev libavformat-dev libswscale-dev libxine2-dev libgstreamer0.10-dev libgstreamer-plugins-base0.10-dev
sudo apt install -y libv4l-dev libtbb-dev libfaac-dev libmp3lame-dev libopencore-amrnb-dev libopencore-amrwb-dev libtheora-dev
sudo apt install -y libvorbis-dev libxvidcore-dev v4l-utils
sudo apt install -y libglm-dev
sudo apt install -y libgtkglext1 libgtkglext1-dev
sudo apt install -y libglew-dev libavutil-dev libpostproc-dev libeigen3-dev libgtk2.0-dev
sudo apt install -y tesseract-ocr libtesseract-dev libleptonica-dev

# Added 2019
sudo apt -y install ccache 
sudo apt -y install libopenblas-dev, libopenblas-base
#sudo ln -s /usr/include/lapacke.h /usr/include/x86_64-linux-gnu # corrected path for the library 
sudo apt -y install flake8
sudo apt install -y libatlas-base-dev libatlas3-base
sudo apt install -y libopencv-dev

sudo apt install -y dkms
sudo apt install -y freeglut3 freeglut3-dev libxi-dev libxmu-dev

sudo apt install -y gcc-6 g++-6
sudo apt install -y libglu1-mesa libglu1-mesa-dev

sudo apt install -y libpng-dev libtiff-dev

# FFMPEG remove if compile from source
sudo apt install -y libx264-dev 
#### End FFMPEG

sudo apt install -y libopenblas-dev liblapack-dev gfortran

sudo apt install -y libhdf5-serial-dev

#TODO 
sudo apt install -y python3-testresources


# The path is not set until next reboot when using pip ??
export PATH=/home/jarleven/.local/bin${PATH:+:${PATH}}

wget https://bootstrap.pypa.io/get-pip.py
sudo -H python3 get-pip.py

sudo apt install -y python3-dev python3-tk python-imaging-tk

pip install numpy
pip install tensorflow-gpu==$SCRIPT_TENSORFLOWVER


pip install scikit-image
pip install pillow
pip install imutils
pip install pylint

pip install scikit-learn
pip install matplotlib
pip install progressbar2
pip install beautifulsoup4
pip install pandas


sudo apt update
sudo apt upgrade -y




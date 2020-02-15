#!/bin/bash


sudo apt-get install -y vim ssh screen

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
sudo apt-get install -y tesseract-ocr libtesseract-dev libleptonica-dev

# Added 2019
sudo apt -y install ccache 
sudo apt -y install libopenblas-dev, libopenblas-base
#sudo ln -s /usr/include/lapacke.h /usr/include/x86_64-linux-gnu # corrected path for the library 
sudo apt -y install flake8
sudo apt install -y libatlas-base-dev libatlas3-base
sudo apt install -y libopencv-dev




sudo apt-get install -y build-essential cmake unzip pkg-config
sudo apt-get install -y gcc-6 g++-6
sudo apt-get install -y libxmu-dev libxi-dev libglu1-mesa libglu1-mesa-dev

sudo apt-get install -y libjpeg-dev libpng-dev libtiff-dev
sudo apt-get install -y libavcodec-dev libavformat-dev libswscale-dev libv4l-dev
sudo apt-get install -y libxvidcore-dev libx264-dev

sudo apt-get install -y libopenblas-dev libatlas-base-dev liblapack-dev gfortran

sudo apt-get install -y libhdf5-serial-dev

# PYTHON 3 (Assuming without Python2 and pip2)

wget https://bootstrap.pypa.io/get-pip.py
sudo -H python3 get-pip.py

sudo apt-get install -y python3-dev python3-tk python-imaging-tk
sudo apt-get install -y libgtk-3-dev

pip install numpy
pip install tensorflow-gpu==2.0.0


pip install opencv-contrib-python
pip install scikit-image
pip install pillow
pip install imutils


pip install scikit-learn
pip install matplotlib
pip install progressbar2
pip install beautifulsoup4
pip install pandas






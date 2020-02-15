#!/bin/bash

# Script as instructed in https://developer.nvidia.com/ffmpeg

sudo apt-get --purge remove ffmpeg


cd ~
git clone https://git.videolan.org/git/ffmpeg/nv-codec-headers.git
cd nv-codec-headers
sudo make install
cd ~

# From https://www.ffmpeg.org/download.html
wget https://ffmpeg.org/releases/ffmpeg-4.2.2.tar.bz2

tar xjf ffmpeg-4.2.2.tar.bz2

cd ffmpeg-4.2.2/


./configure --enable-cuda-sdk --enable-cuvid --enable-nvenc --enable-nonfree --enable-libnpp --extra-cflags=-I/usr/local/cuda/include --extra-ldflags=-L/usr/local/cuda/lib64

make -j 8

sudo make install


sudo make install


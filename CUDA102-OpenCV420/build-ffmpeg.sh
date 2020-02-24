#!/bin/bash

# Inspiration
# https://arstech.net/compile-ffmpeg-with-nvenc-h264/
# https://www.learnopencv.com/install-opencv-4-on-ubuntu-18-04/

# Script as instructed in https://developer.nvidia.com/ffmpeg

source .setupvars

cd ~

# TODO is FFMPEG installed in Ubuntu 18.04
sudo apt-get --purge remove -y ffmpeg
sudo apt -y remove x264 libx264-dev

# TODO put in common file ?
sudo apt install -y yasm

sudo dpkg --add-architecture i386
sudo apt-get update
sudo apt-get install -y build-essential git yasm unzip wget sysstat nasm libc6:i386 libavcodec-dev libavformat-dev libavutil-dev pkgconf g++ freeglut3-dev libx11-dev libxmu-dev libxi-dev libglu1-mesa libglu1-mesa-dev



# cp ffmpeg.md5 ~/
# cp videocodecsdk.md5 ~/

cd ~

# 16. Feb 2020 I got this info about the git archive.
# ~/nv-codec-headers$ git describe --tags
# n9.1.23.1-1-g250292d

cd ~

videocodecsdk.md5
if md5sum -c videocodecsdk.md5; then
    echo "OK, NVIDIA video Codec SDK found"
else
    echo "Videocodec needed!"
fi

rm -rf Video_Codec_SDK_9.1.23
unzip Video_Codec_SDK_9.1.23.zip 
sudo cp Video_Codec_SDK_9.1.23/Samples/common.mk /usr/local/include/


cd ~
git clone https://git.videolan.org/git/ffmpeg/nv-codec-headers.git
cd nv-codec-headers
sudo make
sudo make install
sudo ldconfig

cd ~
git clone https://code.videolan.org/videolan/x264.git
cd x264/
./configure --disable-cli --enable-static --enable-shared --enable-strip
make
sudo make install
sudo ldconfig


cd ~
if md5sum -c ffmpeg-$SCRIPT_FFMPEGVER.md5; then
    echo "FFMPEG already downloaded"
else
    echo "Download FFMPEG"
    # From https://www.ffmpeg.org/download.html
    wget https://ffmpeg.org/releases/ffmpeg-$SCRIPT_FFMPEGVER.tar.bz2
	md5sum ffmpeg-$SCRIPT_FFMPEGVER.tar.bz2 > ffmpeg-$SCRIPT_FFMPEGVER.md5
	# TODO copy the md5 file to the script folder
fi


tar xjf ffmpeg-$SCRIPT_FFMPEGVER.tar.bz2

cd ffmpeg-$SCRIPT_FFMPEGVER/

make clean

#./configure --enable-shared --disable-static --enable-cuda-sdk --enable-cuvid --enable-nvenc --enable-nonfree --enable-libnpp --extra-cflags=-I/usr/local/cuda-10.0/include --extra-ldflags=-L/usr/local/cuda-10.0/lib64
./configure --enable-shared --disable-static --enable-nonfree --enable-nvenc --enable-libx264 --enable-gpl --enable-cuda --enable-cuvid --enable-cuda-nvcc

make -j$(nproc)

sudo make install
sudo make install-libs

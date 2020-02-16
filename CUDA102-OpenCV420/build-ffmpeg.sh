#!/bin/bash

# Script as instructed in https://developer.nvidia.com/ffmpeg

# TODO Is FFMPEG istalled in Ubuntu 18.04
sudo apt-get --purge remove ffmpeg


# TODO put in common file ?
sudo apt install -y yasm

cd ~

# 16. Feb 2020 I got this info about the git archive.
# ~/nv-codec-headers$ git describe --tags
# n9.1.23.1-1-g250292d

git clone https://git.videolan.org/git/ffmpeg/nv-codec-headers.git
cd nv-codec-headers
sudo make install
cd ~


cp ffmpeg.md5 ~/
cd ~
if md5sum -c ffmpeg.md5; then
    echo "FFMPEG already downloaded"
else
    # From https://www.ffmpeg.org/download.html
    wget https://ffmpeg.org/releases/ffmpeg-4.2.2.tar.bz2
fi


tar xjf ffmpeg-4.2.2.tar.bz2

cd ffmpeg-4.2.2/


./configure --enable-cuda-sdk --enable-cuvid --enable-nvenc --enable-nonfree --enable-libnpp --extra-cflags=-I/usr/local/cuda/include --extra-ldflags=-L/usr/local/cuda/lib64

make clean
make -j$(nproc)

sudo make install


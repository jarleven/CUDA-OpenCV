#!/bin/bash

# Create a video from still images with accelerated encoding (approx 150 frames/sec)
# ffmpeg -f image2 -framerate 2 -i %*.png -c:v h264_nvenc -preset slow -qp 18 -pix_fmt yuv420p nord__2019-09-06.mp4


# Inspiration
# https://arstech.net/compile-ffmpeg-with-nvenc-h264/
# https://www.learnopencv.com/install-opencv-4-on-ubuntu-18-04/
# https://devblogs.nvidia.com/nvidia-ffmpeg-transcoding-guide/

# Script as instructed in https://developer.nvidia.com/ffmpeg


# time ffmpeg -i input -f null -



# Tips from https://github.com/opencv/opencv/issues/11220
# cuda video decoder (nvcuvid), will be deprecated.
# no longer exists in cuda (latest 10.1)
# 
# but if you want to use it with opencv, install NVIDIA Video Decoder SDK
# https://developer.nvidia.com/nvidia-video-codec-sdk
# 
# after install it, you will have nvcuvid.lib in SDK/lib/(platform) directory.
# just pointing the opencv setting cuda_nvcuvid_library to that file.
# and make sure you check WITH NVCUVID



set -e  # Exit immediately if a command exits with a non-zero status. (Exit on error)
set -x  # Print commands and their arguments as they are executed.
set -u  # Treat unset variables as an error when substituting.


cd "$(dirname "$0")"


# TODO  In case you run this script only ?
# https://stackoverflow.com/questions/34799969/how-to-detect-if-a-shell-script-is-called-from-another-shell-script


#CUDAVERSION="cuda-10.0"
#SCRIPT_FFMPEGVER="4.2.2"

source .setupvars
source ./environmet.sh

cd ~

# TODO is FFMPEG installed in Ubuntu 18.04
sudo apt-get --purge remove -y ffmpeg
sudo apt -y remove x264 libx264-dev

# TODO put in common file ?
sudo apt install -y yasm

sudo dpkg --add-architecture i386
sudo apt-get update
sudo apt-get install -y build-essential git yasm unzip wget sysstat nasm libc6:i386 libavcodec-dev libavformat-dev libavutil-dev pkgconf g++ freeglut3-dev libx11-dev libxmu-dev libxi-dev libglu1-mesa libglu1-mesa-dev

# Addition for Ubuntu 19.10
sudo apt install -y libavdevice-dev libavfilter-dev libavresample-dev libpostproc-dev


# FOR ALSA sound
# https://raspberrypi.stackexchange.com/questions/70479/ffmpeg-unknown-input-format-alsa
# before attempting to configure and compile ffmpeg or anything where you need alsa support.
sudo apt-get install libasound2-dev


# cp ffmpeg.md5 ~/
# cp videocodecsdk.md5 ~/

cd ~

# 16. Feb 2020 I got this info about the git archive.
# ~/nv-codec-headers$ git describe --tags
# n9.1.23.1-1-g250292d

cd ~

#videocodecsdk.md5
FILE=Video_Codec_SDK_9.1.23.zip

if [ ! -f ~/$FILE ]; then
    echo "File not found!"
    cp ~/CUDAFILES/$FILE ~/
fi



if md5sum -c videocodecsdk.md5; then
    echo "OK, NVIDIA video Codec SDK found"
else
    echo "Videocodec needed!"

fi

#rm -rf Video_Codec_SDK_9.1.23
# unzip -o  overwrite files WITHOUT prompting 
# unzip -n  never overwrite existing files
unzip -n Video_Codec_SDK_9.1.23.zip 
sudo cp Video_Codec_SDK_9.1.23/Samples/common.mk /usr/local/include/

#### Not sure if this is needed !

# cp  -u, --update  copy only when the SOURCE file is newer than the destination file or when the destination file is missing
cd Video_Codec_SDK_9.1.23/include
sudo cp -u nvcuvid.h /usr/local/$CUDAVERSION/include/
sudo cp -u cuviddec.h /usr/local/$CUDAVERSION/include/
#### ????


rm -rf ~/nv-codec-headers
rm -rf ~/x264

cd ~
git clone https://git.videolan.org/git/ffmpeg/nv-codec-headers.git
cd nv-codec-headers
sudo make
sudo make install
sudo ldconfig

cd ~
git clone https://code.videolan.org/videolan/x264.git
cd x264/
./configure --disable-cli --enable-shared --disable-static--enable-strip --enable-libvidstab
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

#make clean

# --enable-cuda-sdk --enable-libx264 --enable-gpl  --enable-cuda-nvcc
./configure --enable-shared --disable-static --disable-debug --enable-gpl --enable-zlib --enable-cuda --enable-opencl --enable-runtime-cpudetect --enable-cuvid --enable-nvenc --enable-nvdec --enable-nonfree --enable-libnpp --extra-cflags=-I/usr/local/$CUDAVERSION/include  --extra-ldflags=-L/usr/local/$CUDAVERSION/lib64


#  configuration:  --disable-autodetect --enable-amf --enable-bzlib --enable-cuda --enable-cuvid --enable-d3d11va --enable-dxva2 --enable-iconv --enable-lzma --enable-nvenc --enable-zlib --enable-sdl2 --disable-debug --enable-ffnvcodec --enable-nvdec --enable-libmp3lame --enable-libopus --enable-libvorbis --enable-libvpx --enable-libx264 --enable-libx265 --enable-fontconfig --enable-libass --enable-libbluray --enable-libfreetype --enable-libmfx --enable-libmysofa --enable-libopencore-amrnb --enable-libopencore-amrwb --enable-libopenjpeg --enable-libsnappy --enable-libsoxr --enable-libspeex --enable-libtheora --enable-libtwolame --enable-libvidstab --enable-libvo-amrwbenc --enable-libwavpack --enable-libwebp --enable-libxml2 --enable-libzimg --enable-libshine --enable-gpl --enable-avisynth --enable-libxvid --enable-libaom --enable-version3 --enable-mbedtls --extra-cflags=-DLIBTWOLAME_STATIC --extra-libs=-lstdc++ --extra-cflags=-DLIBXML_STATIC --extra-libs=-liconv


make -j$(nproc)

sudo make install
sudo make install-libs

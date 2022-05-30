#!/bin/bash

: '

wget https://raw.githubusercontent.com/jarleven/CUDA-OpenCV/master/Docker/ffmpeg.sh
chmod +x ffmpeg.sh
./ffmpeg.sh

'

# https://forum.opencv.org/t/reading-and-writing-videos-python-on-gpu-with-cuda-videocapture-and-videowriter/156/10
#
# On a related if you are on linux and your version of Ffmpeg is built with Nvidia HW acceleration 20 you should be able to set the below variable
#
# 'OPENCV_FFMPEG_CAPTURE_OPTIONS=video_codec;h264_cuvid'
# and cv::VideoCapture()should perform the video decoding on your GPU.
#
# https://docs.nvidia.com/video-technologies/video-codec-sdk/ffmpeg-with-nvidia-gpu/

apt install -y build-essential yasm cmake libtool libc6 libc6-dev unzip wget libnuma1 libnuma-dev

python3 -m pip install nvidia-pyindex nvidia-tensorrt


cd /usr/src/app/
git clone https://git.videolan.org/git/ffmpeg/nv-codec-headers.git
cd nv-codec-headers
make install

cd /usr/src/app/
git clone https://git.ffmpeg.org/ffmpeg.git ffmpeg/

cd ffmpeg
./configure --enable-nonfree --enable-cuda-nvcc --enable-libnpp --extra-cflags=-I/usr/local/cuda/include --extra-ldflags=-L/usr/local/cuda/lib64 --enable-static --disable-shared

make -j 12
make install

ffmpeg -decoders 2>/dev/null | grep h264_cuvid



cd /usr/src/app/

cp /model/detect_jee_v9.py .
cp /model/datasets.py utils/

python export.py --device 0 --weights /model/fiskAI_v2.pt --include onnx

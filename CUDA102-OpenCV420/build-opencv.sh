#!/bin/bash

# Compileing an GPU example like this
# ~/opencv/samples/gpu$ nvcc `pkg-config --libs opencv4` -L. -L/usr/local/cuda/lib -lcuda -lcudart `pkg-config --cflags opencv4` -I . -I /usr/local/cuda-10.1 bgfg_segm.cpp -o bgfg_seg

set -e  # Exit immediately if a command exits with a non-zero status. Exit on error
set -x  # Print commands and their arguments as they are executed.
set -u  # Treat unset variables as an error when substituting.


# In case of rebuild, delete everything before building
sudo rm -rf ~/opencv/build
mkdir -p ~/opencv/build

cd /home/$USER/CUDA-OpenCV/CUDA102-OpenCV420
source .setupvars
source environmet.sh



# We build here
cd ~/opencv/build

# The following NEW packages will be installed:
#  libatk-bridge2.0-dev libatspi2.0-dev libdbus-1-dev libepoxy-dev libgtk-3-dev
#  libxkbcommon-dev libxtst-dev wayland-protocols x11proto-record-dev

# $ sudo apt-get install build-essential cmake unzip pkg-config
# $ sudo apt-get install libjpeg-dev libpng-dev libtiff-dev
# $ sudo apt-get install libavcodec-dev libavformat-dev libswscale-dev
# $ sudo apt-get install libv4l-dev libxvidcore-dev libx264-dev
# $ sudo apt-get install libgtk-3-dev
# $ sudo apt-get install libatlas-base-dev gfortran
# $ sudo apt-get install python3-dev

# python yolo_object_detection.py --input ../example_videos/janie.mp4 --output ../output_videos/yolo_janie.avi --yolo yolo-coco --display 0 --use-gpu 1

# TODO. Had this for Ubuntu 19.10 but think the problem was GCC 9 so removed for now.
#    -D BUILD_opencv_dnn_modern=OFF \


cmake \
    -D CMAKE_BUILD_TYPE=RELEASE \
    -D CMAKE_INSTALL_PREFIX=/usr/local \
    -D BUILD_PNG=OFF \
    -D BUILD_TIFF=OFF \
    -D BUILD_JPEG=OFF \
    -D BUILD_JASPER=OFF \
    -D BUILD_ZLIB=OFF \
    -D WITH_OPENCL=OFF \
    -D WITH_OPENGL=ON \
    -D WITH_OPENMP=OFF \
    -D WITH_FFMPEG=$SCRIPT_FFMPEG \
    -D WITH_GSTREAMER=OFF \
    -D WITH_GSTREAMER_0_10=OFF \
    -D WITH_CUDA=ON \
    -D ENABLE_FAST_MATH=1 \
    -D CUDA_FAST_MATH=1 \
    -D CUDA_NVCC_FLAGS="-D_FORCE_INLINES" \
    -D CUDA_HOST_COMPILER:FILEPATH=/usr/bin/gcc-8 \
    -D WITH_CUBLAS=1 \
    -D WITH_CUDNN=ON \
    -D OPENCV_DNN_CUDA=ON \
    -D WITH_CUFFT=1 \
    -D WITH_GTK=ON \
    -D WITH_QT=ON \
    -D WITH_VTK=OFF \
    -D WITH_TBB=ON \
    -D WITH_V4L=ON \
    -D WITH_1394=OFF \
    -D WITH_NVCUVID=ON \
    -D OPENCV_GENERATE_PKGCONFIG=ON \
    -D CUDA_TOOLKIT_ROOT_DIR=$SCRIPT_CUDAPATH \
    -D CUDA_ARCH_BIN=$SCRIPT_CUDA_ARCH_BIN \
    -D CUDA_ARCH_PTX=$SCRIPT_CUDA_ARCH_PTX \
    -D BUILD_EXAMPLES=ON \
    -D INSTALL_C_EXAMPLES=OFF \
    -D OPENCV_ENABLE_NONFREE=ON \
    -D BUILD_opencv_java=OFF \
    -D HAVE_opencv_python3=ON \
    -D PYTHON_EXECUTABLE=$(which python3) \
    -D OPENCV_ENABLE_NONFREE=ON \
    -D INSTALL_TESTS=ON \
    -D ENABLE_CONTRIB=1 \
    -D OPENCV_EXTRA_MODULES_PATH=~/opencv_contrib/modules \
    -D OPENCV_TEST_DATA_PATH=~/opencv_extra/testdata \
    ..





#### Make clean in case we run script multiple times
make clean

#### Now make the OpenCV project
make -j$(nproc)

#### At this point the sudo password have timed out, you need to enter it again 
#### TODO. Try to fix this issue....
sudo make install 

#TODO I'm not certain, need to investigare
sudo ldconfig

# Some applications have hardcoded links to example data files like samples/gpu/bgfg_segm.cpp 
# Link in the sample data
#ln -s ~/opencv/samples/data/* ~/opencv/build/data/

# cd ~/.virtualenvs/opencv_cuda/lib/python3.6/site-packages/
# ln -s /usr/local/lib/python3.6/site-packages/cv2/python-3.6/cv2.cpython-36m-x86_64-linux-gnu.so cv2.so



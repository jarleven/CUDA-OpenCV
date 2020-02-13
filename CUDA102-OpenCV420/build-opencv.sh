#!/bin/bash


cd ~/opencv/build

cmake \
    -D CMAKE_BUILD_TYPE=RELEASE \
    -D CMAKE_INSTALL_PREFIX=/usr/local \
    -D BUILD_PNG=OFF \
    -D BUILD_TIFF=OFF \
    -D BUILD_JPEG=OFF \
    -D BUILD_JASPER=OFF \
    -D BUILD_ZLIB=OFF \
    -D BUILD_EXAMPLES=ON \
    -D BUILD_opencv_java=OFF \
    -D BUILD_opencv_nonfree=OFF \
    -D BUILD_opencv_python=OFF \
    -D WITH_OPENCL=OFF \
    -D WITH_OPENGL=ON \
    -D WITH_OPENMP=OFF \
    -D WITH_FFMPEG=ON \
    -D WITH_GSTREAMER=OFF \
    -D WITH_GSTREAMER_0_10=OFF \
    -D WITH_CUDA=ON \
    -D CUDA_FAST_MATH=1 \
    -D CUDA_NVCC_FLAGS="-D_FORCE_INLINES" \
    -D ENABLE_FAST_MATH=1 \
    -D WITH_CUBLAS=1 \
    -D WITH_CUFFT=1 \
    -D WITH_GTK=ON \
    -D WITH_QT=ON \
    -D WITH_VTK=OFF \
    -D WITH_TBB=ON \
    -D WITH_V4L=ON \
    -D WITH_1394=OFF \
    -D WITH_NVCUVID=ON \
    -D OPENCV_GENERATE_PKGCONFIG=ON \
    -D CUDA_TOOLKIT_ROOT_DIR=/usr/local/cuda \
    -D CUDA_ARCH_BIN="6.1" \
    -D CUDA_ARCH_PTX="6.1" \
    -D INSTALL_C_EXAMPLES=ON \
    -D INSTALL_TESTS=ON \
    -D OPENCV_EXTRA_MODULES_PATH=../../opencv_contrib/modules .. \
    -D OPENCV_TEST_DATA_PATH=../opencv_extra/testdata \
    ..



#### Make clean in case we run script multiple times
make clean

#### Now make the OpenCV project
make -j$(nproc)

#### At this point the sudo password have timed out, you need to enter it again 
#### TODO. Try to fix this issue....
sudo make install 

# Setup the CUDA path's (FFMPEG would not compile without)

export LD_LIBRARY_PATH=/usr/local/cuda/lib64${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}
export PATH="/usr/local/cuda/bin/:$PATH"


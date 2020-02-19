#!/bin/bash


rm -rf ~/opencv/build
mkdir ~/opencv/build

cd ~/opencv/build

# Some applications have hardcoded links to example data files like samples/gpu/bgfg_segm.cpp 
# Link in the sample data
ln -s ~/opencv/samples/data/* ~/opencv/build/data/

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
    -D WITH_FFMPEG=OFF \
    -D WITH_GSTREAMER=OFF \
    -D WITH_GSTREAMER_0_10=OFF \
    -D WITH_CUDA=ON \
    -D CUDA_FAST_MATH=1 \
    -D CUDA_NVCC_FLAGS="-D_FORCE_INLINES" \
    -D ENABLE_FAST_MATH=1 \
    -D WITH_CUBLAS=1 \
    -D OPENCV_DNN_CUDA=ON \
    -D WITH_CUFFT=1 \
    -D WITH_GTK=ON \
    -D WITH_QT=ON \
    -D WITH_VTK=OFF \
    -D WITH_TBB=ON \
    -D WITH_V4L=ON \
    -D WITH_1394=OFF \
    -D WITH_NVCUVID=OFF \
    -D OPENCV_GENERATE_PKGCONFIG=ON \
    -D CUDA_TOOLKIT_ROOT_DIR=/usr/local/cuda \
    -D CUDA_ARCH_BIN="6.1" \
    -D CUDA_ARCH_PTX="6.1" \
    -D BUILD_EXAMPLES=ON \
    -D INSTALL_C_EXAMPLES=ON \
    -D OPENCV_ENABLE_NONFREE=ON \
    -D BUILD_opencv_java=OFF \
    -D BUILD_NEW_PYTHON_SUPPORT=ON \
    -D BUILD_opencv_python3=ON \
    -D HAVE_opencv_python3=ON \
    -D PYTHON_DEFAULT_EXECUTABLE=$(which python3) \
    -D OPENCV_ENABLE_NONFREE=ON \
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

#TODO I'm not certain, need to investigare
sudo ldconfig

# Setup the CUDA path's (FFMPEG would not compile without)

#export LD_LIBRARY_PATH=/usr/local/cuda/lib64${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}
#export PATH="/usr/local/cuda/bin/:$PATH"


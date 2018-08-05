

A quick test to see if I can get OpenCV 3.4.2 working on CUDA 8

Got some of the hints from this page : http://www.python36.com/how-to-install-opencv340-on-ubuntu1604/

In case you have installed OpenCV already from source go to your current opencv folder and do "sudo make uninstall"
```
wget -O opencv.zip https://github.com/opencv/opencv/archive/3.4.2.zip
wget -O opencv_contrib.zip https://github.com/opencv/opencv_contrib/archive/3.4.2.zip
wget -O opencv_extra.zip https://github.com/opencv/opencv_extra/archive/3.4.2.zip

unzip opencv.zip
unzip opencv_contrib.zip
unzip opencv_extra.zip

mkdir ~/buildocv
cd ~/buildocv

cmake \
    -DCMAKE_BUILD_TYPE=Release \
    -DBUILD_PNG=OFF \
    -DBUILD_opencv_java=OFF \
    -DBUILD_opencv_nonfree=ON \
    -DBUILD_opencv_python=ON \
    -DWITH_OPENCL=ON \
    -DWITH_OPENGL=ON \
    -DWITH_OPENMP=OFF \
    -DWITH_FFMPEG=ON \
    -DWITH_GSTREAMER=ON \
    -DWITH_CUDA=ON \
    -D CUDA_FAST_MATH=1 \
    -D ENABLE_FAST_MATH=1 \
    -D WITH_CUBLAS=1 \
    -DWITH_GTK=ON \
    -DWITH_QT=ON \
    -DWITH_VTK=OFF \
    -DWITH_TBB=ON \
    -DWITH_1394=OFF \
    -DWITH_OPENEXR=OFF \
    -DWITH_NVCUVID=ON \
    -DCUDA_TOOLKIT_ROOT_DIR=/usr/local/cuda \
    -DCUDA_ARCH_BIN='3.0 3.5 5.0 6.0 6.2' \
    -DCUDA_ARCH_PTX="" \
    -DINSTALL_C_EXAMPLES=ON \
    -DINSTALL_PYTHON_EXAMPLES=ON \
    -DINSTALL_TESTS=ON \
    -DOPENCV_EXTRA_MODULES_PATH=~/opencv_contrib-3.4.2/modules \
    -DOPENCV_TEST_DATA_PATH=~/opencv_extra-3.4.2/testdata \
    -DCMAKE_INSTALL_PREFIX=/usr/local \
    ../opencv-3.4.2


make -j7
sudo make install
reboot

Modified with examples off. Need to look into the flags again. See that TBB is both on and off!!!

https://github.com/opencv/opencv/issues/10953


```
    -DOPENCV_TEST_DATA_PATH=~/opencv_extra/testdata \
    -DCMAKE_INSTALL_PREFIX=~/opencv \
    
    
    Notes compared to the 3.1.0 release
    The following package was automatically installed and is no longer required:
  libllvm5.0
  
  The following NEW packages will be installed:
  libx264-dev

For optimization:

sudo apt-get install libatlas-base-dev gfortran pylint




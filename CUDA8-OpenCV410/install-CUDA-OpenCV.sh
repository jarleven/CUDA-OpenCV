#!/bin/sh

#### Download and make executable
#### wget https://raw.githubusercontent.com/jarleven/CUDA-OpenCV/master/CUDA8-OpenCV310/install-CUDA-OpenCV.sh && chmod +x install-CUDA-OpenCV.sh

#### ############################################################################ #####

#### Setup instruction for Ubuntu 16.04.6 LTS \n \l
#### OpenCV 3.4.6 	
#### CUDA 8 CA2
#### Tested on Nvidia GTX 680      NA
#### Tested on Nvidia GTX 1080 Ti  4. June 2019

#### There are probably many pakages and steps not really required in this script but for my need it is working out of the box
#### 

#### During installation of Ubuntu 16.04.6
####  [ ] Download updates while installing Ubuntu
####  [ ] Download third-party software for ...
####  [O] Erase disk and install Ubuntu

#### Picked up partially working instructions form the following 
####    https://gist.github.com/lelechen63/aef76b7e9840b67114a81e8d5a0d66ac
####    https://docs.opencv.org/trunk/d6/d15/tutorial_building_tegra_cuda.html
####    https://technofob.com/2017/11/22/install-gpu-tensorflow-on-aws-ubuntu-16-04/   Looks interesting also
####
####

#### The following files have been downloaded in advance. Put them in the same directory as this script
#### MD5Sum of the files provided for convinience. 

#### b4e1d5e596ac2d6d0deaa2d558b4c40c  cuda-repo-ubuntu1604-8-0-local-cublas-performance-update_8.0.61-1_amd64.deb
#### d735c7fed8be0e72fa853f65042d5438  cuda-repo-ubuntu1604-8-0-local-ga2_8.0.61-1_amd64.deb
#### 7be63e8117df79f20292b159c4a80db1  cuDNN-Installation-Guide.pdf
#### c1c93bc769dc2d6e9f7322a7b3d19a40  libcudnn7_7.0.5.15-1+cuda8.0_amd64.deb
#### 2a6d75f4d473e3e85efc34e1e5b733f9  libcudnn7-dev_7.0.5.15-1+cuda8.0_amd64.deb
#### c6385ee06fafedc8f873e1ea3f499aff  libcudnn7-doc_7.0.5.15-1+cuda8.0_amd64.deb


#### Working example 04. June 2019
####


#### g++ -ggdb ~/opencv/samples/gpu/video_reader.cpp -o ~/video_reader `pkg-config --cflags --libs opencv` -I /usr/local/cuda/include/
#### g++ -ggdb ~/opencv/samples/gpu/bgfg_segm.cpp -o ~/bgfg_segm `pkg-config --cflags --libs opencv` -I /usr/local/cuda/include/


#### ffmpeg -i file.mp4 file.mp4.avi
#### bgfg_segm -f file.mp4.avi


#### Run the sample application from a remote terminal
#### DISPLAY=:0.0 ~/opencv/samples/gpu/video_reader ~/ipcam-7--00365.mp4
#### DISPLAY=:0.0 ~/opencv/samples/gpu/video_reader ~/opencv/samples/data/768x576.avi


#### Create md5sum file with:
####    md5sum cuda-repo-ubuntu1604-8-0-local-cublas-performance-update_8.0.61-1_amd64.deb cuda-repo-ubuntu1604-8-0-local-ga2_8.0.61-1_amd64.deb  > cudafiles.md5
#### Check md5sum with
####    md5sum -c cudafiles.md5



####
####
#### Start of automatic setup script.
####
####


#### Get the md5sums for NVIDIA CUDA® 8 files and the NVIDIA CUDA® Deep Neural Network library (cuDNN) files.
wget  --quiet --show-progress https://raw.githubusercontent.com/jarleven/CUDA-OpenCV/master/CUDA8-OpenCV310/cudafiles.md5
wget  --quiet --show-progress https://raw.githubusercontent.com/jarleven/CUDA-OpenCV/master/CUDA8-OpenCV310/cudnnfiles.md5

#### Check if we have the cuDNN files
usecuDNN=true
if md5sum -c cudnnfiles.md5; then
    # The MD5 sum matched
    echo "OK, found cuDNN files"
else
    # The MD5 sum didn't match
    echo "----"
    echo "The NVIDIA CuDNN files are missing."
    echo "Installation can be done without the NVIDIA CUDA Deep Neural Network library (cuDNN)"
    read -r -p "Continue with the installation? [y/N] " response
    case "$response" in
        [yY][eE][sS]|[yY])
            echo "OK, continuing without the NVIDIA CUDA Deep Neural Network library (cuDNN)"
            usecuDNN=false
            ;;
        *)
            echo "Quitting"
            echo "Download from here https://developer.nvidia.com/rdp/cudnn-download"
            echo "The following files are needed (read expeced by the script):"
            echo " libcudnn7_7.0.5.15-1+cuda8.0_amd64.deb"
            echo " libcudnn7-dev_7.0.5.15-1+cuda8.0_amd64.deb"
            echo " libcudnn7-doc_7.0.5.15-1+cuda8.0_amd64.deb"

            exit 1
            ;;
    esac
fi

echo "Moving on...."


#### By default the Nvidia CUDA8 files have extension -deb, just change to .deb instead. Just in case you downloaded them manually.
mv ./cuda-repo-ubuntu1604-8-0-local-ga2_8.0.61-1_amd64-deb ./cuda-repo-ubuntu1604-8-0-local-ga2_8.0.61-1_amd64.deb
mv ./cuda-repo-ubuntu1604-8-0-local-cublas-performance-update_8.0.61-1_amd64-deb ./cuda-repo-ubuntu1604-8-0-local-cublas-performance-update_8.0.61-1_amd64.deb

#### Check if we have the CUDA8 GA2 files, if not download them
FILE=./cuda-repo-ubuntu1604-8-0-local-ga2_8.0.61-1_amd64.deb
if [ -f $FILE ]; then
   echo "File $FILE exists."
else
   echo "File $FILE does not exist. Downloading"
   wget --quiet --show-progress -O ./cuda-repo-ubuntu1604-8-0-local-ga2_8.0.61-1_amd64.deb https://developer.nvidia.com/compute/cuda/8.0/Prod2/local_installers/cuda-repo-ubuntu1604-8-0-local-ga2_8.0.61-1_amd64-deb
fi

FILE=./cuda-repo-ubuntu1604-8-0-local-cublas-performance-update_8.0.61-1_amd64.deb
if [ -f $FILE ]; then
   echo "File $FILE exists."
else
   echo "File $FILE does not exist. Downloading"
   wget --quiet --show-progress -O ./cuda-repo-ubuntu1604-8-0-local-cublas-performance-update_8.0.61-1_amd64.deb https://developer.nvidia.com/compute/cuda/8.0/Prod2/patches/2/cuda-repo-ubuntu1604-8-0-local-cublas-performance-update_8.0.61-1_amd64-deb
fi


if md5sum -c cudafiles.md5; then
    # The MD5 sum matched
    echo "OK"
else
    # The MD5 sum didn't match
    echo "The CUDA 8 files are missing or have the wrong md5sum. Better halt the installation"
    exit 1
fi

echo "Continuing with installation"


sudo apt update
sudo apt -y upgrade
sudo apt install -y vim
sudo apt install -y vlc
sudo apt install -y ssh

sudo apt-add-repository universe
sudo apt-get update




#### Start with clean Nvidia drivers
sudo apt purge -y nvidia-*
sudo apt update

#### We probably don't need all this...
sudo apt-get install -y cmake cmake-qt-gui
sudo apt install --assume-yes build-essential cmake git pkg-config unzip ffmpeg qtbase5-dev python-dev python3-dev python-numpy python3-numpy
sudo apt install -y libhdf5-dev
sudo apt install --assume-yes libgtk-3-dev libdc1394-22 libdc1394-22-dev libjpeg-dev libpng12-dev libtiff5-dev libjasper-dev
sudo apt install --assume-yes libavcodec-dev libavformat-dev libswscale-dev libxine2-dev libgstreamer0.10-dev libgstreamer-plugins-base0.10-dev
sudo apt install --assume-yes libv4l-dev libtbb-dev libfaac-dev libmp3lame-dev libopencore-amrnb-dev libopencore-amrwb-dev libtheora-dev
sudo apt install --assume-yes libvorbis-dev libxvidcore-dev v4l-utils
sudo apt-get install -y libglm-dev
sudo apt-get install -y libgtkglext1 libgtkglext1-dev
sudo apt-get install -y libglew-dev libtiff5-dev zlib1g-dev libjpeg-dev libpng12-dev libjasper-dev libavcodec-dev libavformat-dev libavutil-dev libpostproc-dev libswscale-dev libeigen3-dev libtbb-dev libgtk2.0-dev pkg-config

sudo apt-get install -y python-dev python-numpy python-py python-pytest
sudo apt-get install -y python3-dev python3-numpy python3-py python3-pytest

# Added 2019
sudo apt -y install ccache 
sudo apt -y install libopenblas-dev, libopenblas-base
sudo ln -s /usr/include/lapacke.h /usr/include/x86_64-linux-gnu # corrected path for the library 
sudo apt -y install flake8
sudo apt install -y libatlas-base-dev libatlas3-base
sudo apt install -y libopencv-dev


# For some reason pip 19.1.1 is broken 
# python -m pip uninstall pip
# sudo apt -y install python-pip
python -m pip install pip==9.0.3

python3 -m pip install pip==9.0.3

sudo pip install pylint
sudo pip3 install pylint


#### Install the CUDA 8 packages
sudo dpkg -i cuda-repo-ubuntu1604-8-0-local-ga2_8.0.61-1_amd64.deb
sudo dpkg -i cuda-repo-ubuntu1604-8-0-local-cublas-performance-update_8.0.61-1_amd64.deb

sudo apt-key add /var/cuda-repo-8-0-local-ga2/7fa2af80.pub
sudo apt-key add /var/cuda-repo-8-0-local-cublas-performance-update/7fa2af80.pub

sudo apt update

# Note the line below is needed, don't iunderstand why the dpkg -i does not install CUDA ???
sudo apt install -y cuda
sudo apt update

#### If we have the cuDNN files install that to
if $usecuDNN ; then
    sudo dpkg -i libcudnn7_7.0.5.15-1+cuda8.0_amd64.deb
    sudo dpkg -i libcudnn7-dev_7.0.5.15-1+cuda8.0_amd64.deb
    sudo dpkg -i libcudnn7-doc_7.0.5.15-1+cuda8.0_amd64.deb
    sudo apt update
fi


sudo apt-get install -y --reinstall ubuntu-desktop unity compizconfig-settings-manager upstart

#### You need to add the following to the environment variable. Done below automatically
####    export LD_LIBRARY_PATH=/usr/local/cuda/targets/x86_64-linux/lib:$LD_LIBRARY_PATH
####    export PATH=/usr/local/cuda/bin/:$PATH

#### In case you run the script multiple times remove the stuff potentially added....
sed -i '/Add CUDA environment/d' ~/.bashrc
sed -i '/\/usr\/local\/cuda/d' ~/.bashrc

echo '# Add CUDA environment' >> ~/.bashrc 
echo 'export LD_LIBRARY_PATH=/usr/local/cuda/targets/x86_64-linux/lib:$LD_LIBRARY_PATH' >> ~/.bashrc
echo 'export PATH=/usr/local/cuda/bin/:$PATH' >> ~/.bashrc


sudo rm -fr ~/.cache/compizconfig-1
sudo rm -fr ~/.compiz

sudo rm -fr ~/.Xauthority
sudo rm -fr ~/.config/autostart


sudo rm -f /usr/lib/libnvcuvid.so
sudo rm -f /usr/lib/libnvcuvid.so.1

sudo ln -s /usr/lib/nvidia-384/libnvcuvid.so /usr/lib/libnvcuvid.so
sudo ln -s /usr/lib/nvidia-384/libnvcuvid.so.1 /usr/lib/libnvcuvid.so.1

#### Configure your git client. Required for doing cherry picking.
#### You can look at the Git configuration with:
####    git config --list
#### git config --global user.email "foo@bar.net"
#### git config --global user.name "Foo Bar"

fullname=$( getent passwd "$USER" | cut -d: -f5 | cut -d, -f1 )
git config --global user.email $USER"@gmail.com"
git config --global user.name "$fullname"


cd ~/
git clone https://github.com/opencv/opencv.git
cd ~/opencv
git checkout -b v4.1.0 4.1.0


cd ~/
git clone https://github.com/opencv/opencv_extra.git
cd ~/opencv_extra
git checkout -b v4.1.0 4.1.0


cd ~/
git clone https://github.com/opencv/opencv_contrib.git
cd ~/opencv_contrib
git checkout -b v4.1.0 4.1.0



# From within : cd ~/opencv/build
mkdir ~/opencv/build

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
    -D BUILD_opencv_python=ON \
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


####  TODO: Add support for new / all architectures
####   For GTX 680 Ti
####    -DCUDA_ARCH_BIN="3.0" \
####    -DCUDA_ARCH_PTX="3.0" \

####   For GTX 1080 Ti
####    -DCUDA_ARCH_BIN="6.1" \
####    -DCUDA_ARCH_PTX="6.1" \


####    -DCUDA_ARCH_BIN='3.0 3.5 5.0 6.0 6.2' \
####    -DCUDA_ARCH_PTX="" \

#### Make clean in case we run script multiple times
make clean

#### Now make the OpenCV project
make -j$(nproc)

#### At this point the sudo password have timed out, you need to enter it again 
#### TODO. Try to fix this issue....
sudo make install 


#### https://stackoverflow.com/questions/12335848/opencv-program-compile-error-libopencv-core-so-2-4-cannot-open-shared-object-f
#### ./video_reader: error while loading shared libraries: libopencv_cudacodec.so.3.4: cannot open shared object file: No such file or directory
#### Why I need this I dont know...
sudo updatedb && locate libopencv_core.so.2.4
sudo ldconfig -v


# Added this for OpenCV 4.1.0 7th June 2019
# See comment 26.May 2019 https://github.com/opencv/opencv/issues/13154

# https://prateekvjoshi.com/2013/10/18/package-opencv-not-found-lets-find-it/

pkg-config --cflags opencv4
pkg-config --libs opencv4

pkg-config --cflags opencv
pkg-config --libs opencv

#### Reboot to make all the changes take effect
echo "-----------------------    "
echo "                           "
echo " We are done. Rebooting... "

sleep 3
#sudo reboot




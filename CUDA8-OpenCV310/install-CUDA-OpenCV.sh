#!/bin/sh

#### Download and make executable
#### wget https://raw.githubusercontent.com/jarleven/CUDA-OpenCV/master/CUDA8-OpenCV310/install-CUDA-OpenCV.sh && chmod +x install-CUDA-OpenCV.sh

#### ############################################################################ #####

#### Setup instruction for Ubuntu 16.04.5 LTS \n \l
#### OpenCV 3.1.0
#### CUDA 8
#### Tested on Nvidia GTX 680      1. Aug 2018
#### Tested on Nvidia GTX 1080 Ti  3. Aug 2018

#### There are probably many pakages and steps not really required in this script
#### 

#### During installation of Ubuntu 16.04
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


#### Working example 01. August 2018
####
#### cd ~/opencv/samples/gpu
#### g++ -ggdb video_reader.cpp -o video_reader `pkg-config --cflags --libs opencv` -I /usr/local/cuda/include/

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
    read -r -p "The NVIDIA CuDNN files are missing. Continue with the installation? [y/N] " response
    case "$response" in
        [yY][eE][sS]|[yY])
            echo "OK - without the NVIDIA CUDA Deep Neural Network library (cuDNN)"
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

echo 'Add CUDA environment' >> ~/.bashrc 
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
git checkout -b v3.1.0 3.1.0
### For some reason we need to reset the branch ???
git reset --hard
git cherry-pick 10896
git cherry-pick cdb9c
git cherry-pick 24dbb

# In the same base directory from which you cloned OpenCV
cd ~/
git clone https://github.com/opencv/opencv_extra.git
cd ~/opencv_extra
git checkout -b v3.1.0 3.1.0

# From within : cd ~/opencv
cd ~/opencv
cmake \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=/usr \
    -DBUILD_PNG=OFF \
    -DBUILD_TIFF=OFF \
    -DBUILD_JPEG=OFF \
    -DBUILD_JASPER=OFF \
    -DBUILD_ZLIB=OFF \
    -DBUILD_EXAMPLES=ON \
    -DBUILD_opencv_java=OFF \
    -DBUILD_opencv_nonfree=OFF \
    -DBUILD_opencv_python=ON \
    -DWITH_OPENCL=OFF \
    -DWITH_OPENGL=ON \
    -DWITH_OPENMP=OFF \
    -DWITH_FFMPEG=ON \
    -DWITH_GSTREAMER=OFF \
    -DWITH_GSTREAMER_0_10=OFF \
    -DWITH_CUDA=ON \
    -D CUDA_FAST_MATH=1 \
    -D CUDA_NVCC_FLAGS="-D_FORCE_INLINES" \
    -D ENABLE_FAST_MATH=1 \
    -D WITH_CUBLAS=1 \
    -DWITH_GTK=ON \
    -DWITH_QT=ON \
    -DWITH_VTK=OFF \
    -DWITH_TBB=ON \
    -DWITH_V4L=ON \
    -DWITH_1394=OFF \
    -DWITH_OPENEXR=OFF \
    -DWITH_NVCUVID=ON \
    -DCUDA_TOOLKIT_ROOT_DIR=/usr/local/cuda \
    -DCUDA_ARCH_BIN="6.1" \
    -DCUDA_ARCH_PTX="6.1" \
    -DINSTALL_C_EXAMPLES=ON \
    -DINSTALL_TESTS=ON \
    -DOPENCV_TEST_DATA_PATH=../opencv_extra/testdata \
    ../opencv


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

#### Reboot to make all the changes take effect
sudo reboot




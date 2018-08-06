
Automatic script for setting up OpenCV 3.1.0 with CUDA 8 on Ubuntu 16.04
Tested on the following NVIDIA GFX adapters:
* GTX 680. 
* GTX 1080 Ti

Just install Ubuntu 16.04

Then do :
```
wget https://raw.githubusercontent.com/jarleven/CUDA-OpenCV/master/CUDA8-OpenCV310/install-CUDA-OpenCV.sh && chmod +x install-CUDA-OpenCV.sh
./install-CUDA-OpenCV.sh

Wait for the CUDA files to download, enter the root password. In the end, after OpenCV have compiled you will need to enter the root password again as it times out (at least on my computer).

```

Now go put on the coffe, then drink a few cups. Your PC will be busy the next hour or so at least.

The script will download CUDA-8 .deb files, install all required packges, clone OpenCV 3.1.0 patch OpenCV for CUDA set up the environment and so on. It will enable OpenGL support for the CUDA video reader (samples/GPU/video_reader.cpp)
In other workds save you a lot of manual work !

For cuDNN you also need to download a few files from NVIDIA and register a developer account on their pages.
https://developer.nvidia.com/rdp/cudnn-download


Things to try:
Inspired by work done here : http://poodar.me/Ubuntu-16.04-+-CUDA8.0-+-OpenCV-3.2.0-+-Anaconda-Python-3.6/
Video 4 Linux  -D WITH_V4L=ON \
-D BUILD_OPENCV_PYTHON3=ON \
-D CUDA_NVCC_FLAGS="-D_FORCE_INLINES" \

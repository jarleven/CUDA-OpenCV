
Automatic script for setting up OpenCV 3.1.0 with CUDA 8 on Ubuntu 16.04
Tested on Nvidia 
* GTX 680. 
* GTX 1080 Ti

Just install Ubuntu 16.04

Then do :
```
wget https://raw.githubusercontent.com/jarleven/CUDA-OpenCV/master/CUDA8-OpenCV310/install-CUDA-OpenCV.sh && chmod +x install-CUDA-OpenCV.sh
./install-CUDA-OpenCV.sh

```

Now go put on the coffe, then drink a few cups. Your PC will be busy the next hour or so at least.

The script will download CUDA-8 .deb files, install all required packges, clone OpenCV 3.1.0 patch OpenCV for CUDA set up the environment and so on. It will enable OpenGL support for the CUDA video reader (samples/GPU/video_reader.cpp)
In other workds save you a lot of manual work !

For cuDNN you also need to download a few files from Nvidia and register a developer account on their pages.


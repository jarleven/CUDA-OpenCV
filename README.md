# CUDA-OpenCV

Automatic script for setting up OpenCV with CUDA on Ubuntu

Following scripts are available in this repository:
* Automated install script for CUDA 8 and OpenCV 3.1.0 on Ubuntu 16.04  (Tested on GTX 680 and GTX 1080Ti)

```
wget https://raw.githubusercontent.com/jarleven/CUDA-OpenCV/master/CUDA8-OpenCV310/install-CUDA-OpenCV.sh && chmod +x install-CUDA-OpenCV.sh
./install-CUDA-OpenCV.sh
```


Some code for background subtraction and extraction of moving objects (Salmon detection is the goal) are being worked on.
Tensorflow will be used on the extracted cropped frames to identify if the moving object is a salmon.



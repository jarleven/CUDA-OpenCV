

A quick test to see if I can get OpenCV 3.4.2 working on CUDA 8

Got some of the hints from this page : http://www.python36.com/how-to-install-opencv340-on-ubuntu1604/

In case you have installed OpenCV already from source go to your current opencv folder and do "sudo make uninstall"
```
wget -O opencv.zip https://github.com/opencv/opencv/archive/3.4.2.zip
wget -O opencv_extra.zip https://github.com/opencv/opencv_contrib/archive/3.4.2.zip

unzip opencv.zip
opencv_extra.zip
mv opencv-3.4.2 opencv
mv opencv_contrib-3.4.2 opencv_extra

```

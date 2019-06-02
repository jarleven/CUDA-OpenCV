Motion detection using CUDA and accelerated video decoding.
Tested in OpenCV 3.1.0 / CUDA 8 / Ubuntu 16.04 (Installscript in this repository)

 * wget https://raw.githubusercontent.com/jarleven/CUDA-OpenCV/master/CUDA8-OpenCV310/install-CUDA-OpenCV.sh
 
## Download and compile the background subtraction program
You need to setup graphics divers and CUDA first.
```

cd ~/opencv/samples/gpu

wget https://raw.githubusercontent.com/jarleven/CUDA-OpenCV/master/BackgroundSubtractionCPP/background_subtraction.cpp

g++ -ggdb background_subtraction.cpp -o ~/background_subtraction `pkg-config --cflags --libs opencv` -I /usr/local/cuda/include/

```

Please note this is work in progress.

Process a video, find moving objects save moving objects to a 299x299pixels image for analysis in Tensorflow. The Tensorflow analysis is done in another process.


A mix of the following:
* opencv/samples/gpu/video_reader.cpp
* opencv/samples/cpp/bgfg_segm.cpp


Ideally everything should run accelerated in the GPU but some things are running in the CPU at the moment.

In case there is movement beyond a threshold we download the image to the CPU and do findContours() in the CPU.



At the time of writing 10minutes of video can be processed in 16 seconds on an NVIDIA GTX 1080 Ti

A video (realtime playback) of the background subtraction in action is available on YouTube:
https://www.youtube.com/watch?v=hSvo7JRpksI&list=PL6vyHeCsjuLHlRjYMd-YMICqimBUr4X3J



15000 frames of 1280x960pixels  (750 frames per second)
```
  Metadata:
    major_brand     : isom
    minor_version   : 512
    compatible_brands: isomiso2avc1mp41
    title           : RTSP Session
    encoder         : Lavf57.71.100
  Duration: 00:10:00.00, start: 0.000000, bitrate: 4450 kb/s
    Stream #0:0(und): Video: h264 (Main) (avc1 / 0x31637661), yuv420p, 1280x960, 4449 kb/s, 25 fps, 25 tbr, 12800 tbn, 50 tbc (default)
    Metadata:
      handler_name    : VideoHandler
```

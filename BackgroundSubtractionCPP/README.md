Motion detection using CUDA and accelerated video decoding.
Tested in OpenCV 3.1.0 / CUDA 8 / Ubuntu 16.04 (Installscript in this repository)


Please note this is work in progress.

Process a video, find moving objects save moving objects to a 240x240pixels image for analysis in Tensorflow. The Tensorflow analysis is done in another process.


A mix of the following:
* opencv/samples/gpu/video_reader.cpp
* opencv/samples/cpp/bgfg_segm.cpp


Ideally everything should run accelerated in the GPU but some things are running in the CPU at the moment.

In case there is movement beyond a threshold we download the image to the CPU and do findContours() in the CPU.



At the time of writing 10minutes of video can be processed in 20seconds on an NVIDIA GTX 1080 Ti

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

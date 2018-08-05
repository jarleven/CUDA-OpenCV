Motion detection using CUDA and accelerated video decoding.

Please note this is work in progress.

Process a video, find moving objects save moving objects to a 240x240pixels image for analysis in Tensorflow. The Tensorflow analysis is done in another process.


A mix of the 
* opencv/samples/gpu/video_reader.cpp
* opencv/samples/cpp/bgfg_segm.cpp


Ideally everything should run accelerated in the GPU but some things are running in the CPU at the moment.

In case there is movement beyond a threshold we download the image to the CPU and do findContours() in the CPU.




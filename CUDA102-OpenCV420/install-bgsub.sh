#!/bin/bash

cd ~/CUDA-OpenCV/BackgroundSubtractionCPP
rm -rf background_subtraction
g++ -ggdb background_subtraction.cpp -o background_subtraction `pkg-config --cflags --libs opencv4` -I /usr/local/cuda-10.1/include/

sudo mv background_subtraction /usr/bin/




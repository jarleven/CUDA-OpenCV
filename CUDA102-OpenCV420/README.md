# Automatic install script for OpenCV and TensorFlow



```
Ubuntu 18.04.4
OpenCV 4.2.0
CUDA 10.0
Python 3
cuDNN v7.6.4 (September 27, 2019), for CUDA 10.0
Tensorflow 2.0.0

The system have one GTX 1060 GPU if you have another GPU with another compute capability you have to modify the command below.
Link to the NVIDIA documentation for compute capability https://developer.nvidia.com/cuda-gpus

```

### To use the automatic script do the following.
```
Install Ubuntu 18.04
  Set login without password
  No proprietary drivers
  Don't download while installing (This script will do that anyway automatically)

Put a USB named CUDA with your cuDNN files into your PC. You need a developer login at NVIDIA to download the file.
TODO: Be a bit more helpfull :-)
The files should be in this folder (USB drive name CUDA and files inside the root folder CUDAFILES)
Install git and fire up the script with the command below
   Your PC will reboot multiple times and the process takes a long time.
   I suggest spending the next hours away from your computer :-)
```
```bash
ls /media/$USER/CUDA/CUDAFILES/
```

Please no not run this on any critical systems or any system containing important data. Test at your own risk preferably on a fresh installed system!

Installing the system
```bash

cd ~ && sudo apt install -y git && git clone https://github.com/jarleven/CUDA-OpenCV.git && cd CUDA-OpenCV/CUDA102-OpenCV420/ && ./statemachine.sh

```

Testing the install from remote ssh sesion
```bash
source ~/CUDA-OpenCV/CUDA102-OpenCV420/environmet.sh && cd /home/$USER/opencv/samples/gpu \
&& export DISPLAY=:0 \
&& g++ -ggdb video_reader.cpp -o video_reader `pkg-config --cflags --libs opencv4` -I /usr/local/cuda-10.1/include/ \
&& sudo cp video_reader /usr/bin/ \
&& cd ~ \
&& video_reader /media/$USER/CUDA/syd__2019-06-28__05-00-00.mp4


Environment not created, setting up now!

Results:
CPU : Avg : 2.70852 ms FPS : 369.205 Frames 22257
GPU : Avg : 0.158112 ms FPS : 6324.62 Frames 22257


```


## Custom object detector.
This repository also contain some work on how I build (work in progress) my custom fish detector. At the moment this use TensorFlow 1.15 as I could not get the training working on Tensorflow 2.x.x.

Annotated images of a salmon:

Create the dataset in the Tensorflow working directory:

Retraining with a model is as simple as:

```bash
cd ~/TensorFlow/workspace/training_demo
~/CUDA-OpenCV/CUDA102-OpenCV420/prepare-training.sh
 
```

Exporting the model:



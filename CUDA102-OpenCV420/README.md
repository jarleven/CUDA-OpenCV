New year, new relaeses and new possibilities

Trying CUDA 10.0 and OpenCV 4.2.0 on Ubuntu 18.04
```
Ubuntu 18.04.4
OpenCV 4.2.0
CUDA 10.0
Python 3
cuDNN - cuDNN v7.6.5 (November 18th, 2019), for CUDA 10.2
Tensorflow 2.0.0
```


```
Install Ubuntu 18.04
  Set login without password
  No proprietary drivers
  Don't download while installing (This script will do that anyway automatically)

Put a USB named CUDA with your cuDNN files into your PC

Install git and fire up the script with the command below
   Your PC will reboot multiple times and the process takes a long time.
   I suggest spending the next hours away from your computer :-)
```

```

cd ~ && sudo apt install -y git && git clone https://github.com/jarleven/CUDA-OpenCV.git && cd CUDA-OpenCV/CUDA102-OpenCV420/ && ./setup

```

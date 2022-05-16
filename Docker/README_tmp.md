### Ubuntu users on the Fileserver
```
sudo useradd -m mrtroll
sudo usermod -s /bin/bash mrtroll


IP addr 192.168.1.199  Mellanox 10Gbit 00:02:c9:4f:5b:94

IP addr 192.168.1.165  Mellanox 10Gbit 00:02:c9:4e:1e:7c
  

```

### Colab and Roboflow - Custom object detection model
```

https://colab.research.google.com/github/roboflow-ai/yolov5-custom-training-tutorial/blob/main/yolov5-custom-training.ipynb

https://roboflow.com/


https://github.com/ultralytics/yolov5/wiki/Docker-Quickstart

sudo docker run --ipc=host -it --gpus all ultralytics/yolov5:latest


sudo docker run --ipc=host -it  --gpus all -v "$(pwd)"/modeldir:/usr/ ultralytics/yolov5:latest

python detect.py --weights yolov5s.pt --source path/to/images



ERROR: pip's dependency resolver does not currently take into account all the packages that are installed. This behaviour is the source of the following dependency conflicts.
google-colab 1.0.0 requires requests~=2.23.0, but you have requests 2.25.1 which is incompatible.
datascience 0.10.6 requires folium==0.2.1, but you have folium 0.8.3 which is incompatible.
albumentations 0.1.12 requires imgaug<0.2.7,>=0.2.5, but you have imgaug 0.2.9 which is incompatible.

```

### Run YOLOv5 locally in Docker
```
sudo docker run --ipc=host -it  --gpus all -v /home/jarleven/test:/model ultralytics/yolov5:latest

python detect.py --weights /model/Aleks.pt --source /model/bilder


# Make some folders locally on your PC
mkdir $HOME/test
mkdir $HOME/test/images

# Copy the model and some images or videos to the home/test/images folder
#
# cp *.pt  $HOME/test
# cp *.png *.mp4 *.jpg $HOME/test/images


sudo docker run --ipc=host -it  --gpus all -v $HOME/test:/model ultralytics/yolov5:latest

# Alternative - Pass the display to Docker. You can then run X applications from inside Docker.
sudo xhost +local:root;
sudo docker run --ipc=host -it  --gpus all -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix:rw -v $HOME/test:/model ultralytics/yolov5:latest

# Results saved to runs/detect/exp

feh -F  --auto-zoom --slideshow-delay 1 runs/detect/exp
# q to quit feh  (Light weight image viewer)


```

### Utilities and non AI stuff
```

https://mlhive.com/2022/02/read-and-write-pascal-voc-xml-annotations-in-python

from pascal_voc_writer import Writer

# create pascal voc writer (image_path, width, height)
writer = Writer('path/to/img.jpg', 800, 598)

# add objects (class, xmin, ymin, xmax, ymax)
writer.addObject('truck', 1, 719, 630, 468)
writer.addObject('person', 40, 90, 100, 150)

# write to file
writer.save('path/to/img.xml'),


```



### Installing Docker and the NVIDIA Container Toolkit
```
# https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/install-guide.html#docker


sudo apt update
sudo apt upgrade -y
sudo apt install -y curl vim git

# For older versions of Ubuntu
sudo add-apt-repository ppa:graphics-drivers/ppa -y
sudo apt update
# To search for available drivers
apt search nvidia-driver 
sudo apt install nvidia-driver-510 -y
# ( For a headless system sudo apt install nvidia-headless-510 -y  )


git clone https://github.com/NVIDIA/object-detection-tensorrt-example.git

curl https://get.docker.com | sh && sudo systemctl --now enable docker

# Test Docker
sudo docker run hello-world


# Add the NVIDIA Toolkit to the APT sources list
distribution=$(. /etc/os-release;echo $ID$VERSION_ID) \
      && curl -s -L https://nvidia.github.io/libnvidia-container/gpgkey | sudo apt-key add - \
      && curl -s -L https://nvidia.github.io/libnvidia-container/$distribution/libnvidia-container.list | sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list
      
      
sudo apt update

sudo apt install -y nvidia-docker2
sudo systemctl restart docker

# Test the NVIDIA Container Toolkit
sudo docker run --rm --gpus all nvidia/cuda:11.0-base nvidia-smi

# After aquiering the NGC license key you can download and run the NGC deep learning Docker image

sudo docker run --gpus all -it --rm nvcr.io/nvidia/tensorflow:22.03-tf2-py3



#
#  --gpus
#   -it

#  --rm
#  --name

#   -e
#   -v
#
#  --ipc
#  --ulimit memlock=-1
#  --ulimit stack=
#

#  --net

 

 #   sudo    : admin privilages
 #   docker  : calling docker which we installed earlier
 #   run     : asking docker to run the image which we will describe ahead
 #   — — runtime=nvidia : initiating the layer of nvidia-docker (installed earlier)
 #   -it     : this will keep the container interactive, will allow us to write/edit commands inside the container.
 #   -d       : represents detach mode, meaning it will print the container ID and container will be running in background, which we will access it afterwards.
 #   -e DISPLAY=$DISPLAY : is to set environmental variables, meaning giving container the path to DISPLAY in a same fashion our ubuntu uses display.
 #   — — name=dst : it is the name of your container, I have used ‘Thor’, you can use what ever you like BlackWidow, KhalDrogo, NightKing are all good names.
 #   -v $HOME/Documents/DS_computer_vision/:/home/ : This ‘-v’ helps us to mount the directory from our host system inside the container, syntax is something like HOST MACHINE ADDR(documents/DS_computer_vision):ADDR INSIDE CONTAINER(/home/). And since we know the container is following ubuntu kernel, there would be a folder name home. so all our files will be mounted inside home folder of container and I feel very comfortable working with this as there is no place like HOME.
 #   — — net=host : this lets the container to communicate through internet on all ports , you can restrict it by using -p publish command. but its not worth it so dont try.
 #   — — gpus=all : helps NVIDIA-DOCKER to access to all gpus on your machine, and since before all this docker you have installed NVIDIA_DRIVERS AND CUDA , this helps our container to see the Gpu on your machine.
    nvcr.io/nvidia/deepstream:5.1-21.02-triton : Last but not least is the name of the main DEEPSTREAM image which will be now converted to container name — ‘dst’.


sudo docker run --runtime=nvidia -it -d -e DISPLAY=$DISPLAY --name Thor -v $HOME/Documents/DS_computer_vision/:/home/ --net=host --gpus all nvcr.io/nvidia/deepstream:5.1-21.02-triton





```



### XEyes and GLX Gears
```   

# Allow Docker containers access to the display
sudo xhost +local:root;

# Start the container
sudo docker run --gpus all -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix:rw  -it --rm nvcr.io/nvidia/tensorflow:22.03-tf2-py3

# Fix the memory warning
sudo docker run --gpus all --ipc=host --ulimit memlock=-1 --ulimit stack=67108864 -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix:rw  -it --rm nvcr.io/nvidia/tensorflow:22.03-tf2-py3


# From inside the container install and run XEyes:
apt update && apt install -qqy x11-apps && xeyes

# Some 3D rendering with GLX Gears
apt install mesa-utils
glxgears

```

### Camera Eidselva
```

rtsp://192.168.1.87:554/user=admin&password=&channel=0&stream=0.sdp?real_stream

rtsp://192.168.1.170:554/user=admin&password=&channel=0&stream=0.sdp?real_stream


```


### Tesla K80
```   

wget https://us.download.nvidia.com/tesla/470.103.01/NVIDIA-Linux-x86_64-470.103.01.run

chmod +x NVIDIA-Linux-x86_64-470.103.01.run
sudo sh NVIDIA-Linux-x86_64-470.103.01.run


https://volkovlabs.com/we-tried-pytorch-in-docker-container-with-nvidia-gpu-support-on-google-cloud-5e30c49d9864


BIOS "Above 4GB Decoding" must be enabled!

sudo apt-get install nvidia-headless-470-server nvidia-utils-470-server nvidia-container-runtime nvidia-container-toolkit nvidia-docker2

sudo apt-get install -y nvidia-driver-510-server
sudo systemctl restart docker


https://docs.nvidia.com/datacenter/tesla/tesla-installation-notes/index.html

jarleven@tesla:~$ nvidia-smi
Thu May 12 06:59:49 2022
+-----------------------------------------------------------------------------+
| NVIDIA-SMI 470.103.01   Driver Version: 470.103.01   CUDA Version: 11.4     |
|-------------------------------+----------------------+----------------------+
| GPU  Name        Persistence-M| Bus-Id        Disp.A | Volatile Uncorr. ECC |
| Fan  Temp  Perf  Pwr:Usage/Cap|         Memory-Usage | GPU-Util  Compute M. |
|                               |                      |               MIG M. |
|===============================+======================+======================|
|   0  Tesla K80           Off  | 00000000:03:00.0 Off |                    0 |
| N/A   34C    P0    54W / 149W |      0MiB / 11441MiB |      0%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+
|   1  Tesla K80           Off  | 00000000:04:00.0 Off |                    0 |
| N/A   40C    P0    74W / 149W |      0MiB / 11441MiB |    100%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+

+-----------------------------------------------------------------------------+
| Processes:                                                                  |
|  GPU   GI   CI        PID   Type   Process name                  GPU Memory |
|        ID   ID                                                   Usage      |
|=============================================================================|
|  No running processes found                                                 |
+-----------------------------------------------------------------------------+


GPU Name
GK210
GPU Variant
GK210-885-A1
Architecture
Kepler 2.0


https://docs.nvidia.com/deeplearning/frameworks/support-matrix/index.html
https://catalog.ngc.nvidia.com/orgs/nvidia/containers/pytorch

"Release 21.10 is based on NVIDIA CUDA 11.4.2 with cuBLAS 11.6.5.2, which requires NVIDIA Driver release 470 or later."
docker pull nvcr.io/nvidia/pytorch:21.10-py3

docker pull nvcr.io/nvidia/pytorch:17.12


apt install -y git
git clone https://github.com/ultralytics/yolov5.git

 cd yolov5
 pip install -r requirements.txt

```   



### Credits
```   

https://medium.com/mlearning-ai/computer-vision-ai-in-production-using-nvida-deepstream-6c90d3daa8a5

```   

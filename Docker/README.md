### 2022 Testing the NVIDIA Docker images



### Stopping containers and cleaning up your environment
```
https://typeofnan.dev/how-to-stop-all-docker-containers/


```

#### First look

```


https://developer.nvidia.com/blog/object-detection-gpus-10-minutes/?tags=&categories=computer-vision
https://catalog.ngc.nvidia.com/orgs/nvidia/containers/tensorflow
https://docs.nvidia.com/deeplearning/frameworks/support-matrix/index.html

```
```
Ubuntu 21.04.4
NVIDIA 510 driver




https://docs.nvidia.com/deeplearning/frameworks/tensorflow-release-notes/running.html

https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/install-guide.html#docker


docker pull nvcr.io/nvidia/tensorflow:22.03-tf2-py3


sudo docker run --gpus all -it --rm nvcr.io/nvidia/tensorflow:22.03-tf2-py3


```

### Installing Docker and the NVIDIA Container Toolkit
```
# https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/install-guide.html#docker


sudo apt update
sudo apt upgrade -y
sudo apt install -y curl vim git

git clone https://github.com/NVIDIA/object-detection-tensorrt-example.git

curl https://get.docker.com | sh && sudo systemctl --now enable docker

# Test Docker
sudo docker run hello-world



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

```

```
cd ~/object....
cd dockerfiles
docker build -t object_detection_webcam . # don’t forget the period at the end

```

### Ubuntu / Jupyter
```
Evheniy Bystrov made a post we might use as a quick introduction

https://towardsdatascience.com/tensorflow-object-detection-with-docker-from-scratch-5e015b639b0b


git clone -b r13.0.0 https://github.com/tensorflow/models.git /tensorflow/models




FROM "ubuntu:bionic"
RUN apt-get update && yes | apt-get upgrade
RUN mkdir -p /tensorflow/models
RUN apt-get install -y git python-pip
RUN pip install --upgrade pip
RUN pip install tensorflow
RUN apt-get install -y protobuf-compiler python-pil python-lxml
RUN pip install jupyter
RUN pip install matplotlib
#RUN git clone -b r1.13.0 https://github.com/tensorflow/models.git /tensorflow/models
RUN git clone -b v1.4.0 https://github.com/tensorflow/models.git ~/tensorflow/models

WORKDIR /tensorflow/models/research
RUN protoc object_detection/protos/*.proto --python_out=.
RUN export PYTHONPATH=$PYTHONPATH:`pwd`:`pwd`/slim
RUN jupyter notebook --generate-config --allow-root
RUN echo "c.NotebookApp.password = u'sha1:6a3f528eec40:6e896b6e4828f525a6e20e5411cd1c8075d68619'" >> /root/.jupyter/jupyter_notebook_config.py
EXPOSE 8888
CMD ["jupyter", "notebook", "--allow-root", "--notebook-dir=/tensorflow/models/research/object_detection", "--ip=0.0.0.0", "--port=8888", "--no-browser"]



```

### Tensorflow 2.0.8 Jupyter
```
sudo docker pull tensorflow/tensorflow:2.8.0-gpu-jupyter


docker run --name tensorflow: -p 8888:8888 -d tensorflow

```   
```   
https://medium.com/@horczech/how-to-setup-tensorflow-object-detection-api-using-docker-cc9d4b3a1eef


docker build -f research/object_detection/dockerfiles/tf2/Dockerfile -t od .

docker run -it od



https://tensorflow-object-detection-api-tutorial.readthedocs.io/en/2.2.0/install.html

wget https://tensorflow-object-detection-api-tutorial.readthedocs.io/en/2.2.0/_downloads/7dbbdbf71c3c2b2b95d1be96108eb15b/plot_object_detection_simple.py


docker run -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix

sudo docker run --gpus all -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix -it od


```   

### Tensorflow test
```   
python -c 'import tensorflow as tf; print(tf.__version__)'  # for Python 2
python3 -c 'import tensorflow as tf; print(tf.__version__)'  # for Python 3

python -c 'import platform; print("Python version :", platform.python_version())'

```   

### XEyes
```   
# https://medium.com/@pigiuz/hw-accelerated-gui-apps-on-docker-7fd424fe813e
xhost +local:root; \
docker run -d \
-e DISPLAY=$DISPLAY \
-v /tmp/.X11-unix:/tmp/.X11-unix:rw \
ubuntu:latest \
sh -c 'apt-get update && apt-get install -qqy x11-apps && xeyes'




# Allow Docker containers access to the display
sudo xhost +local:root;
# Start the container
sudo docker run --gpus all -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix:rw  -it --rm nvcr.io/nvidia/tensorflow:22.03-tf2-py3

# From inside the container run:
apt-get update && apt-get install -qqy x11-apps && xeyes

# Some 3D rendering
apt install mesa-utils
glxgears

```   

```   

https://medium.com/mlearning-ai/computer-vision-ai-in-production-using-nvida-deepstream-6c90d3daa8a5


git clone https://github.com/deep28vish/DeepStream.git

sudo docker run --runtime=nvidia -it -d -e DISPLAY=$DISPLAY --name Thor -v $HOME/Documents/DS_computer_vision/:/home/ --net=host --gpus all nvcr.io/nvidia/deepstream:5.1-21.02-triton

sudo xhost +local:root;
sudo nvidia-docker exec -it Thor bash


root@DockerGPU:/hei# /opt/nvidia/deepstream/deepstream-5.1/bin/deepstream-app -c deep_stream_1_feed_3_classification.txt --tiledtext


```   
|

### X11 / Display - in non sorted order
|```   
https://forums.developer.nvidia.com/t/the-deepstream-image-nvcr-io-nvidia-deepstream-l4t-5-1-21-02-samples-pulled-from-ngc-to-my-nvidia-nx-failed-to-start-any-application/179021/26?page=2

GLX Gears
https://github.com/NVIDIA/nvidia-docker/issues/586
```

### YOLOv5
```
https://www.forecr.io/blogs/ai-algorithms/how-to-run-yolov5-real-time-object-detection-on-pytorch-with-docker-on-nvidia-jetson-modules
```


### Study hard
```
https://medium.com/mlearning-ai/multiple-object-detection-using-nvidias-transfer-learning-toolkit-e7cfc1b5a381
```

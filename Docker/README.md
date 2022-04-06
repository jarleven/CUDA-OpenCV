### 2022 Testing the NVIDIA Docker images

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
docker run hello-world



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


```

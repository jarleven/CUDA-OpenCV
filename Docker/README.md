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

https://ngc.nvidia.com/setup/api-key



https://docs.nvidia.com/deeplearning/frameworks/tensorflow-release-notes/running.html

https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/install-guide.html#docker


docker pull nvcr.io/nvidia/tensorflow:22.03-tf2-py3


docker run --gpus all -it --rm nvcr.io/nvidia/tensorflow:22.03-tf2-py3


```


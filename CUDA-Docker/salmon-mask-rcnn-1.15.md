

#### The balloon files
```bash

wget https://github.com/matterport/Mask_RCNN/releases/download/v2.1/balloon_dataset.zip
unzip balloon_dataset.zip 

wget https://github.com/matterport/Mask_RCNN/releases/download/v2.1/mask_rcnn_balloon.h5
```

#### Setup the Docker environment on Ubuntu 20.04 / Nvidia GPU
```bash
https://github.com/jarleven/CUDA-OpenCV/blob/master/CUDA-Docker/README.md
```

#### Pull the container
```bash
docker pull nvidia/cuda:10.0-cudnn7-devel-ubuntu18.04
```



#### Tensorflow versions vs CUDA and cuDNN 
From https://www.tensorflow.org/install/source#gpu
```bash

Version			Python version	Compiler	Build tools	cuDNN	CUDA
--------------------------------------------------------------------------------------
tensorflow_gpu-1.15.0	2.7, 3.3-3.7	GCC 7.3.1	Bazel 0.26.1	7.4	10.0

```


#### Run the container
```bash

sudo docker run --runtime=nvidia --shm-size=1g --ulimit memlock=-1 --ulimit stack=67108864 --env CUDA_VISIBLE_DEVICES='1' -it -p 8888:8888 -p 6006:6006 -v ~/:/host nvidia/cuda:10.0-cudnn7-devel-ubuntu18.04
```



#### Starting and reataching to Docker image

```bash
docker image ls
REPOSITORY    TAG                             IMAGE ID       CREATED       SIZE
nvidia/cuda   10.0-cudnn7-devel-ubuntu18.04   510a4b73cab1   4 weeks ago   3.02GB
nvidia/cuda   8.0-cudnn6-devel-ubuntu16.04    3ddfbacc17c3   8 weeks ago   2.02GB
```

```bash
docker exec -it blissful_driscoll /bin/bash 
```



#### First time setup of the balloon splash with salmon splash and GPU modifications
Basically this is https://github.com/matterport/Mask_RCNN with a few modifications
```bash
apt update
apt install -y wget

wget https://raw.githubusercontent.com/jarleven/CUDA-OpenCV/master/CUDA-Docker/setup-1.15.sh
chmod +x setup-1.15.sh 
./setup-1.15.sh
```

#### Train and test
Some effort need to be put into merging this. Difference is mostly due to VIA vs Labelme annotation
```bash


python3 labelme_1.15.py train --dataset=/host/JsonDataset/ --weights=coco
python3 labelme_1.15.py train --dataset=/host/JsonDataset/ --weights=imagenet

python3 labelme_1.15.py test --weights=/Mask_RCNN/logs/mmodel20210731T2111 --image=/host/Notes/SalmonModel/00013.jpg --classnum=1
python3 balloon.py splash --weights=/Mask_RCNN/logs/mmodel20210731T2111/mask_rcnn_mmodel_0030.h5 --image=/host/Notes/SalmonModel/00013.jpg 



```


#### Testing multiple images and copying to laptop

```bash
for f in /host/Notes/SalmonModel/*.jpg; do echo "Processing $f file.."; done

for f in /host/Notes/SalmonModel/*.jpg; do python3 labelme_1.15.py test --weights=/host/mask_rcnn --image=$f --classnum=1; done

rsync --ignore-existing -v 192.168.1.116:~/Notes/SalmonModel/*.png .
```


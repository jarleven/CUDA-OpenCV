


The balloon files
```

wget https://github.com/matterport/Mask_RCNN/releases/download/v2.1/balloon_dataset.zip
unzip balloon_dataset.zip 

wget https://github.com/matterport/Mask_RCNN/releases/download/v2.1/mask_rcnn_balloon.h5
```

```
docker pull nvidia/cuda:10.0-cudnn7-devel-ubuntu18.04
```

```

From https://www.tensorflow.org/install/source#gpu
Version			Python version	Compiler	Build tools	cuDNN	CUDA
--------------------------------------------------------------------------------------
tensorflow_gpu-1.15.0	2.7, 3.3-3.7	GCC 7.3.1	Bazel 0.26.1	7.4	10.0
```


#### Run the container
```

sudo docker run --runtime=nvidia --shm-size=1g --ulimit memlock=-1 --ulimit stack=67108864 --env CUDA_VISIBLE_DEVICES='1' -it -p 8888:8888 -p 6006:6006 -v ~/:/host nvidia/cuda:10.0-cudnn7-devel-ubuntu18.04
```
#### Reconnect to the container
Find the docker name with docker stats
```
docker exec -it keen_poitras /bin/bash 
```

#### This is the https://github.com/matterport/Mask_RCNN with minimal changes
```

apt update
apt install -y python3 python3-pip git vim
pip3 install --upgrade pip
git clone https://github.com/matterport/Mask_RCNN
cd Mask_RCNN

 
!!!!!!!!!
vi requirements.txt # Edit as required

pip3 install -r requirements.txt
python3 setup.py install

cp /host/mask_rcnn_balloon.h5 .


cd samples/balloon/
python3 balloon.py train --dataset=/host/balloon --weights=coco
```

#### The requirements used. Thanks to @mansi-aggarwal-2504
```

cat requirements.txt 
numpy
scipy
Pillow
cython
matplotlib
scikit-image
h5py==2.10.0
tensorflow==1.15
tensorflow-gpu==1.15.0
keras==2.1.6
opencv-python
imgaug
IPython[all]
```

```
TODO link to this tip
@mansi-aggarwal-2504
Hey
I trained my model and visualized the data.
My training was held on June 3, 2021.
I used:

pip uninstall keras-nightly
pip uninstall -y tensorflow
h5py==2.10.0
tensorflow==1.15
tensorflow-gpu==1.15.0
keras==2.1.6
```







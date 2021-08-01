#### Setup Docker / Nvidia environment
https://github.com/jarleven/CUDA-OpenCV/blob/master/CUDA-Docker/README.md



docker pull nvidia/cuda:10.1-cudnn7-devel-ubuntu18.04


sudo docker run --runtime=nvidia --shm-size=1g --ulimit memlock=-1 --ulimit stack=67108864 --env CUDA_VISIBLE_DEVICES='1' -it -v ~/:/host nvidia/cuda:10.1-cudnn7-devel-ubuntu18.04

apt update && apt install -y git vim wget

apt install -y python3 python3-pip git vim
apt install -y libgl1-mesa-glx

pip3 install --upgrade pip

pip3 install -r requirements.txt
python3 setup.py install


git clone https://github.com/ahmedfgad/Mask-RCNN-TF2.git



!!! WORKS on GTX1080Ti (RTX2070 probably ran out of memory) 

python3 balloon.py train --dataset=/host/balloon --weights=coco
python3 labelme_1.15.py train --dataset=/host/JsonDataset/ --weights=coco

for f in /host/Notes/SalmonModel/*.jpg; do python3 labelme_1.15.py test --weights=/host/mask_rcnn_coco_tf22_01082021 --image=$f --classnum=1; done

 /host/mask_rcnn_coco_tf22_01082021/mask_rcnn_mmodel_0030.h5


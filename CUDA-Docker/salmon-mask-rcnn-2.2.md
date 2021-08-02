#### Setup Docker / Nvidia environment
https://github.com/jarleven/CUDA-OpenCV/blob/master/CUDA-Docker/README.md



docker pull nvidia/cuda:10.1-cudnn7-devel-ubuntu18.04


sudo docker run --runtime=nvidia --shm-size=1g --ulimit memlock=-1 --ulimit stack=67108864 --env CUDA_VISIBLE_DEVICES='1' -it -v ~/:/host nvidia/cuda:10.1-cudnn7-devel-ubuntu18.04


#### Show all docker containers (Only running without -a all)
docker ps -a

# root@26b690b8b7d8:/Mask-RCNN-TF2/samples/balloon# Connection to 192.168.1.116 closed by remote host.
```bash
docker exec -it dreamy_montalcini /bin/bash 


docker restart dreamy_montalcini  	# After host reboot or user stop	

docker exec -it dreamy_montalcini /bin/bash

```


docker ps -a
CONTAINER ID   IMAGE                                       COMMAND       CREATED        STATUS                           PORTS     NAMES
26b690b8b7d8   nvidia/cuda:10.1-cudnn7-devel-ubuntu18.04   "bash"        7 hours ago    Exited (0) About an hour ago               dreamy_montalcini
870b8bedec4a   nvidia/cuda:10.0-cudnn7-devel-ubuntu18.04   "bash"        8 hours ago    Exited (0) 7 hours ago                     brave_goldberg
68123b72ceb8   nvidia/cuda:10.0-cudnn7-devel-ubuntu18.04   "bash"        8 hours ago    Created                                    kind_dirac
2fc1a16c1d07   nvidia/cuda:10.0-cudnn7-devel-ubuntu18.04   "bash"        26 hours ago   Exited (0) About an hour ago               blissful_driscoll
692376b62c62   nvidia/cuda:10.0-cudnn7-devel-ubuntu18.04   "bash"        26 hours ago   Created                                    hungry_gagarin
ba3f142eefbc   nvidia/cuda:10.0-cudnn7-devel-ubuntu18.04   "bash"        30 hours ago   Exited (129) About an hour ago             keen_poitras
9f5ccf4de744   nvidia/cuda:10.0-cudnn7-devel-ubuntu18.04   "bash"        30 hours ago   Exited (0) 30 hours ago                    awesome_blackburn
0ce8438368a7   nvidia/cuda:8.0-cudnn6-devel-ubuntu16.04    "/bin/bash"   31 hours ago   Exited (1) 30 hours ago                    loving_shannon



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

for f in /host/Notes/SalmonModel/*.jpg; do python3 labelme_1.15.py test --weights=/logdir/train/mask_rcnn_mmodel_0030.h5 --image=$f --classnum=1; done

for f in /host/Notes/SalmonModel/*.jpg; do python3 labelme_1.15.py test --weights=/logdir/train/mask_rcnn_mmodel_0030.h5 --image=$f --classnum=1; done


 /host/mask_rcnn_coco_tf22_01082021/mask_rcnn_mmodel_0030.h5


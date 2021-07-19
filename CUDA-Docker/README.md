### Modified guide for running the "Retrain an object detection model" demo on Nvidia GPUs

https://coral.ai/docs/edgetpu/retrain-detection/#run-the-model




CORAL_DIR=${HOME}/google-coral && mkdir -p ${CORAL_DIR}
cd ${CORAL_DIR}
git clone https://github.com/google-coral/tutorials.git
cd tutorials/docker/object_detection
DETECT_DIR=${PWD}/out && mkdir -p $DETECT_DIR

vi Dockerfile
#FROM tensorflow/tensorflow:1.15.5
FROM nvcr.io/nvidia/tensorflow:21.06-tf1-py3


# Copy the backup files to the docker directory so we can reach them inside
mkdir ~/google-coral/tutorials/docker/object_detection/out/tmp
cp ~/fileArchive/pet/*.tar.gz ~/google-coral/tutorials/docker/object_detection/out/tmp/


docker build . -t detect-tutorial-tf1





cd $HOME/google-coral/tutorials/docker/object_detection
DETECT_DIR=${PWD}/out


docker run --runtime=nvidia --shm-size=1g --ulimit memlock=-1 --ulimit stack=67108864 --name edgetpu-detect --rm -it --privileged -p 6006:6006 --mount type=bind,src=${DETECT_DIR},dst=/tensorflow/models/research/learn_pet detect-tutorial-tf1



vi prepare_checkpoint_and_dataset.sh 
# ************************************************
# Edit root@9a1eeaeb326e:/tensorflow/models/research# vi prepare_checkpoint_and_dataset.sh 


mkdir -p "${LEARN_DIR}"
cd "${LEARN_DIR}"

cp /tensorflow/models/research/learn_pet/tmp/ssd_mobilenet_v1_quantized_300x300_coco14_sync_2018_07_18.tar.gz .

mkdir -p "${DATASET_DIR}"
cd "${DATASET_DIR}"
cp /tensorflow/models/research/learn_pet/tmp/annotations.tar.gz .
cp /tensorflow/models/research/learn_pet/tmp/images.tar.gz .


****************************************


./prepare_checkpoint_and_dataset.sh --network_type mobilenet_v1_ssd --train_whole_model true






# DETTE HAR EFFEKT  / det er device 0 og 1, men med linja under blir det kun device 0
#    device: 0, name: NVIDIA GeForce RTX 2070 SUPER, pci bus id: 0000:01:00.0, compute capability: 7.5)
     device: 0, name: NVIDIA GeForce GTX 1080 Ti, pci bus id: 0000:04:00.0, compute capability: 6.1)

#
#
!!!! CUDA_
export NVIDIA_VISIBLE_DEVICES='1'


NUM_TRAINING_STEPS=50000 && NUM_EVAL_STEPS=2000

rm -rf learn_pet/train/*

./retrain_detection_model.sh \
--num_training_steps ${NUM_TRAINING_STEPS} \
--num_eval_steps ${NUM_EVAL_STEPS}






*********************************************************
vi object_detection/model_main.py


from tensorflow import ConfigProto
from tensorflow import InteractiveSession

config = ConfigProto()
config.gpu_options.allow_growth = True
session = InteractiveSession(config=config)


# Sansynlegvis ingen effekt		
#import os
#os.environ["CUDA_DEVICE_ORDER"]="PCI_BUS_ID"
#os.environ["CUDA_VISIBLE_DEVICES"]="0,2,3,4"

		
		
******************************************


vi learn_pet/ckpt/pipeline.config 

batch_size in pipeline.config
RTX 2070 : ??	
GTX 1080 : 16 ser ut som det virkar  (Etter start satt til 20)

rm learn_pet/train/*

NUM_TRAINING_STEPS=50000 && NUM_EVAL_STEPS=2000
NUM_TRAINING_STEPS=50000 && NUM_EVAL_STEPS=5000

./retrain_detection_model.sh --num_training_steps ${NUM_TRAINING_STEPS} --num_eval_steps ${NUM_EVAL_STEPS}






sudo docker exec -it edgetpu-detect /bin/bash
		tensorboard --logdir=./learn_pet/train/	









scp 192.168.1.116:/home/jarleven/fileArchive/pet/annotations.tar.gz .
scp 192.168.1.116:/home/jarleven/fileArchive/pet/images.tar.gz .
scp 192.168.1.116:/home/jarleven/fileArchive/pet/ssd_mobilenet_v1_quantized_300x300_coco14_sync_2018_07_18.tar.gz .




# Preparation


annotations.tar.gz
images.tar.gz
ssd_mobilenet_v1_quantized_300x300_coco14_sync_2018_07_18.tar.gz
jarleven@MediaGPU:~/fileArchive/pet$ pwd


Copy the backup files to the docker directory so we can reach them inside
mkdir ~/google-coral/tutorials/docker/object_detection/out/tmp
cd ~/google-coral/tutorials/docker/object_detection/out/tmp
cp ~/fileArchive/pet/*.tar.gz .


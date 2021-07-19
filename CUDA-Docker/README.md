### Modified guide for running the "Retrain an object detection model" demo on Nvidia GPUs

https://coral.ai/docs/edgetpu/retrain-detection/#run-the-model


#### The reason for some of the changes is related to the the following errors/crash scenarios
```
Allocator (GPU_0_bfc) ran out of memory trying to allocate	
```

```bash

CORAL_DIR=${HOME}/google-coral && mkdir -p ${CORAL_DIR}
cd ${CORAL_DIR}
git clone https://github.com/google-coral/tutorials.git
cd tutorials/docker/object_detection
DETECT_DIR=${PWD}/out && mkdir -p $DETECT_DIR

```

#### Modify the dockerfile, use a container with GPU support
Note that the other changes done later might allow for using original Tensorflow-gpu images

Edith the dockerfile with your favourite editor
```bash
vi Dockerfile
```
```python
#FROM tensorflow/tensorflow:1.15.5
FROM nvcr.io/nvidia/tensorflow:21.06-tf1-py3
```

#### Build the container
```bash
docker build . -t detect-tutorial-tf1
```


#### Run the container
```bash

docker run --runtime=nvidia --shm-size=1g --ulimit memlock=-1 --ulimit stack=67108864 \
           --name edgetpu-detect --rm -it --privileged -p 6006:6006 \
	   --mount type=bind,src=${DETECT_DIR},dst=/tensorflow/models/research/learn_pet detect-tutorial-tf1
```

#### In my setup I have a RTX2070 and a GTX 1080
```
device: 0, name: NVIDIA GeForce RTX 2070 SUPER, pci bus id: 0000:01:00.0, compute capability: 7.5
device: 1, name: NVIDIA GeForce GTX 1080 Ti, pci bus id: 0000:04:00.0, compute capability: 6.1
```

To select the GTX1080 only run the following command
```bash

export CUDA_VISIBLE_DEVICES='1'

```


```bash

./prepare_checkpoint_and_dataset.sh --network_type mobilenet_v1_ssd --train_whole_model true

```


#### Edit the model_main.py file
```bash
vi object_detection/model_main.py
```
Add the following, below line 23 is probably good
```python

from tensorflow import ConfigProto
from tensorflow import InteractiveSession

config = ConfigProto()
config.gpu_options.allow_growth = True
session = InteractiveSession(config=config)
```

#### Modify the batch_size in pipeline.config(16 or 20 worked for me)
```bash
vi learn_pet/ckpt/pipeline.config 
```
```
#  batch_size: 128
   batch_size: 16
```

```

#### Start training
```bash
NUM_TRAINING_STEPS=50000 && NUM_EVAL_STEPS=2000

# To rerun the training first delete the contents of the train folder
rm -rf learn_pet/train/*

./retrain_detection_model.sh \
--num_training_steps ${NUM_TRAINING_STEPS} \
--num_eval_steps ${NUM_EVAL_STEPS}
```

#### Follow the progress in tensorboard
```bash
sudo docker exec -it edgetpu-detect /bin/bash
```

```bash
tensorboard --logdir=./learn_pet/train/
```

#!/bin/bash


#
# ERROR: tensorboard 1.15.0 has requirement setuptools>=41.0.0, but you'll have setuptools 39.0.1 which is incompatible.
#
# ERROR: astroid 2.3.3 has requirement wrapt==1.11.*, but you'll have wrapt 1.12.1 which is incompatible.
#

# http://docs.brew.sh
# Warning: /home/linuxbrew/.linuxbrew/bin is not in your PATH.
# /usr/bin/brew: 78: exec: /home/jarleven/.linuxbrew/bin/brew: not found









# Install some packages
sudo apt install -y git ssh build-essential linuxbrew-wrapper

# Install PIP for Python 3
sudo apt install -y python3-pip
python3 -m pip install --upgrade --user pip
sudo apt install -y python3-testresources

# brew install protobuf


echo 'export PYTHONPATH="${PYTHONPATH:+${PYTHONPATH}:}$HOME/TensorFlow/models/research/object_detection:$HOME/TensorFlow/models/research:$HOME/TensorFlow/models/research/slim"' >> ~/.bash_profile

# 
# "export PYTHONPATH=$PYTHONPATH:`pwd`:`pwd`/slim"     is done above
# Print-working-directory pwd should be done from within the TensorFlow/models/research/ folder according the guides.

echo 'export PATH="${PATH:+${PATH}:}$HOME/.local/bin:/home/linuxbrew/.linuxbrew/bin"' >> ~/.bash_profile

echo 'export MANPATH="${MANPATH:+${MANPATH}:}/home/linuxbrew/.linuxbrew/share/man"' >> ~/.bash_profile

echo 'export INFOPATH="${INFOPATH:+${INFOPATH}:}/home/linuxbrew/.linuxbrew/share/info"' >> ~/.bash_profile

source ~/.bash_profile


#sudo apt install -y python3-dev python3-numpy
python3 -m pip install --upgrade --force-reinstall --user Cython
python3 -m pip install --upgrade --force-reinstall --user pycocotools
python3 -m pip install --upgrade --force-reinstall --user pandas



####  At the time of writing 1.15 is the lastest / final 1.x version of Tensorflow
# python3 -m pip install --upgrade --force-reinstall tensorflow==1.15 --user


#Make the folder structure 
mkdir ~/TensorFlow

cd ~/TensorFlow

mkdir workspace
mkdir workspace/training_demo
mkdir workspace/training_demo/annotations
mkdir workspace/training_demo/images
mkdir workspace/training_demo/images/test
mkdir workspace/training_demo/images/train
mkdir workspace/training_demo/pre-trained-model
mkdir workspace/training_demo/training

mkdir scripts
mkdir scripts/preprocessing


# Get the "Models and examples built with TensorFlow"
cd ~/TensorFlow
git clone https://github.com/tensorflow/models.git


# From within TensorFlow/models/research/

cd ~/TensorFlow/models/research/
protoc object_detection/protos/*.proto --python_out=.

# From within TensorFlow/models/research/
python3 setup.py build
sudo python3 setup.py install


# Install COCO API

cd ~
git clone https://github.com/cocodataset/cocoapi.git
cd ~/cocoapi/PythonAPI

# Edit python to python3 two places in the Makefile
# Patch was created originally with :
# git diff --ignore-space-at-eol -b -w --ignore-blank-lines > ~/CUDA-OpenCV/CUDA102-OpenCV420/cocoapi-python3.diff

patch < ~/CUDA-OpenCV/CUDA102-OpenCV420/cocoapi-python3.diff
make
cp -r pycocotools ~/TensorFlow/models/research/



# Copy the backup of all the images annotaed with LabelImg
cp -r /media/$USER/CUDA/laks ~/
# Split in approx 10% test and 90% train images (I had 800 annotated images)
cd ~/laks
cp {00001..00080}.jpg ~/TensorFlow/workspace/training_demo/images/test/
cp {00001..00080}.xml ~/TensorFlow/workspace/training_demo/images/test/
cp * ~/TensorFlow/workspace/training_demo/images/train

# Copy the label map file
cp ~/CUDA-OpenCV/CUDA102-OpenCV420/label_map.pbtxt ~/TensorFlow/workspace/training_demo/annotations/label_map.pbtxt


# Some utilities
cp ~/CUDA-OpenCV/CUDA102-OpenCV420/xml_to_csv.py ~/TensorFlow/scripts/preprocessing/
cp ~/CUDA-OpenCV/CUDA102-OpenCV420/generate_tfrecord.py ~/TensorFlow/scripts/preprocessing


cd ~/TensorFlow/scripts/preprocessing 
python3 xml_to_csv.py -i ~/TensorFlow/workspace/training_demo/images/train -o ~/TensorFlow/workspace/training_demo/annotations/train_labels.csv
python3 xml_to_csv.py -i ~/TensorFlow/workspace/training_demo/images/test -o ~/TensorFlow/workspace/training_demo/annotations/test_labels.csv

# NOTE ABSOLUTE PATHE IS OF IMPORTANCE HERE
python3 generate_tfrecord.py --label=salmon --csv_input=/home/$USER/TensorFlow/workspace/training_demo/annotations/train_labels.csv --output_path=/home/$USER/TensorFlow/workspace/training_demo/annotations/train.record --img_path=/home/$USER/TensorFlow/workspace/training_demo/images/train
python3 generate_tfrecord.py --label=salmon --csv_input=/home/$USER/TensorFlow/workspace/training_demo/annotations/test_labels.csv --output_path=/home/$USER/TensorFlow/workspace/training_demo/annotations/test.record --img_path=/home/$USER/TensorFlow/workspace/training_demo/images/test





FIX FIX FIX


#!/bin/bash

source ~/.bash_profile

cd ~/TensorFlow/models/research/
protoc object_detection/protos/*.proto --python_out=.



cd ~

rm -rf ~/TensorFlow/workspace/training_demo/pre-trained-model/*
rm ~/TensorFlow/workspace/training_demo/pre-trained-model/pipeline.config
rm -rf ~/TensorFlow/workspace/training_demo/training/*

#MODEL=ssd_miobilenet_v2_quantized_300x300_coco_2019_01_03
#MODEL=ssd_mobilenet_v1_0.75_depth_300x300_coco14_sync_2018_07_03


MODEL=ssd_mobilenet_v1_ppn_shared_box_predictor_300x300_coco14_sync_2018_07_03

wget http://download.tensorflow.org/models/object_detection/$MODEL.tar.gz
tar xvzf $MODEL.tar.gz
cd ~/$MODEL



cp -r * ~/TensorFlow/workspace/training_demo/pre-trained-model/
cp pipeline.config ~/TensorFlow/workspace/training_demo/training/pipeline.config
      /home/jarleven/TensorFlow/workspace/training_demo/training/pipeline.config 

cd ~/TensorFlow/workspace/training_demo/training

~/CUDA-OpenCV/CUDA102-OpenCV420/pipeline_config_massage.sh

cd ~/TensorFlow/workspace/training_demo/
python3 train.py --logtostderr --train_dir=training/ --pipeline_config_path=training/pipeline.config



https://blog.tensorflow.org/2019/03/build-ai-that-works-offline-with-coral.html

FIX FIX FIX






###
# http://download.tensorflow.org/models/object_detection/ssd_mobilenet_v1_quantized_300x300_coco14_sync_2018_07_18.tar.gz
#

#rm -rf ~/TensorFlow/workspace/training_demo/pre-trained-model/*


#cd ~
#wget http://download.tensorflow.org/models/object_detection/ssd_mobilenet_v1_quantized_300x300_coco14_sync_2018_07_18.tar.gz
#tar xvzf ssd_mobilenet_v1_quantized_300x300_coco14_sync_2018_07_18.tar.gz
#cd ~/ssd_mobilenet_v1_quantized_300x300_coco14_sync_2018_07_18
#cp -r * ~/TensorFlow/workspace/training_demo/pre-trained-model/

cp pipeline.config ~/TensorFlow/workspace/training_demo/training/pipeline.config

cd ~/TensorFlow/workspace/training_demo/pre-trained-model
~/CUDA-OpenCV/CUDA102-OpenCV420/pipeline_config_massage.sh

#cp ~/CUDA-OpenCV/CUDA102-OpenCV420/ssd_mobilenet_v1_quantized_pipeline.config ~/TensorFlow/workspace/training_demo/training/pipeline.config





###
# http://download.tensorflow.org/models/object_detection/ssd_mobilenet_v2_quantized_300x300_coco_2019_01_03.tar.gz"
#

rm -rf ~/TensorFlow/workspace/training_demo/pre-trained-model/*

cd ~
wget http://download.tensorflow.org/models/object_detection/ssd_mobilenet_v2_quantized_300x300_coco_2019_01_03.tar.gz
tar xvzf ssd_mobilenet_v2_quantized_300x300_coco_2019_01_03.tar.gz
cd ~/ssd_mobilenet_v2_quantized_300x300_coco_2019_01_03
cp -r * ~/TensorFlow/workspace/training_demo/pre-trained-model/

cp pipeline.config ~/TensorFlow/workspace/training_demo/training/pipeline.config
cd ~/TensorFlow/workspace/training_demo/pre-trained-model
~/CUDA-OpenCV/CUDA102-OpenCV420/pipeline_config_massage.sh


# cp ~/CUDA-OpenCV/CUDA102-OpenCV420/ssd_mobilenet_v2_quantized_pipeline.config ~/TensorFlow/workspace/training_demo/training/pipeline.config

#diff ~/CUDA-OpenCV/CUDA102-OpenCV420/ssd_mobilenet_v2_quantized_pipeline.config ~/TensorFlow/workspace/training_demo/training/pipeline.config




cp ~/TensorFlow/models/research/object_detection/legacy/train.py ~/TensorFlow/workspace/training_demo/

cd ~/TensorFlow/workspace/training_demo/
python3 train.py --logtostderr --train_dir=training/ --pipeline_config_path=training/pipeline.config

cp ~/CUDA-OpenCV/CUDA102-OpenCV420/ssd_mobilenet_v1_quantized_pipeline.config ~/TensorFlow/workspace/training_demo/training/pipeline.config

python3 train.py --logtostderr --train_dir=training/ --pipeline_config_path=training/pipeline.config --num_clones=2 --clone_on_cpu=True


# 
# https://github.com/EdjeElectronics/TensorFlow-Object-Detection-API-Tutorial-Train-Multiple-Objects-Windows-10/issues/61
# 
# 
# https://stackoverflow.com/questions/48795950/tensorflowobject-detection-valueerror-when-try-to-train-with-num-clones-2/51724431#51724431
# 
# I solved this issue by changing one parameter in my original configuration slightly:
#
# ...
# train_config: {
#  fine_tune_checkpoint: "C:/some_path/model.ckpt"
#  batch_size: 1
#  sync_replicas: true
#  startup_delay_steps: 0
#  replicas_to_aggregate: 8
#  num_steps: 25000
#  ...
# }
# ...







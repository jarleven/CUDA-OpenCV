#!/bin/bash

# Install some packages
sudo apt-get install -y git ssh build-essential linuxbrew-wrapper

# Install PIP for Python 3
sudo apt install -y python3-pip
python3 -m pip install --upgrade --user pip
sudo apt install -y python3-testresources

brew install protobuf


echo 'export PYTHONPATH="${PYTHONPATH:+${PYTHONPATH}:}$HOME/TensorFlow/models/research/object_detection:$HOME/TensorFlow/models/research:$HOME/TensorFlow/models/research/slim"' >> ~/.bash_profile

# Yes this is done above
# "export PYTHONPATH=$PYTHONPATH:`pwd`:`pwd`/slim"
# Print-working-directory pwd should be done from within the TensorFlow/models/research/ folder according the guides.

echo 'export PATH="${PATH:+${PATH}:}$HOME/.local/bin:/home/linuxbrew/.linuxbrew/bin"' >> ~/.bash_profile

echo 'export MANPATH="${MANPATH:+${MANPATH}:}/home/linuxbrew/.linuxbrew/share/man"' >> ~/.bash_profile

echo 'export INFOPATH="${INFOPATH:+${INFOPATH}:}/home/linuxbrew/.linuxbrew/share/info"' >> ~/.bash_profile

source ~/.bash_profile


#sudo apt install -y python3-dev python3-numpy
python3 -m pip install --upgrade --force-reinstall Cython --user
python3 -m pip install --upgrade --force-reinstall pycocotools --user
python3 -m pip install --upgrade --force-reinstall pandas --user



####  At the time of writing 1.15 is the lastest / final 1.x version of Tensorflow
python3 -m pip install --upgrade --force-reinstall tensorflow==1.15 --user


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


# TODO ADD some text

#cd ~
#git clone https://github.com/cocodataset/cocoapi.git
#cd cocoapi/PythonAPI

#==TODO edit python to python3 two places in the Makefile==

#git diff --ignore-space-at-eol -b -w --ignore-blank-lines > ~/TensorFlow/patches/cocoapi-python3.diff
 
#make
#cp -r pycocotools ~/TensorFlow/models/research/



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



###
# http://download.tensorflow.org/models/object_detection/ssd_mobilenet_v1_quantized_300x300_coco14_sync_2018_07_18.tar.gz
#

cd ~
wget http://download.tensorflow.org/models/object_detection/ssd_mobilenet_v1_quantized_300x300_coco14_sync_2018_07_18.tar.gz
tar xvzf ssd_mobilenet_v1_quantized_300x300_coco14_sync_2018_07_18.tar.gz
cd ~/ssd_mobilenet_v1_quantized_300x300_coco14_sync_2018_07_18

cp ~/CUDA-OpenCV/CUDA102-OpenCV420/ssd_mobilenet_v1_quantized_pipeline.config ~/TensorFlow/workspace/training_demo/training/pipeline.config

cp -r * ~/TensorFlow/workspace/training_demo/pre-trained-model/





###
# http://download.tensorflow.org/models/object_detection/ssd_mobilenet_v2_quantized_300x300_coco_2019_01_03.tar.gz"
#

# cd ~
# wget http://download.tensorflow.org/models/object_detection/ssd_mobilenet_v2_quantized_300x300_coco_2019_01_03.tar.gz
# tar xvzf ssd_mobilenet_v2_quantized_300x300_coco_2019_01_03.tar.gz
# cd ~/ssd_mobilenet_v2_quantized_300x300_coco_2019_01_03

# cp ~/CUDA-OpenCV/CUDA102-OpenCV420/ssd_mobilenet_v2_quantized_pipeline.config ~/TensorFlow/workspace/training_demo/training/pipeline.config

# cp -r * ~/TensorFlow/workspace/training_demo/pre-trained-model/




cp ~/TensorFlow/models/research/object_detection/legacy/train.py ~/TensorFlow/workspace/training_demo/

python3 train.py --logtostderr --train_dir=training/ --pipeline_config_path=training/pipeline.config




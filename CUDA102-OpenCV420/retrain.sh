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




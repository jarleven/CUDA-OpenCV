#!/bin/bash

sudo apt install -y libcupti-dev
sudo apt install -y python-pip
pip install --user --upgrade pip
hash -d pip
pip install --upgrade pip

pip install tensorflow-gpu==1.4.1

sudo chown -R $USER:$USER /usr/local/lib/python2.7/dist-packages/
sudo chown -R $USER:$USER /usr/local/bin/


pip install --ignore-installed tensorflow-gpu==1.4.1

cd ~
git clone https://github.com/tensorflow/models.git
cd ~/models/tutorials/image/imagenet
python classify_image.py

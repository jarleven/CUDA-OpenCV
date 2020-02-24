#!/bin/bash

cd ~

git clone https://github.com/tzutalin/labelImg.git


sudo apt-get install pyqt5-dev-tools
sudo pip3 install -r requirements/requirements-linux-python3.txt

cd labelImg/

make qt5py3

#python3 labelImg.py
#python3 labelImg.py [IMAGE_PATH] [PRE-DEFINED CLASS FILE]




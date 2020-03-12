#!/bin/bash

# Training the object detector
#https://github.com/tzutalin/labelImg
#https://towardsdatascience.com/how-to-train-your-own-object-detector-with-tensorflows-object-detector-api-bec72ecfe1d9


# Batch download images with Fatkun Batch Download Image
# https://chrome.google.com/webstore/detail/fatkun-batch-download-ima/nnjjahlikiabnchcpehcpkdeckfgnohf/RK%3D2/RS%3DPnB3CMxxSoOYRnLD3KKFviCVQvs-

cd ~

git clone https://github.com/tzutalin/labelImg.git


sudo apt-get install -y pyqt5-dev-tools
cd labelImg/
sudo pip3 install -r requirements/requirements-linux-python3.txt


make qt5py3

#python3 labelImg.py
#python3 labelImg.py [IMAGE_PATH] [PRE-DEFINED CLASS FILE]




#!/bin/bash

sudo dpkg -i libcudnn6_6.0.21-1+cuda8.0_amd64.deb
sudo dpkg -i libcudnn6-dev_6.0.21-1+cuda8.0_amd64.deb
sudo dpkg -i libcudnn6-doc_6.0.21-1+cuda8.0_amd64.deb
sudo apt update


cp -r /usr/src/cudnn_samples_v6/ ~/
cd ~/cudnn_samples_v6/mnistCUDNN
make clean && make
./mnistCUDNN


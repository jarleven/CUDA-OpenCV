#!/bin/bash

#sudo echo "/usr/local/cuda-10.1/extras/CUPTI/lib64" > /etc/ld.so.conf.d/cupti.conf

sudo ldconfig -vvvv

sudo apt-get install -y software-properties-common swig curl
sudo add-apt-repository -y ppa:webupd8team/java
sudo apt-get update
sudo apt-get install -y oracle-java8-installer
echo "deb [arch=amd64] http://storage.googleapis.com/bazel-apt stable jdk1.8" | sudo tee /etc/apt/sources.list.d/bazel.list
curl https://storage.googleapis.com/bazel-apt/doc/apt-key.pub.gpg | sudo apt-key add -
sudo apt-get update
sudo apt-get -y install bazel


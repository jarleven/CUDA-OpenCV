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






####### TODO WHAT TO SELECT ???




##
# Copied from this official guide :
# https://docs.bazel.build/versions/master/install-ubuntu.html
#

sudo apt install curl
curl https://bazel.build/bazel-release.pub.gpg | sudo apt-key add -
echo "deb [arch=amd64] https://storage.googleapis.com/bazel-apt stable jdk1.8" | sudo tee /etc/apt/sources.list.d/bazel.list
sudo apt update && sudo apt install bazel


#
# user@host:~/tensorflow/tensorflow/python/tools$ bazel build tensorflow/python/tools:freeze_graph && bazel-bin/tensorflow/python/tools/freeze_graph --input_graph=/home/jarleven/TensorFlow/ssd_inception_v2_coco_b002_salmon_salmo_salar/frozen_inference_graph.pb --input_checkpoint=/home/jarleven/TensorFlow/ssd_inception_v2_coco_b002_salmon_salmo_salar/model.ckpt.data-00000-of-00001 --output_graph=/tmp/frozen_graph.pb --output_node_names=softmax
# ERROR: The project you're trying to build requires Bazel 2.0.0 (specified in /home/jarleven/tensorflow/.bazelversion), but it wasn't found in /usr/bin.
#

# You can install the required Bazel version via apt:
sudo apt update && sudo apt install bazel-2.0.0



# bazel build tensorflow/python/tools:freeze_graph && \
# bazel-bin/tensorflow/python/tools/freeze_graph \
# --input_graph=/home/jarleven/TensorFlow/ssd_inception_v2_coco_b002_salmon_salmo_salar/frozen_inference_graph.pb \
# --input_checkpoint=/home/jarleven/TensorFlow/ssd_inception_v2_coco_b002_salmon_salmo_salar/model.ckpt.data-00000-of-00001 \
# --output_graph=/tmp/frozen_graph.pb --output_node_names=softmax

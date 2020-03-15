#!/bin/bash


curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
echo "deb https://packages.cloud.google.com/apt coral-edgetpu-stable main" | sudo tee /etc/apt/sources.list.d/coral-edgetpu.list
sudo apt update
sudo apt install edgetpu

# Change to where the model is saved and compile for EdgeTPU

# cd $HOME/......
# edgetpu_compiler output_tflite_graph.tflite

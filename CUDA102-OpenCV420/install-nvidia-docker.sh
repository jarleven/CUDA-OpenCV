#!/bin/bash

# From https://github.com/NVIDIA/nvidia-docker
# Ubuntu 16.04/18.04, Debian Jessie/Stretch/Buster

# Exit script on error.
set -e
# Echo each command.
set -x

cd ~

sudo apt install -y curl

# Add the package repositories
distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add -
curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list

sudo apt-get update && sudo apt-get install -y nvidia-container-toolkit
sudo systemctl restart docker


#!/bin/bash


# Installing docker
# https://docs.docker.com/install/linux/docker-ce/ubuntu/

# Exit script on error
set -e
# Echo each command
set -x


# Uninstall old versions of Docker

sudo apt-get remove -y docker docker-engine docker.io containerd runc
sudo apt-get update


sudo apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common


curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
 
sudo apt-key fingerprint 0EBFCD88
# Sleep here, Added this first time I tried to install unattended
sleep 5

sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"


sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io


## Do I need this  and reboot after ? Or was it just that tensorboard was already running on the metall ? or did I just have to reboot ???
#sudo groupadd docker
#sudo usermod -aG docker ${USER}
### End do I need this


sudo docker run hello-world


#!/bin/bash

#####################################################
#
# Testing .deb files as suggested by Tensorflow
#
####
#
# # Copy all the md5 files so we can check them with ease later
# cp -v md5/*.md5 ~/
# 
# echo "Copy files form USB"
# cp -v /media/jarleven/CUDA/CUDAFILES/* ~/
#
#


set -e  # Exit immediately if a command exits with a non-zero status. (Exit on error)
set -x  # Print commands and their arguments as they are executed.
set -u  # Treat unset variables as an error when substituting.



# Just in case I need to modify this repository (Sorry)
if [ $USER == "jarleven" ]
then
    git config --global user.email "jarleven@gmail.com"
    git config --global user.name "Jarl Even Englund"
fi


# Don't prompt for sudo password
echo "# Added by OpenCV setup script" | sudo EDITOR='tee -a' visudo
echo "$USER ALL=(ALL) NOPASSWD: ALL" | sudo EDITOR='tee -a' visudo


# Disable the powersaving to keep track of the install progress when user is idle.
gsettings set org.gnome.settings-daemon.plugins.power idle-dim false
gsettings set org.gnome.desktop.session idle-delay 0


sudo apt install -y vim vlc screen ssh

# Upgrade the system
sudo apt update
sudo apt upgrade -y



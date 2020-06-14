#!/bin/bash


set -e  # Exit immediately if a command exits with a non-zero status. Exit on error
set -x  # Print commands and their arguments as they are executed.
set -u  # Treat unset variables as an error when substituting.


sudo apt install -y ssh git screen vim


# Just in case I need to modify this repository (Sorry)
if [ $USER == "jarleven" ]
then

    cd
    mkdir -p CUDAFILES
    cd CUDAFILES
    scp 192.168.1.236:/home/jarleven/laksenArcive/CUDAFILES/UBUNTU1804/CUDA101/* .
    scp 192.168.1.236:/home/jarleven/laksenArcive/CUDAFILES/Video_Codec_SDK_9.1.23.zip .

    git config --global user.email "jarleven@gmail.com"
    git config --global user.name "Jarl Even Englund"
fi


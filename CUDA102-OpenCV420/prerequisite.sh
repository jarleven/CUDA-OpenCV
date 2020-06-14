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
    scp 192.168.1.236:/home/jarleven/laksenArcive/CUDAFILES/MODELS-TAR/faster_rcnn_inception_v2_coco_2018_01_28_AT_1000000_Exportdate__2020-05-15__08-09-56.tar.bz2 .

    git config --global user.email "jarleven@gmail.com"
    git config --global user.name "Jarl Even Englund"
fi


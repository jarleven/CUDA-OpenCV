#!/bin/bash


cd "$(dirname "$0")"
source .setupstate


# We use theese variables 


SCRIPT_CUDAVER="10.0"

echo "SCRIPT_CUDAVER=$SCRIPT_CUDAVER"" >> .scriptvars
echo "SCRIPT_CUDAPATH="/usr/local/cuda-$SCRIPT_CUDAVER"" >> .scriptvars
#echo 'SCRIPT_CUDAPATH="/usr/local/cuda-10.0"' >> .scriptvars
echo 'SCRIPT_FFMPEG="OFF"' >> .scriptvars
echo 'SCRIPT_CUDA_ARCH_BIN="6.1"' >> .scriptvars
echo 'SCRIPT_CUDA_ARCH_PTX="6.1"' >> .scriptvars

# Check your GPU capability https://developer.nvidia.com/cuda-gpus


source .scriptvars


echo "We are at sate $OPENCV_SETUPSTATE "
sleep 3

case $OPENCV_SETUPSTATE in


  1)
    echo -e "Check if you have all nonfree files and do first update of system and install NVIDIA driver \n\n"
 
    # TODO be smarter than this.
    # The files are locaded on a USB drive named CUDA
    cp /media/jarleven/CUDA/Video_Codec_SDK_9.1.23.zip ~/
    cp /media/jarleven/CUDA/cudnn-10.0-linux-x64-v7.6.5.32.tgz ~/
    cp /media/jarleven/CUDA/cudnn-10.2-linux-x64-v7.6.5.32.tgz ~/

    # Just in case I need to modify this repository (Sorry)
    if [ $USER == "jarleven" ]
    then
        git config --global user.email "jarleven@gmail.com"
        git config --global user.name "Jarl Even Englund"

    fi
   
    # Copy all the md5 files so we can check them with ease later
    cp md5/*.md5 ~/
 
    # Check if we have the NVIDIA cuDNN files and Nvidia video Codec SDK files. 
    ./pre-start.sh

    retVal=$?
    if [ $retVal -eq 0 ]; then
        echo "NVIDIA files found"
    else
        echo "NVIDIA files _NOT_ found. Please download the missing files and restart the script"
        exit
    fi

    
    # Don't prompt for sudo password
    echo "# Added by OpenCV setup script" | sudo EDITOR='tee -a' visudo
    echo "$USER ALL=(ALL) NOPASSWD: ALL" | sudo EDITOR='tee -a' visudo


    echo "Bootstrapping this script, will run on next login"
    mkdir ~/.config/autostart
    cp opencv.desktop ~/.config/autostart/


    sudo apt update
    sudo apt upgrade -y
    sudo apt install -y vim vlc screen ssh
    
    # Disable the powersaving, to keep track of the progress when user is idle.
    gsettings set org.gnome.settings-daemon.plugins.power idle-dim false
    gsettings set org.gnome.desktop.session idle-delay 0

    # Install NVIDIA driver from ppa:graphics-drivers/ppa
    install-nvidia.sh


    echo "Exit in 10 seconds"
    sleep 10
    echo "OPENCV_SETUPSTATE="2"" > .setupstate
    sudo reboot


    ;;


  2)
  
    echo -e "Install CUDA and Graphics driver\n\n"
  
    if [ SCRIPT_CUDAVER == "10.0" ]
    then
        ./cuda-10-0.sh
    elif [ SCRIPT_CUDAVER == "10.2" ]
    then
        ./cuda-10-2.sh
    fi
 
 
    echo -e "Install cuDNN\n\n"

    if [ SCRIPT_CUDAVER == "10.0" ]
    then
        ./cudnn-10-0.sh
    elif [ SCRIPT_CUDAVER == "10.2" ]
    then
        ./cudnn-10-2.sh
    fi     
     
 
    sudo apt update
    sudo apt upgrade -y
    echo "Exit in 10 seconds"
    sleep 10
    echo "OPENCV_SETUPSTATE="3"" > .setupstate
    sudo reboot
    ;;

  3)
    echo -e "Install OpenCV requirements \n\n"
    ./download-opencv.sh
    ./prepare-opencv.sh

    sudo apt update
    sudo apt upgrade -y
    echo "Exit in 10 seconds"
    sleep 10
    echo "OPENCV_SETUPSTATE="4"" > .setupstate
    sudo reboot

    ;;

  4)
    echo -e "Build FFMPEG \n\n"
    ./build-ffmpeg.sh
    sudo apt update
    sudo apt upgrade -y
    echo "Exit in 10 seconds"
    sleep 10
    echo "OPENCV_SETUPSTATE="5"" > .setupstate
    sudo reboot
    ;;

  5)
    echo -e "Build OpenCV \n\n"
    ./build-opencv.sh

    sudo apt autoremove -y
    sudo apt update
    sudo apt upgrade -y
    echo "Exit in 10 seconds"
    sleep 10
    echo "OPENCV_SETUPSTATE="6"" > .setupstate
    sudo reboot
    ;;


  *)
    echo -e "unknown install state \n\n"

    ./versions.sh
    read  -n 1 -p "Input Selection:"

    rm ~/.config/autostart/opencv.desktop
    echo "Deleting my own bootstrap"
    echo "Exit in 30 seconds"
    sleep 30

    # TODO enable sudo password again
    # #includedir /etc/sudoers.d
    # jarleven ALL=(ALL) NOPASSWORD:ALL

    ;;
esac


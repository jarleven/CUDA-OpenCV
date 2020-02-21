#!/bin/bash


cd "$(dirname "$0")"

# Load the state for our statemachine
source .setupstate


# We use theese variables thoughout the install process
export SCRIPT_CUDAVER="10.0"
export SCRIPT_NVIDIAVER="440"
export SCRIPT_TENSORFLOWVER="2.1.0"
export SCRIPT_FFMPEG="OFF"
export SCRIPT_FFMPEGVER="4.2.2"
export SCRIPT_CUDA_ARCH_BIN="6.1"		#  YOUR GPU ARCHITECTURE GTX 1060 is 6.1
export SCRIPT_CUDA_ARCH_PTX="6.1"		#  Check your GPU capability https://developer.nvidia.com/cuda-gpus

export SCRIPT_CUDAPATH=/usr/local/cuda-$SCRIPT_CUDAVER



echo "We are at state $OPENCV_SETUPSTATE "
sleep 3

case $OPENCV_SETUPSTATE in


  1)
    echo -e "Check if you have all nonfree files, do first update of system and install NVIDIA driver \n\n"
    sleep 10
 
    sudo apt install -y vim vlc screen ssh


    # Just in case I need to modify this repository (Sorry)
    if [ $USER == "jarleven" ]
    then
        git config --global user.email "jarleven@gmail.com"
        git config --global user.name "Jarl Even Englund"
    fi
   

    # Check if we have the NVIDIA cuDNN files and NVIDIA video Codec SDK files. 
    ./pre-start.sh

    retVal=$?
    if [ $retVal -eq 0 ]; then
        echo "NVIDIA files found"
    else
        echo "\n\n\n NVIDIA files _NOT_ found. Please download the missing files and restart the script \n\n\n"
        exit
    fi

    
    # Don't prompt for sudo password
    echo "# Added by OpenCV setup script" | sudo EDITOR='tee -a' visudo
    echo "$USER ALL=(ALL) NOPASSWD: ALL" | sudo EDITOR='tee -a' visudo


    echo "Bootstrapping this script, so it will run on next boot"
    mkdir ~/.config/autostart
    cp opencv.desktop ~/.config/autostart/

 
    # Disable the powersaving to keep track of the install progress when user is idle.
    gsettings set org.gnome.settings-daemon.plugins.power idle-dim false
    gsettings set org.gnome.desktop.session idle-delay 0


    sudo apt update
    sudo apt upgrade -y
 

    # Install NVIDIA driver from ppa:graphics-drivers/ppa
    install-nvidia.sh

    sudo apt update
    sudo apt upgrade -y
 
    echo "Reboot in 10 seconds"
    sleep 10
    echo "OPENCV_SETUPSTATE="2"" > .setupstate
    sudo reboot


    ;;


  2)
  
    echo -e "Install CUDA\n\n"
    sleep 10
	
	./cuda-$SCRIPT_CUDAVER.sh
  
 
    echo -e "Install cuDNN\n\n"
    sleep 10
	
	./cudnn-$SCRIPT_CUDAVER.sh
    
 
    sudo apt update
    sudo apt upgrade -y
    echo "Reboot in 10 seconds"
    sleep 10
    echo "OPENCV_SETUPSTATE="3"" > .setupstate
    sudo reboot
    ;;


  3)
    echo -e "Download OpenCV and install dependencies for building OpenCV \n\n"
    sleep 10

    ./download-opencv.sh
    ./prepare-opencv.sh


    if [ $SCRIPT_FFMPEG== "ON" ]
    then
        echo "OPENCV_SETUPSTATE="4"" > .setupstate
    else
        echo "Skipping FFMPEG build"
        echo "OPENCV_SETUPSTATE="5"" > .setupstate
    fi

    sudo apt update
    sudo apt upgrade -y
    echo "Reboot in 10 seconds"
    sleep 10
    sudo reboot

    ;;


  4)
    echo -e "Build FFMPEG \n\n"
    sleep 10

    ./build-ffmpeg.sh

    sudo apt update
    sudo apt upgrade -y
    echo "Reboot in 10 seconds"
    sleep 10
    echo "OPENCV_SETUPSTATE="5"" > .setupstate
    sudo reboot
    ;;


  5)
    echo -e "Build OpenCV \n\n"
    sleep 10

    ./build-opencv.sh

    #sudo apt autoremove -y
    sudo apt update
    sudo apt upgrade -y
    echo "Reboot in 10 seconds"
    sleep 10
    echo "OPENCV_SETUPSTATE="6"" > .setupstate
    sudo reboot
    ;;


  6)
    echo -e "Test OpenCV \n\n"
    sleep 10

    ./versions.sh
	
	# Stop here and wait for the user.
    read  -n 1 -p "Input Selection:"

    rm ~/.config/autostart/opencv.desktop
    echo "Deleting my own bootstrap"
    echo "Exit in 30 seconds"
    sleep 30

    # TODO enable sudo password again remove the NOPASSWORD line for your user
    # Run "sudo visudo"
    # #includedir /etc/sudoers.d
    # foobar ALL=(ALL) NOPASSWD: ALL
    ;;
	

  *)
    echo -e "unknown install state \n\n"
    read  -n 1 -p "Input Selection:"
    ;;

esac


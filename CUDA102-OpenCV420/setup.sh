#!/bin/bash

exit

cd "$(dirname "$0")"

# Load the state for our statemachine
source .setupstate

source .setupvars



#alias python=python3

#export LD_LIBRARY_PATH=/usr/local/cuda-10.0/lib${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}
#export PATH=/usr/local/cuda-10.0/bin${PATH:+:${PATH}}
#export LD_LIBRARY_PATH=/usr/local/cuda-10.0/extras/CUPTI/lib64${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}



echo "We are at state $OPENCV_SETUPSTATE "
sleep 3

case $OPENCV_SETUPSTATE in


  1)
    echo -e "Check if you have all nonfree files and do first update of system \n\n"
    sleep 10
 
    ./preparation.sh
 
    echo "Reboot in 10 seconds"
    sleep 10
    echo "OPENCV_SETUPSTATE="2"" > .setupstate
    sudo reboot
    ;;


  2)
    echo -e "Install NVIDIA driver \n\n"
    sleep 10
 
    # Install NVIDIA driver from ppa:graphics-drivers/ppa
    ./install-nvidia.sh

    echo "Reboot in 10 seconds"
    sleep 10
    echo "OPENCV_SETUPSTATE="3"" > .setupstate
    sudo reboot
    ;;


  3)
    echo -e "Install CUDA\n\n"
    sleep 10
	
	./cuda-$SCRIPT_CUDAVER.sh
  
 
    echo -e "Install cuDNN\n\n"
    sleep 10
	
	./cudnn-$SCRIPT_CUDAVER.sh
    
 
    echo "Reboot in 10 seconds"
    sleep 10
    echo "OPENCV_SETUPSTATE="4"" > .setupstate
    sudo reboot
    ;;


  4)
    echo -e "Download OpenCV and install dependencies for building OpenCV \n\n"
    sleep 10

    ./download-opencv.sh
    ./prepare-opencv.sh


    if [ $SCRIPT_FFMPEG== "ON" ]
    then
        echo "OPENCV_SETUPSTATE="5"" > .setupstate
    else
        echo "Skipping FFMPEG build"
        echo "OPENCV_SETUPSTATE="6"" > .setupstate
    fi


    echo "Reboot in 10 seconds"
    sleep 10
    sudo reboot
    ;;


  5)
    echo -e "Build FFMPEG \n\n"
    sleep 10

    ./build-ffmpeg.sh

    echo "Reboot in 10 seconds"
    sleep 10
    echo "OPENCV_SETUPSTATE="6"" > .setupstate
    sudo reboot
    ;;


  6)
    echo -e "Build OpenCV \n\n"
    sleep 10

    ./build-opencv.sh


    echo "Reboot in 10 seconds"
    sleep 10
    echo "OPENCV_SETUPSTATE="7"" > .setupstate
    sudo reboot
    ;;


  7)
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


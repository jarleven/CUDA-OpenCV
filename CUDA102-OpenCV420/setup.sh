#!/bin/bash

exit

cd "$(dirname "$0")"

# Load the state for our statemachine
source .setupstate

source .setupvars



echo "We are at state $OPENCV_SETUPSTATE "
sleep 3

case $OPENCV_SETUPSTATE in


  1)
    echo -e "Check if you have all nonfree files and do first update of system \n\n"
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
 
    echo "Reboot in 10 seconds"
    sleep 10
    echo "OPENCV_SETUPSTATE="11"" > .setupstate
    sudo reboot


    ;;


  11)
    echo -e "Install NVIDIA driver \n\n"
    sleep 10
 
    sudo apt update
    sudo apt upgrade -y
 

    # Install NVIDIA driver from ppa:graphics-drivers/ppa
    ./install-nvidia.sh

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


#!/bin/bash


cd "$(dirname "$0")"

# setup.sh --arch_bin 12.4 --arch_ptx 17.3

# Allow for passing of CUDA architecture when startring the script
while [ $# -gt 0 ] ; do
  case $1 in
    -b | --arch_bin) SETUP_CUDA_ARCH_BIN="$2" ;;
    -p | --arch_ptx) SETUP_CUDA_ARCH_PTX="$2" ;;
    -t | --tensorflow_ver) SETUP_TENSORFLOWVER="$2" ;;  
  esac
  shift
done


if [ -z $SETUP_CUDA_ARCH_BIN ]; then
 echo "CUDA ARCH BIN NOT PROVIDED USING DEFAULT"
else
  sed -i '/SCRIPT_CUDA_ARCH_BIN/d' .setupvars
  echo 'SCRIPT_CUDA_ARCH_BIN="'${SETUP_CUDA_ARCH_BIN}'"' >> .setupvars
fi

if [[ -z "${SETUP_CUDA_ARCH_PTX}" ]]; then
 echo "CUDA ARCH PTX NOT PROVIDED USING DEFAULT"
else
  sed -i '/SCRIPT_CUDA_ARCH_PTX/d' .setupvars
  echo 'SCRIPT_CUDA_ARCH_PTX="'${SETUP_CUDA_ARCH_PTX}'"' >> .setupvars
fi


if [[ -z "${SETUP_TENSORFLOWVER}" ]]; then
 echo "Tensorflow version not provided, using default"
else
  sed -i '/SCRIPT_TENSORFLOWVER/d' .setupvars
  echo 'SCRIPT_TENSORFLOWVER="'${SETUP_TENSORFLOWVER}'"' >> .setupvars
fi


cat .setupvars

sleep 10




# Load the state for our statemachine
source .setupstate

source .setupvars


#
# OpenCV 4.2.0
# Cuda 10.0
# nvidia-driver-418   (NVIDIA-SMI 430.50       Driver Version: 430.50       CUDA Version: 10.1)
# CUDA 10.0.130_410.48
# cuDNN v7.6.4 (September 27, 2019), for CUDA 10.0
# pip install tensorflow-gpu==2.0.0
#



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
	
    echo "Bootstrapping this script, so it will run on next boot"
    echo "Run the following command to remove the bootstrap/stop the script"
    echo "rm ~/.config/autostart/opencv.desktop"
    echo ""
	
    mkdir ~/.config/autostart
    cp opencv.desktop ~/.config/autostart/
	
 
    echo "Reboot in 10 seconds"
    sleep 10
    echo "OPENCV_SETUPSTATE="2"" > .setupstate
    sudo reboot
    ;;


  2)
    echo -e "Install NVIDIA driver \n\n"
    sleep 10
 
    # Install NVIDIA driver from ppa:graphics-drivers/ppa
    #./install-nvidia.sh

    echo "Reboot in 10 seconds"
    sleep 10
    echo "OPENCV_SETUPSTATE="3"" > .setupstate
    sudo reboot
    ;;


  3)
    echo -e "Install CUDA\n\n"
    sleep 10
	
   #	./cuda-$SCRIPT_CUDAVER.sh
  
 
    echo -e "Install cuDNN\n\n"
    sleep 10
	
#	./cudnn-$SCRIPT_CUDAVER.sh
    
 
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
        sudo apt install -y ffmpeg
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


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
 
    ./install-nvidia-deb.sh driver

    echo "Reboot in 10 seconds"
    sleep 10
    echo "OPENCV_SETUPSTATE="3"" > .setupstate
    sudo reboot
    ;;


  3)
    echo -e "Install CUDA cuDNN \n\n"
    sleep 10
	
   ./install-nvidia-deb.sh cuda
 
 
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


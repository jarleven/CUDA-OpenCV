#!/bin/bash

set -e  # Exit immediately if a command exits with a non-zero status. Exit on error
set -x  # Print commands and their arguments as they are executed.
set -u  # Treat unset variables as an error when substituting.

sleep 5

pwd
cd "$(dirname "$0")"
pwd


source statemachine.state

while :
do

    OPENCV_SCRIPT_REBOOT="FALSE"
    OPENCV_SCRIPT_OK=911

    echo "We are at state $OPENCVSTATE"
    sleep 10

    case $OPENCVSTATE in

        0)
	  echo "We are done"
	  sleep 10
	  exit
	;;


        1)
            echo "Copy files"
            ./file-copy.sh
            OPENCV_SCRIPT_OK=$? && OPENCV_SCRIPT_REBOOT="NO"

        ;;

        2)
            echo "Bootstrap"
            ./bootstrap.sh   
	    OPENCV_SCRIPT_OK=$? && OPENCV_SCRIPT_REBOOT="NO"

        ;;


        3)
            echo "Preparations"
	    ./preparation.sh
            OPENCV_SCRIPT_OK=$? && OPENCV_SCRIPT_REBOOT="YES"

	;;


        4)
            echo "NVIDIA Driver"
            ./install-nvidia-deb.sh driver
            OPENCV_SCRIPT_OK=$? && OPENCV_SCRIPT_REBOOT="YES"

        ;;


        5)
            echo "NVIDIA CUDA"
            ./install-nvidia-deb.sh cuda
            OPENCV_SCRIPT_OK=$? && OPENCV_SCRIPT_REBOOT="YES"

        ;;

        6)
            echo "Copy over NVCUVID files"
            ./video-codec.sh
            OPENCV_SCRIPT_OK=$? && OPENCV_SCRIPT_REBOOT="NO"
            sleep 5
        ;;

        7)
            echo "Download OpenCV"
            ./download-opencv.sh
            OPENCV_SCRIPT_OK=$? && OPENCV_SCRIPT_REBOOT="NO"

        ;;


        8)
            echo "Prepare OpenCV"
            ./prepare-opencv.sh
            OPENCV_SCRIPT_OK=$? && OPENCV_SCRIPT_REBOOT="YES"

        ;;

        9)
            echo "Build OpenCV"
            ./build-opencv.sh
            OPENCV_SCRIPT_OK=$? && OPENCV_SCRIPT_REBOOT="YES"

        ;;


       10)    
            echo "Set background and stop statemachine"
            echo OPENCVSTATE=0 > ./statemachine.state
            wget https://miro.medium.com/max/588/1*9rDrXPsNMHGVVGV1X-_J0w.png -O background.png
            cp -u background.png ~/
            gsettings set org.gnome.desktop.background primary-color "#FFFFFF"
            gsettings set org.gnome.desktop.background picture-uri file:///home/$USER/background.png
            gsettings set org.gnome.desktop.background picture-options 'scaled'
	    reboot
       ;;


        *)
            echo -e "unknown install state \n\n"
            OPENCV_SCRIPT_OK=1 && OPENCV_SCRIPT_REBOOT="NO"

     	;;

    esac



    if [ "$OPENCV_SCRIPT_OK " -eq "0" ]
    then
      echo "State completed OK"
      OPENCVSTATE=$((OPENCVSTATE + 1)) && echo OPENCVSTATE=$OPENCVSTATE > ./statemachine.state
    else
        echo "Something failed in state $OPENCVSTATE, exiting script"
        while :; do echo 'Press <CTRL+C> to exit.'; sleep 60; done
        exit
    fi


    if [ $OPENCV_SCRIPT_REBOOT == "YES" ]
    then
        echo "Will reboot now"
	sleep 20
	sudo reboot
    else
        echo "Do next state"
	sleep 2
    fi

done


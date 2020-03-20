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

    echo "We are at state $OPENCVSTATE "
    sleep 3

    case $OPENCVSTATE in



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
            echo "Error"
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
            echo "NVIDIA Driver"
            ./video-codec.sh
            OPENCV_SCRIPT_OK=$? && OPENCV_SCRIPT_REBOOT="NO"

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
            echo "Prepare OpenCV"
            ./build-opencv.sh
            OPENCV_SCRIPT_OK=$? && OPENCV_SCRIPT_REBOOT="YES"

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


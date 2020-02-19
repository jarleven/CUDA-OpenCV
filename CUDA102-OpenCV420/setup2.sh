#!/bin/bash


cd "$(dirname "$0")"
source .setupstate

echo "We are at sate $OPENCV_SETUPSTATE "
sleep 3

case $OPENCV_SETUPSTATE in


  1)
      echo -e "Preparations \n\n"
      sleep 10
    
  
    # Just in case I need to modify something (Sorry)
    git config --global user.email "jarleven@gmail.com"
    git config --global user.name "Jarl Even Englund"

 
    # Don't prompt for sudo password
    echo "# Added by OpenCV setup script" | sudo EDITOR='tee -a' visudo
    echo "$USER ALL=(ALL) NOPASSWD: ALL" | sudo EDITOR='tee -a' visudo

    # Disable the powersaving
    gsettings set org.gnome.settings-daemon.plugins.power idle-dim false
    gsettings set org.gnome.desktop.session idle-delay 0



    echo "Bootstrapping this script, will run on next login"
    mkdir ~/.config/autostart
    cp opencv.desktop ~/.config/autostart/

    sudo apt install -y vim vlc screen ssh


    sudo apt update
    sudo apt upgrade -y
    echo "Exit in 10 seconds"
    sleep 10
    echo "OPENCV_SETUPSTATE="2"" > .setupstate
    sudo reboot


    ;;


  2)
    echo -e "Install NVIDIA Graphics driver \n\n"
    sleep 10
    
    # Tensorflow example part 1of2
    # https://www.tensorflow.org/install/gpu

    # Add NVIDIA package repositories
    wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/cuda-repo-ubuntu1804_10.1.243-1_amd64.deb
    sudo dpkg -i cuda-repo-ubuntu1804_10.1.243-1_amd64.deb
    sudo apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/7fa2af80.pub
    sudo apt update
    wget http://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1804/x86_64/nvidia-machine-learning-repo-ubuntu1804_1.0.0-1_amd64.deb
    sudo apt install -y ./nvidia-machine-learning-repo-ubuntu1804_1.0.0-1_amd64.deb
    sudo apt update

    # Install NVIDIA driver
    sudo apt install -y --no-install-recommends nvidia-driver-418
    
# FFMPEG instructions to test
#    sudo apt-get install nvidia-kernel-source-430 nvidia-driver-430   from https://superuser.com/questions/1444978/using-ffmpeg-with-nvidia-gpu


    # Reboot. Check that GPUs are visible using the command: nvidia-smi



    sudo apt update
    sudo apt upgrade -y
    echo "Exit in 10 seconds"
    sleep 10
    echo "OPENCV_SETUPSTATE="21"" > .setupstate
    sudo reboot
    ;;
    
  21)
  
    echo -e "Install CUDA, cuDNN, TensorRT CUPTI \n\n"
    sleep 10

    # Tensorflow example part 2of2
    # https://www.tensorflow.org/install/gpu


    # Install development and runtime libraries (~4GB)
    sudo apt install -y --no-install-recommends cuda-10-1 libcudnn7=7.6.4.38-1+cuda10.1 libcudnn7-dev=7.6.4.38-1+cuda10.1


    # Install TensorRT. Requires that libcudnn7 is installed above.
    sudo apt install -y --no-install-recommends libnvinfer6=6.0.1-1+cuda10.1 libnvinfer-dev=6.0.1-1+cuda10.1 libnvinfer-plugin6=6.0.1-1+cuda10.1


    # TODO remove .bashrc additions in case we run again


    #### In case you run the script multiple times remove the stuff potentially added in bashrc ....
    sed -i '/#Add CUDA/d' ~/.bashrc
    sed -i '/\/usr\/local\/cuda/d' ~/.bashrc

    echo '#Add CUDA environment' >> ~/.bashrc 
    echo 'LD_LIBRARY_PATH=/usr/local/cuda-10.1/lib${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}' >> ~/.bashrc
    echo 'PATH=/usr/local/cuda-10.1/bin${PATH:+:${PATH}}' >> ~/.bashrc


    echo '#Add CUDA CUPTI environment' >> ~/.bashrc
    echo 'LD_LIBRARY_PATH=/usr/local/cuda-10.1/extras/CUPTI/lib64${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}' >> ~/.bashrc



    sudo apt update
    sudo apt upgrade -y
    echo "Exit in 10 seconds"
    sleep 10
    echo "OPENCV_SETUPSTATE="3"" > .setupstate
    sudo reboot
    ;;



  3)
    echo -e "Install OpenCV requirements \n\n"
    sleep 10
    
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
    sleep 10
    
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
    sleep 10
    
    ./build-opencv.sh

    sudo apt autoremove -y
    sudo apt update
    sudo apt upgrade -y
    echo "Exit in 10 seconds"
    sleep 10
    echo "OPENCV_SETUPSTATE="6"" > .setupstate
    sudo reboot
    ;;


  6)
    echo -e "Test OpenCV \n\n"
    sleep 10

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



  *)
    echo -e "unknown install state \n\n"
    read  -n 1 -p "Input Selection:"
    ;;

esac


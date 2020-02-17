
# Disable the lock screen
gsettings set org.gnome.desktop.lockdown disable-lock-screen 'true'


jarleven@stue:~/opencv/samples/gpu$ nvcc bgfg_segm.cpp -o bgfg_segm `pkg-config --cflags --libs opencv4`

jarleven@stue:~/opencv/samples/gpu$ g++ -ggdb background_subtraction.cpp -o background_subtraction `pkg-config --cflags --libs opencv4` -I /usr/local/cuda/include/

~/.bashrc

#export LD_LIBRARY_PATH="/usr/local/cuda/lib64:$LD_LIBRARY_PATH"
#export LD_LIBRARY_PATH=/usr/local/cuda/lib64${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}
#export PATH="/usr/local/cuda/bin/:$PATH"



export PATH=/usr/local/cuda-10.0/bin${PATH:+:${PATH}}
export LD_LIBRARY_PATH=/usr/local/cuda-10.0/lib${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}



alias python=python3


sudo -u username command

sudo -u 

https://askubuntu.com/questions/425754/how-do-i-run-a-sudo-command-inside-a-script


https://egpu.io/forums/pro-applications/easy-video-encoding-benchmark-test-your-gpu-within-seconds/

ffmpeg -i file_example_MP4_1920_18MG.mp4 -c:v hevc_nvenc -c:a copy -b:v 3M -bufsize 16M -maxrate 6M outhevcNvidia.mp4

watch -n 0.5 nvidia-smi


TEST DATA AND PATHS
https://github.com/opencv/opencv/issues/11816


x-terminal-emulator -e /home/jarleven/CUDA-OpenCV/CUDA102-OpenCV420/versions.sh --noclose

mkdir ~/.config/autostart
jarleven@stue:~$ cp CUDA-OpenCV/CUDA102-OpenCV420/opencv.desktop ~/.config/autostart/












echo 'foobar ALL=(ALL:ALL) ALL' | sudo EDITOR='tee -a' visudo

sudo -u jarleven /home/jarleven/CUDA-OpenCV/CUDA102-OpenCV420/setup.sh


echo 'sudo -u jarleven /home/jarleven/CUDA-OpenCV/CUDA102-OpenCV420/setup.sh' | sudo EDITOR='tee -a' visudo




http://ubuntuguide.net/how-to-login-without-password-in-ubuntu-11-10

This is easy, just click on top-right your user name and launch System Settings -> User Accounts . Click Unlock and enter the password. Now, double click on pass-phrase after Password and you'll see following pic. Choose “Login without a password” in first drop-down box and click “Change” at bottom.

How to Login Without Password in Ubuntu 11.10 - Ubuntu ...


add xterm

Change to folder of script location

#!/bin/bash
cd "$(dirname "$0")"


https://www.cyberciti.biz/faq/linux-unix-running-sudo-command-without-a-password/

#includedir /etc/sudoers.d
jarleven ALL=(ALL) NOPASSWORD:ALL

Add this to /etc/sudoers.d ??


https://www.cyberciti.biz/faq/ubuntu-linux-install-nvidia-driver-latest-proprietary-driver/

apt search nvidia-driver

OR use the apt-cache command to search package:
$ apt-cache search nvidia-driverapt search nvidia-driver

OR use the apt-cache command to search package:
$ apt-cache search nvidia-driver




https://askubuntu.com/questions/46627/how-can-i-make-a-script-that-opens-terminal-windows-and-executes-commands-in-the

x-terminal-emulator

https://www.pyimagesearch.com/2020/02/10/opencv-dnn-with-nvidia-gpus-1549-faster-yolo-ssd-and-mask-r-cnn/
https://www.pyimagesearch.com/2020/02/03/how-to-use-opencvs-dnn-module-with-nvidia-gpus-cuda-and-cudnn/
https://www.pyimagesearch.com/2019/12/09/how-to-install-tensorflow-2-0-on-ubuntu/

https://www.pyimagesearch.com/2016/07/11/compiling-opencv-with-cuda-support/




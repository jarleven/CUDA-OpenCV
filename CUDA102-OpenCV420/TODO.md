

jarleven@stue:~/opencv/samples/gpu$ nvcc bgfg_segm.cpp -o bgfg_segm `pkg-config --cflags --libs opencv4`

jarleven@stue:~/opencv/samples/gpu$ g++ -ggdb background_subtraction.cpp -o background_subtraction `pkg-config --cflags --libs opencv4` -I /usr/local/cuda/include/

# https://devtalk.nvidia.com/default/topic/1069698/cuda-setup-and-installation/installing-cuda-toolkit-10-0-on-ubuntu-18-results-in-black-boot-screen/

# Tensorflow 
# https://www.tensorflow.org/install/gpu


#
# Building this example worked on the CUDA 10.1 setup
# https://stackoverflow.com/a/27133452
#

nvcc `pkg-config --libs opencv4` -L. -L/usr/local/cuda/lib -lcuda -lcudart `pkg-config --cflags opencv4` -I . -I /usr/local/cuda-10.1 videostab.cpp -o vidstab


https://egpu.io/forums/pro-applications/easy-video-encoding-benchmark-test-your-gpu-within-seconds/

ffmpeg -i file_example_MP4_1920_18MG.mp4 -c:v hevc_nvenc -c:a copy -b:v 3M -bufsize 16M -maxrate 6M outhevcNvidia.mp4

watch -n 0.5 nvidia-smi


TEST DATA AND PATHS
https://github.com/opencv/opencv/issues/11816




https://www.cyberciti.biz/faq/ubuntu-linux-install-nvidia-driver-latest-proprietary-driver/

apt search nvidia-driver

OR use the apt-cache command to search package:
$ apt-cache search nvidia-driverapt search nvidia-driver

OR use the apt-cache command to search package:
$ apt-cache search nvidia-driver





https://www.pyimagesearch.com/2020/02/10/opencv-dnn-with-nvidia-gpus-1549-faster-yolo-ssd-and-mask-r-cnn/
https://www.pyimagesearch.com/2020/02/03/how-to-use-opencvs-dnn-module-with-nvidia-gpus-cuda-and-cudnn/
https://www.pyimagesearch.com/2019/12/09/how-to-install-tensorflow-2-0-on-ubuntu/

https://www.pyimagesearch.com/2016/07/11/compiling-opencv-with-cuda-support/



git config --global user.email "jarleven@gmail.com" \
git config --global user.name "Jarl Even Englund"

sudo add-apt-repository ppa:graphics-drivers/ppa



# 
# lspci | grep -i GTX
# 01:00.0 VGA compatible controller: NVIDIA Corporation GP106 [GeForce GTX 1060 3GB] (rev a1)

#sudo apt install -y git wget
# git clone
# cd ~/CUDA
# ./setup.sh


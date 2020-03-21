source ~/CUDA-OpenCV/CUDA102-OpenCV420/environmet.sh

cd /home/$USER/opencv/samples/gpu


g++ -ggdb bgfg_segm.cpp -o bgfg_segm `pkg-config --cflags --libs opencv4` -I /usr/local/cuda-10.1/include/
g++ -ggdb video_reader.cpp -o video_reader `pkg-config --cflags --libs opencv4` -I /usr/local/cuda-10.1/include/


nvcc `pkg-config --libs opencv4` -L. -L /usr/local/cuda-10.1/lib64 -lcuda -lcudart `pkg-config --cflags opencv4` -I . -I /usr/local/cuda-10.1 video_reader.cpp -o video_reader


TIMEIN=`date +%s` && ./video_reader /media/$USER/CUDA/syd__2019-06-28__05-00-00.mp4 && TIMEOUT=`date +%s` && echo $TIMEIN && echo $TIMEOUT && TIMEDIFF=$(( TIMEOUT - TIMEIN )) && echo "Process in $TIMEDIFF seconds"


TIMEDIFF=$(( TIMEOUT - TIMEIN )) && echo "Process in $TIMEDIFF seconds"




https://www.linuxbabe.com/command-line/create-ramdisk-linux

sudo mkdir /tmp/ramdisk && sudo chmod 777 /tmp/ramdisk
sudo mount -t tmpfs -o size=1024m myramdisk /tmp/ramdisk

sudo mount -t tmpfs -o size=1G myramdisk /tmp/ramdisk



OpenCV search strings

HAVE_OPENCV_CUDACODEC
NVIDIA
video_reader.cpp
Object detection
OpenCV
Tensorflow
NVCUVID
CUDACODEC
dynlink_cuviddec.h
dynlink_nvcuvid.h
nvcuvid.h
cuviddec.h

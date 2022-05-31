#####################################################################################################
##Start inference on the GPU:

sudo mkdir -p /mnt/filserver
udisksctl  mount -p block_devices/sdb2
sudo sshfs -o allow_other jarleven@192.168.1.199:/RAID/storage/2022 /mnt/filserver

# ultralytics/yolov5:latest (13GB of disk space, 82GB->69GB   after FFMPEG / TensorRT 64GB free)

screen -S docker
sudo docker run --ipc=host -it  --gpus all -v $HOME/test:/model  -v /mnt/filserver:/fileserv  ultralytics/yolov5:latest

sudo docker run --ipc=host -it  --gpus all -v  /media/jarleven/42374662-0f5f-4fb5-aa8a-f7c659a40607/2022/test:/model  -v /mnt/filserver:/fileserv  ultralytics/yolov5:latest


	/model/yolov5_config.sh
	/model/detect.sh


#####################################################################################################
## Start the video encode/upload on the GPU

screen -S upload
cd ~
./create_movie.sh 
	


jarleven@Precision-T3600:/var/lib$ sudo du -hsx /var/lib/* | sort -rh | head -n 40
86G     /var/lib/docker

## THIS WILL DELETE EVERYTHING !!!!
sudo docker system prune -a -f


https://alpslabel.wordpress.com/2017/03/20/alps-label-crop-tool/



12:52:33  opening video /fileserv/2022-05-26/CAM1__2022-05-26__00-15-00.mp4
12:54:14  opening video /fileserv/2022-05-26/CAM1__2022-05-26__00-30-00.mp4


du -h test/small/ &&  du -h test/full/ && ls -1 test/small | wc -l && ls -1 test/full | wc -l


0 1 * * * /home/jarleven/move_day.sh
@reboot (. ~/.profile; /usr/bin/screen -dmS YouTube ~/stream_file.sh)


30 1 * * * (. ~/.profile; /usr/bin/screen -dmS Uplo ~/detect.sh)

12 10 * * * (. ~/.profile; /usr/bin/screen -dmS Inference ~/create_movie.sh)

# https://stackoverflow.com/questions/4880290/how-do-i-create-a-crontab-through-a-script
# https://serverfault.com/questions/233084/how-do-i-use-crontab-to-start-a-screen-session

{ crontab -l -u jarleven; echo '24 10 * * * (. ~/.profile; /usr/bin/screen -dmS Upload ~/create_movie.sh)'; } | crontab -u jarleven -



@reboot (. ~/.profile; /usr/bin/screen -dmS YouTube ~/stream_file.sh)


{ crontab -l -u jarleven; echo '30 1 * * * (. ~/.profile; /usr/bin/screen -dmS Inference /model/detect.sh)'; } | crontab -u jarleven -

{ crontab -l -u root; echo '30 1 * * * (. ~/.profile; /usr/bin/screen -dmS Inference /model/detect.sh)'; } | crontab -u root -



apt-get install -y cron



sudo mkdir -p /mnt/filserver
sudo sshfs -o allow_other jarleven@192.168.1.165:/home/jarleven/laksenArcive/Archive /mnt/filserver
sudo sshfs -o allow_other jarleven@192.168.1.199:/RAID/storage/2022 /mnt/filserver

30 1 * * * (. ~/.profile; /usr/bin/screen -dmS Inference /model/detect.sh)



/dev/sdb2    916G  216G  654G  25% /media/jarleven/42374662-0f5f-4fb5-aa8a-f7c659a40607




Current default time zone: 'Europe/Oslo'
Local time is now:      Fri May 27 10:28:45 CEST 2022.
Universal Time is now:  Fri May 27 08:28:45 UTC 2022.

rm: cannot remove '/model/small/*': No such file or directory
rm: cannot remove '/model/full/*': No such file or directory
rm: cannot remove '/model/completed__2022-05-26.txt': No such file or directory
det


*********************
********

# https://forum.opencv.org/t/reading-and-writing-videos-python-on-gpu-with-cuda-videocapture-and-videowriter/156/10
#
# On a related if you are on linux and your version of Ffmpeg is built with Nvidia HW acceleration 20 you should be able to set the below variable
# 
# 'OPENCV_FFMPEG_CAPTURE_OPTIONS=video_codec;h264_cuvid'
# and cv::VideoCapture()should perform the video decoding on your GPU.
#
# https://docs.nvidia.com/video-technologies/video-codec-sdk/ffmpeg-with-nvidia-gpu/

python3 -m pip install nvidia-pyindex nvidia-tensorrt

git clone https://git.videolan.org/git/ffmpeg/nv-codec-headers.git
cd nv-codec-headers && make install && cd –
git clone https://git.ffmpeg.org/ffmpeg.git ffmpeg/

apt install -y build-essential yasm cmake libtool libc6 libc6-dev unzip wget libnuma1 libnuma-dev
cd ffmpeg
./configure --enable-nonfree --enable-cuda-nvcc --enable-libnpp --extra-cflags=-I/usr/local/cuda/include --extra-ldflags=-L/usr/local/cuda/lib64 --enable-static --disable-shared

make -j 12
make install

ffmpeg -decoders 2>/dev/null | grep h264_cuvid



cd /usr/src/app/

cp /model/detect_jee_v9.py .
cp /model/datasets.py utils/

python export.py --device 0 --weights /model/fiskAI_v2.pt --include onnx

## Some use cases for streaming and recording files

#### Install reboot after installing drivers and installing CUDA
Procedure for Ubuntu 18.04.5 Desktop<br/>
A USB thumbdrive named CUDA with a folder CUDAFILES is expected
```console

udisksctl mount -b /dev/disk/by-label/CUDA
ls -alh /media/$USER/CUDA/CUDAFILES/Video_Codec_SDK_9.1.23.zip

mkdir -p /home/$USER/CUDAFILES
cp -n /media/$USER/CUDA/CUDAFILES/Video_Codec_SDK_9.1.23.zip /home/$USER/CUDAFILES/

```

```console
sudo apt install -y ssh vim screen
sudo apt install -y git
git clone https://github.com/jarleven/CUDA-OpenCV.git

CUDA-OpenCV/CUDA102-OpenCV420/install-nvidia.sh
sudo reboot
CUDA-OpenCV/CUDA102-OpenCV420/cuda-10.2.sh
sudo reboot
CUDA-OpenCV/CUDA102-OpenCV420/build-ffmpeg.sh
	
TODO ....

```

#### Obviously the "hwdownload" eats my CPU. One more take on this issue
Thanks to :<br/>
https://www.mail-archive.com/ffmpeg-devel@ffmpeg.org/msg99202.html

```console
ffmpeg -y \
  -init_hw_device cuda=cuda -filter_hw_device cuda -hwaccel cuvid \
  -c:v h264_cuvid -rtsp_transport tcp -i $PRIMARYINPUT \
  -i "$OVERLAY" \
  -r 24 -ar 44100 -ac 2 -acodec pcm_s16le -f s16le -ac 2 -i /dev/zero  \
  -filter_complex "[1:v]format=yuva420p, hwupload[o], [v:0]scale_npp=format=yuv420p[m], [m][o]overlay_cuda=x=0:y=0:shortest=false" \
  -acodec aac -ab 128k \
  -c:v h264_nvenc -b:v 5M \
  -f flv "rtmp://x.rtmp.youtube.com/live2/$YOUTUBEKEY"
```




#### Stream directly to YouTube 4K H.265 camera, GPU accelerated 
```console
ffmpeg -thread_queue_size 1024 \
       -hwaccel cuvid -c:v hevc_cuvid -deint 2 \
       -drop_second_field 1 -vsync 0 \
       -rtsp_transport tcp -i $PRIMARYINPUT \
       -r 24 -ar 44100 -ac 2 -acodec pcm_s16le -f s16le -ac 2 -i /dev/zero -acodec aac -ab 128k \
       -vcodec h264_nvenc -b:v 25M -forced-idr 1 -force_key_frames "expr:gte(t,n_forced*4)" \
       -f flv "rtmp://x.rtmp.youtube.com/live2/$YOUTUBEKEY"
```
#### Stream directly to YouTube 4K H.265 camera with overlay, GPU accelerated
```console
ffmpeg -thread_queue_size 1024 \
       -hwaccel cuvid -c:v hevc_cuvid -deint 2 \
       -drop_second_field 1 -vsync 0 \
       -rtsp_transport tcp -i $PRIMARYINPUT \
       -i "$OVERLAY" \
       -r 24 -ar 44100 -ac 2 -acodec pcm_s16le -f s16le -ac 2 -i /dev/zero  \
       -filter_complex "[0:v]hwdownload,format=nv12 [base]; [base][1:v] overlay=128 [marked]" \
       -map "[marked]:v" \
       -map "2:a" \
       -acodec aac -ab 128k \
       -vcodec h264_nvenc -b:v 25M -forced-idr 1 -force_key_frames "expr:gte(t,n_forced*4)" \
       -f flv "rtmp://x.rtmp.youtube.com/live2/$YOUTUBEKEY"
```


#### Stream directly to YouTube FullHD H.264 camera with overlay, GPU accelerated
```console
ffmpeg -thread_queue_size 1024 \
       -hwaccel cuvid -c:v h264_cuvid -deint 2 \
       -drop_second_field 1 -vsync 0 \
       -rtsp_transport tcp -i $PRIMARYINPUT \
       -i "$OVERLAY" \
       -r 24 -ar 44100 -ac 2 -acodec pcm_s16le -f s16le -ac 2 -i /dev/zero  \
       -filter_complex "[0:v]hwdownload,format=nv12 [base]; [base][1:v] overlay=0 [marked]" \
       -map "[marked]:v" \
       -map "2:a" \
       -acodec aac -ab 128k \
       -vcodec h264_nvenc -b:v 25M -forced-idr 1 -force_key_frames "expr:gte(t,n_forced*4)" \
       -f flv "rtmp://x.rtmp.youtube.com/live2/$YOUTUBEKEY"
```

#### Stream directly to YouTube FullHD H.264 camera with overlay, GPU accelerated
Update the watermark/overlay every second
```console
ffmpeg -thread_queue_size 1024 \
       -hwaccel cuvid -c:v h264_cuvid -deint 2 \
       -drop_second_field 1 -vsync 0 \
       -rtsp_transport tcp -i $PRIMARYINPUT \
       -f image2 -stream_loop -1 -re -i "$OVERLAY" \
       -r 24 -ar 44100 -ac 2 -acodec pcm_s16le -f s16le -ac 2 -i /dev/zero  \
       -filter_complex "[0:v]hwdownload,format=nv12 [base]; [base][1:v] overlay=0 [marked]" \
       -map "[marked]:v" \
       -map "2:a" \
       -acodec aac -ab 128k \
       -vcodec h264_nvenc -b:v 25M -forced-idr 1 -force_key_frames "expr:gte(t,n_forced*4)" \
       -f flv "rtmp://x.rtmp.youtube.com/live2/$YOUTUBEKEY"


ffmpeg -thread_queue_size 1024 \
       -hwaccel cuvid -c:v h264_cuvid -deint 2 \
       -drop_second_field 1 -vsync 0 \
       -rtsp_transport tcp -i $PRIMARYINPUT \
       -f image2 -stream_loop -1 -r 2 -i "$OVERLAY" \
       -r 24 -ar 44100 -ac 2 -acodec pcm_s16le -f s16le -ac 2 -i /dev/zero  \
       -filter_complex "[0:v]hwdownload,format=nv12 [base]; [base][1:v] overlay=0 [marked]" \
       -map "[marked]:v" \
       -map "2:a" \
       -acodec aac -ab 128k \
       -vcodec h264_nvenc -b:v 25M -forced-idr 1 -force_key_frames "expr:gte(t,n_forced*4)" \
       -f flv "rtmp://x.rtmp.youtube.com/live2/$YOUTUBEKEY"


"Stream health is excellent" according to Youtube.
"The audio stream's current bitrate (0) is lower than the recommended bitrate. We recommend that you use an audio stream bitrate of 128 Kbps."

ffmpeg -thread_queue_size 1024 \
       -hwaccel cuvid -hwaccel_output_format cuda -c:v h264_cuvid -deint 2 \
       -drop_second_field 1 -vsync 0 \
       -rtsp_transport tcp -i $PRIMARYINPUT?buffer_size=10000000?fifo_size=100000 \
       -f image2 -stream_loop -1 -r 2 -i "$OVERLAY" \
       -f lavfi -i anullsrc \
       -filter_complex "[0:v]hwdownload,format=nv12 [base]; [base][1:v] overlay=0 [marked]" \
       -map "[marked]:v" \
       -map "2:a" \
       -acodec aac -ac 2 -b:a 128k \
       -vcodec h264_nvenc -b:v 4.5M -rc vbr -rc-lookahead:v 32 -forced-idr 1 -force_key_frames "expr:gte(t,n_forced*4)" \
       -f flv "rtmp://x.rtmp.youtube.com/live2/$YOUTUBEKEY"





       -filter_complex "[0:v]hwdownload,format=nv12 [base]; [base][1:v] overlay=0:enable='between(t,10,90)' [marked]" \

```



#### For ease of use a few shell variables have been defined, edit according to your needs

```console
YOUTUBEKEY=1abc-2def-3ghi-4jkl \
PRIMARYINPUT="rtsp://192.168.1.89:554/user=admin&password=&channel=1&stream=0.sdp?" \
OVERLAY=Philips_Pattern_pm5644.png \
OUTFILE=/tmp/ramdisk/out.mp4

```

#### Need verification and CLEANUP. Notes about the FullHD H.264 camera, both GPU and CPU processing examples 
```console
ffmpeg	-f lavfi -i anullsrc \
	-thread_queue_size 512 -vsync 0 \
	-rtsp_transport udp -i "rtsp://192.168.1.87:554/user=admin&password=&channel=1&stream=0.sdp?real_stream" \
	-vcodec libx264 -t 12:00:00 -pix_fmt + -c:v copy -c:a aac -strict experimental \
	-f flv rtmp://x.rtmp.youtube.com/live2/$YOUTUBEKEY
```

#### Dump RTSP stream to a file without transcoding
```console
ffmpeg -rtsp_transport tcp -i $PRIMARYINPUT -c copy -map 0 -f segment -strftime 1 -reset_timestamps 1 -segment_time 900 -segment_atclocktime 1 -segment_format mp4 "YourOwnPrefix__%Y-%m-%d__%H-%M-%S.mp4"
```

#### A few details about the gear installed
```
.89 4K kamera
Resolution : 4096x2160

.87 FullHD kamera
```



#### A test pattern 
https://commons.wikimedia.org/wiki/Category:Test_patterns

```console
wget https://upload.wikimedia.org/wikipedia/commons/4/47/Philips_Pattern_pm5644.png

convert -pointsize 40 -fill white -draw 'text 436,92 "Eidselva"' Philips_Pattern_pm5644.png -resize 4096x2160 Philips_Pattern_pm5644.png

convert -pointsize 40 -fill white -draw 'text 436,92 "Eidselva"' -draw 'text 582,302 "12:30:30"' Philips_Pattern_pm5644.png -resize 4096x2160 Philips_Pattern_pm5644.png

CLOCKNOW=`date '+%H:%M:%S'`
convert -pointsize 40 -fill white -undercolor Black -draw 'text 436,88 "Eidselva"' -draw "text 582,298 \"$CLOCKNOW\"" Philips_Pattern_pm5644.png -resize 4096x2160 Philips_Pattern_pm5644.png




wget https://www.jeggikkbareibodenentur.no/wp-content/uploads/2017/02/vi-beklager-teknisk-feil.jpg
convert vi-beklager-teknisk-feil.jpg -threshold 70% -negate -transparent white vi-beklager-teknisk-feil.png

```


Youtube feedback for various testing on the FullHD camera
```
The stream's current bitrate (15652.07 Kbps) is higher than the recommended bitrate. We recommend that you use a stream bitrate of 4500 Kbps.
The audio stream's current bitrate (0) is lower than the recommended bitrate. We recommend that you use an audio stream bitrate of 128 Kbps.
```

```console
ffmpeg -version
ffmpeg version 4.4 Copyright (c) 2000-2021 the FFmpeg developers
built with gcc 7 (Ubuntu 7.5.0-3ubuntu1~18.04)
configuration: --enable-shared --disable-static --enable-cuda --enable-cuda-nvcc --enable-cuvid --enable-nvenc --enable-nonfree --enable-libnpp --enable-avfilter --extra-cflags=-I/usr/local/cuda-10.2/include --extra-ldflags=-L/usr/local/cuda-10.2/lib64
libavutil      56. 70.100 / 56. 70.100
libavcodec     58.134.100 / 58.134.100
libavformat    58. 76.100 / 58. 76.100
libavdevice    58. 13.100 / 58. 13.100
libavfilter     7.110.100 /  7.110.100
libswscale      5.  9.100 /  5.  9.100
libswresample   3.  9.100 /  3.  9.100



nvidia-smi
Wed May 26 13:04:22 2021
+-----------------------------------------------------------------------------+
| NVIDIA-SMI 460.80       Driver Version: 460.80       CUDA Version: 11.2     |
|-------------------------------+----------------------+----------------------+
| GPU  Name        Persistence-M| Bus-Id        Disp.A | Volatile Uncorr. ECC |
| Fan  Temp  Perf  Pwr:Usage/Cap|         Memory-Usage | GPU-Util  Compute M. |
|                               |                      |               MIG M. |
|===============================+======================+======================|
|   0  GeForce GTX 106...  Off  | 00000000:01:00.0  On |                  N/A |
|  0%   46C    P8     6W / 120W |     74MiB /  3017MiB |      0%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+

+-----------------------------------------------------------------------------+
| Processes:                                                                  |
|  GPU   GI   CI        PID   Type   Process name                  GPU Memory |
|        ID   ID                                                   Usage      |
|=============================================================================|
|    0   N/A  N/A       979      G   /usr/lib/xorg/Xorg                 21MiB |
|    0   N/A  N/A      1035      G   /usr/bin/gnome-shell               50MiB |
+-----------------------------------------------------------------------------+

lspci
01:00.0 VGA compatible controller: NVIDIA Corporation GP106 [GeForce GTX 1060 3GB] (rev a1)
01:00.1 Audio device: NVIDIA Corporation GP106 High Definition Audio Controller (rev a1)


```



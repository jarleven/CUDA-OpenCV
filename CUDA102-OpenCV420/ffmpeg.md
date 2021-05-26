## Some use cases for streaming and recoring files

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
       -rtsp_transport tcp -i $INPUTSTREAM \
       -i "$OVERLAY" \
       -r 24 -ar 44100 -ac 2 -acodec pcm_s16le -f s16le -ac 2 -i /dev/zero  \
       -filter_complex "[0:v]hwdownload,format=nv12 [base]; [base][1:v] overlay=128 [marked]" \
       -map "[marked]:v" \
       -map "2:a" \
       -acodec aac -ab 128k \
       -vcodec h264_nvenc -b:v 25M -forced-idr 1 -force_key_frames "expr:gte(t,n_forced*4)" \
       -f flv "rtmp://x.rtmp.youtube.com/live2/$YOUTUBEKEY"
```


#### Template
```console

```



#### For ease of use a few shell variables have been defined, edit according to your needs

```console
YOUTUBEKEY=1abc-2def-3ghi-4jkl
PRIMARYINPUT="rtsp://192.168.1.89:554/user=admin&password=&channel=1&stream=0.sdp?"
OVERLAY=Philips_Pattern_pm5644.jpg
OUTFILE=/tmp/ramdisk/out.mp4

```

#### Need verification and CLEANUP. Notes about the FullHD H.264 camera, both GPU and CPU processing examples 
```console
ffmpeg	-f lavfi -i anullsrc \
	-thread_queue_size 512 -vsync 0 \
	-rtsp_transport udp -i "rtsp://192.168.1.87:554/user=admin&password=&channel=1&stream=0.sdp?real_stream" \
	-vcodec libx264 -t 12:00:00 -pix_fmt + -c:v copy -c:a aac -strict experimental \
	-f flv rtmp://x.rtmp.youtube.com/live2/$YOUTUBEKEY


ffmpeg -thread_queue_size 1024 \
    -hwaccel cuvid -c:v hevc_cuvid -deint 2 \
    -drop_second_field 1 -vsync 0 \
    -i "$PLAYFILE" \
    -i "$OVERLAY" \
    -f lavfi -i anullsrc \
    -filter_complex "[0:v]hwdownload,format=nv12 [base]; [base][1:v] overlay=main_w-overlay_w-10:10 [marked]" \
    -map "[marked]" \
    -vcodec h264_nvenc -b:v 25M -forced-idr 1 -force_key_frames "expr:gte(t,n_forced*4)" \
    -acodec aac -strict -2 \
    $OUTFILE
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

convert -pointsize 40 -fill white -draw 'text 436,92 "Eidselva"' Philips_Pattern_pm5644.png -resize 4096x2160 Philips_Pattern_pm5644.jpg

convert -pointsize 40 -fill white -draw 'text 436,92 "Eidselva"' -draw 'text 582,302 "12:30:30"' Philips_Pattern_pm5644.png -resize 4096x2160 Philips_Pattern_pm5644.jpg

CLOCKNOW=`date '+%H:%M:%S'`
convert -pointsize 40 -fill white -undercolor Black -draw 'text 436,88 "Eidselva"' -draw "text 582,298 \"$CLOCKNOW\"" Philips_Pattern_pm5644.png -resize 4096x2160 Philips_Pattern_pm5644.jpg
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



```



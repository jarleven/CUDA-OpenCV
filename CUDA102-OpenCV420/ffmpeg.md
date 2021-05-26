## Some use cases for streaming and recoring files


### Stream directly to YouTube 4K H.265 camera, GPU accelerated 
```console
ffmpeg -thread_queue_size 1024 \
       -hwaccel cuvid -c:v hevc_cuvid -deint 2 \
       -drop_second_field 1 -vsync 0 \
       -rtsp_transport tcp -i $PRIMARYINPUT \
       -r 24 -ar 44100 -ac 2 -acodec pcm_s16le -f s16le -ac 2 -i /dev/zero -acodec aac -ab 128k \
       -vcodec h264_nvenc -b:v 25M -forced-idr 1 -force_key_frames "expr:gte(t,n_forced*4)" \
       -f flv "rtmp://x.rtmp.youtube.com/live2/$KEY"
```
### Stream directly to YouTube 4K H.265 camera with overlay, GPU accelerated
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
       -f flv "rtmp://x.rtmp.youtube.com/live2/$KEY"
```


### Template
```console

```



### For ease of use a few shell variables have been defined, edit according to your needs

```console
YOUTUBEKEY=1ab-2cd-3fgh-4ijk
PRIMARYINPUT="rtsp://192.168.1.89:554/user=admin&password=&channel=1&stream=0.sdp?"
OVERLAY=Philips_Pattern_pm5644.jpg


```

### A test pattern 
https://commons.wikimedia.org/wiki/Category:Test_patterns

```console
wget https://upload.wikimedia.org/wikipedia/commons/4/47/Philips_Pattern_pm5644.png

convert -pointsize 40 -fill white -draw 'text 436,92 "Eidselva"' Philips_Pattern_pm5644.png -resize 4096x2160 Philips_Pattern_pm5644.jpg

convert -pointsize 40 -fill white -draw 'text 436,92 "Eidselva"' -draw 'text 582,302 "12:30:30"' Philips_Pattern_pm5644.png -resize 4096x2160 Philips_Pattern_pm5644.jpg

CLOCKNOW=`date '+%H:%M:%S'`
convert -pointsize 40 -fill white -undercolor Black -draw 'text 436,88 "Eidselva"' -draw "text 582,298 \"$CLOCKNOW\"" Philips_Pattern_pm5644.png -resize 4096x2160 Philips_Pattern_pm5644.jpg
```

### Raspberry Pi

```
https://forums.raspberrypi.com/viewtopic.php?t=170341

./configure --enable-mmal --enable-omx-rpi --enable-omx --prefix=/usr


```

### An effort to get ffmpeg running on the NVIDIA GPU
### I hit the wall last time when trying to add support for text overlay

https://developer.nvidia.com/ffmpeg

### 1
ERROR: libnpp not found

Hmm, what do we need here ?


```
apt-get update -qq && apt-get -y install \
  autoconf \
  automake \
  build-essential \
  cmake \
  git-core \
  libass-dev \
  libfreetype6-dev \
  libsdl2-dev \
  libtool \
  libva-dev \
  libvdpau-dev \
  libvorbis-dev \
  libxcb1-dev \
  libxcb-shm0-dev \
  libxcb-xfixes0-dev \
  pkg-config \
  texinfo \
  wget \
  zlib1g-dev \
  cuda-npp-10-0 \
  cuda-npp-dev-10-0 
```  
## 2
  No cigar, 
```
./configure --enable-cuda-sdk --enable-cuvid --enable-nvenc --enable-nonfree
```

## 3
WARNING: Option --enable-cuda-sdk is deprecated. Use --enable-cuda-nvcc instead.

```
./configure --enable-cuda-nvcc --enable-cuvid --enable-nvenc --enable-nonfree
```

And also use the extra-cflags paths !
```
./configure --enable-cuda-nvcc --enable-cuvid --enable-nvenc --enable-nonfree --enable-libnpp --extra-cflags=-I/usr/local/cuda/include --extra-ldflags=-L/usr/local/cuda/lib64
```
##4




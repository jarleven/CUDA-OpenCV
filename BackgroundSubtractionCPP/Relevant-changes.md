## Tracking some changes made in OpenCV of parts relavant to this project.

```

wget https://raw.githubusercontent.com/opencv/opencv/3.4.6/samples/gpu/bgfg_segm.cpp -O bgfg_segm_346.cpp \
wget https://raw.githubusercontent.com/opencv/opencv/3.1.0/samples/gpu/bgfg_segm.cpp -O bgfg_segm_310.cpp \
kdiff3 bgfg_segm_310.cpp bgfg_segm_346.cpp

wget https://raw.githubusercontent.com/opencv/opencv/3.4.6/samples/gpu/video_reader.cpp -O video_reader_346.cpp
wget https://raw.githubusercontent.com/opencv/opencv/3.1.0/samples/gpu/video_reader.cpp -O video_reader_310.cpp
kdiff3 video_reader_310.cpp video_reader_346.cpp


```


´´´
[ 52%] Building CXX object modules/cudacodec/CMakeFiles/opencv_cudacodec.dir/src/cuvid_video_source.cpp.o
In file included from /home/jarleven/opencv_contrib/modules/cudacodec/src/cuvid_video_source.cpp:44:0:
/home/jarleven/opencv_contrib/modules/cudacodec/src/precomp.hpp:64:18: fatal error: nvcuvid.h: No such file or directory
         #include <nvcuvid.h>
                  ^~~~~~~~~~~
compilation terminated.
modules/cudacodec/CMakeFiles/opencv_cudacodec.dir/build.make:736: recipe for target 'modules/cudacodec/CMakeFiles/opencv_cudacodec.dir/src/cuvid_video_source.cpp.o' failed
make[2]: *** [modules/cudacodec/CMakeFiles/opencv_cudacodec.dir/src/cuvid_video_source.cpp.o] Error 1
CMakeFiles/Makefile2:9228: recipe for target 'modules/cudacodec/CMakeFiles/opencv_cudacodec.dir/all' failed
make[1]: *** [modules/cudacodec/CMakeFiles/opencv_cudacodec.dir/all] Error 2
Makefile:162: recipe for target 'all' failed
make: *** [all] Error 2
jarleven@Stue:~$ cudacodec/src/precomp.hpp:64:18: fatal error: nvcuvid.h: No such file or directory
-bash: cudacodec/src/precomp.hpp:64:18:: No such file or directory
´´´
Changed
-D WITH_NVCUVID=ON \  >> -D WITH_NVCUVID=OFF \ 
Will try this project with FFMPEG for reading video files. https://developer.nvidia.com/ffmpeg


Running samples

./example_gpu_bgfg_segm 
[ERROR:0] global /home/jarleven/opencv/modules/videoio/src/cap.cpp (116) open VIDEOIO(CV_IMAGES): raised OpenCV exception:

OpenCV(4.2.0) /home/jarleven/opencv/modules/videoio/src/cap_images.cpp:253: error: (-5:Bad argument) CAP_IMAGES: can't find starting number (in the name of file): ../data/vtest.avi in function 'icvExtractPattern'



cp ~/opencv/samples/data/* ~/opencv/build/data/
cp: -r not specified; omitting directory '/home/jarleven/opencv/samples/data/dnn'

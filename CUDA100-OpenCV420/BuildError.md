
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


2nd pass

- Failed to find installed gflags CMake configuration, searching for gflags build directories exported with CMake.
-- Failed to find gflags - Failed to find an installed/exported CMake configuration for gflags, will perform search for installed gflags components.
-- Failed to find gflags - Could not find gflags include directory, set GFLAGS_INCLUDE_DIR to directory containing gflags/gflags.h
-- Failed to find glog - Could not find glog include directory, set GLOG_INCLUDE_DIR to directory containing glog/logging.h
-- Module opencv_sfm disabled because the following dependencies are not found: Glog/Gflags











[ 30%] Building CXX object modules/dnn/CMakeFiles/opencv_dnn.dir/src/vkcom/src/op_pool.cpp.o
[ 30%] Building CXX object modules/dnn/CMakeFiles/opencv_dnn.dir/src/vkcom/src/op_prior_box.cpp.o
[ 30%] Building CXX object modules/dnn/CMakeFiles/opencv_dnn.dir/src/vkcom/src/op_relu.cpp.o
[ 30%] Building CXX object modules/dnn/CMakeFiles/opencv_dnn.dir/src/vkcom/src/op_softmax.cpp.o
[ 30%] Building CXX object modules/dnn/CMakeFiles/opencv_dnn.dir/src/vkcom/src/tensor.cpp.o
[ 30%] Building CXX object modules/dnn/CMakeFiles/opencv_dnn.dir/src/vkcom/vulkan/vk_functions.cpp.o
[ 30%] Building CXX object modules/dnn/CMakeFiles/opencv_dnn.dir/src/vkcom/vulkan/vk_loader.cpp.o
[ 30%] Building CXX object modules/dnn/CMakeFiles/opencv_dnn.dir/layers/layers_common.avx.cpp.o
[ 30%] Building CXX object modules/dnn/CMakeFiles/opencv_dnn.dir/layers/layers_common.avx2.cpp.o
[ 30%] Building CXX object modules/dnn/CMakeFiles/opencv_dnn.dir/layers/layers_common.avx512_skx.cpp.o
[ 30%] Linking CXX shared library ../../lib/libopencv_dnn.so
Scanning dependencies of target opencv_cudafilters
[ 30%] Building CXX object modules/cudafilters/CMakeFiles/opencv_cudafilters.dir/src/filtering.cpp.o
[ 30%] Built target opencv_dnn
[ 30%] Linking CXX shared library ../../lib/libopencv_cudafilters.so
[ 30%] Built target opencv_cudafilters
Makefile:162: recipe for target 'all' failed
make: *** [all] Error 2
[sudo] password for jarleven: 
-- Detected processor: x86_64
-- Looking for ccache - found (/usr/bin/ccache)
-- Found ZLIB: /usr/lib/x86_64-linux-gnu/libz.so (found suitable version "1.2.11", minimum required is "1.2.3") 
-- Could NOT find Jasper (missing: JASPER_LIBRARIES JASPER_INCLUDE_DIR) 
-- Found ZLIB: /usr/lib/x86_64-linux-gnu/libz.so (found version "1.2.11") 
-- Found TBB (env): /usr/lib/x86_64-linux-gnu/libtbb.so
-- found Intel IPP (ICV version): 2019.0.0 [2019.0.0 Gold]
-- at: /home/jarleven/opencv/build/3rdparty/ippicv/ippicv_lnx/icv
-- found Intel IPP Integration Wrappers sources: 2019.0.0
-- at: /home/jarleven/opencv/build/3rdparty/ippicv/ippicv_lnx/iw
-- CUDA detected: 10.2
-- CUDA NVCC targ


 19%] Building CXX object modules/videoio/CMakeFiles/opencv_videoio.dir/src/container_avi.cpp.o
[ 19%] Building CXX object modules/videoio/CMakeFiles/opencv_videoio.dir/src/cap_v4l.cpp.o
[ 19%] Building CXX object modules/videoio/CMakeFiles/opencv_videoio.dir/src/cap_ffmpeg.cpp.o
[ 19%] Linking CXX shared library ../../lib/libopencv_videoio.so
[ 19%] Building CXX object modules/calib3d/CMakeFiles/opencv_calib3d.dir/src/compat_ptsetreg.cpp.o
/usr/bin/ld: /usr/local/lib/libavcodec.a(vc1dsp_mmx.o): relocation R_X86_64_PC32 against symbol `ff_pw_9' can not be used when making a shared object; recompile with -fPIC
/usr/bin/ld: final link failed: Bad value
collect2: error: ld returned 1 exit status
modules/videoio/CMakeFiles/opencv_videoio.dir/build.make:382: recipe for target 'lib/libopencv_videoio.so.4.2.0' failed
make[2]: *** [lib/libopencv_videoio.so.4.2.0] Error 1
CMakeFiles/Makefile2:8463: recipe for target 'modules/videoio/CMakeFiles/opencv_videoio.dir/all' failed
make[1]: *** [modules/videoio/CMakeFiles/opencv_videoio.dir/all] Error 2
make[1]: *** Waiting for unfinished jobs....
[ 19%] Building CXX object modules/calib3d/CMakeFiles/opencv_calib3d.dir/src/dls.cpp.o
[ 19%] Building CXX object modules/calib3d/CMakeFiles/opencv_calib3d.dir/src/epnp.cpp.o
[ 19%] Built target opencv_cvv_autogen


 19%] Building CXX object modules/calib3d/CMakeFiles/opencv_calib3d.dir/src/upnp.cpp.o
[ 19%] Building CXX object modules/calib3d/CMakeFiles/opencv_calib3d.dir/opencl_kernels_calib3d.cpp.o
[ 19%] Building CXX object modules/calib3d/CMakeFiles/opencv_calib3d.dir/undistort.avx2.cpp.o
[ 19%] Linking CXX shared library ../../lib/libopencv_calib3d.so
[ 19%] Built target opencv_calib3d
Makefile:162: recipe for target 'all' failed
make: *** [all] Error 2
[  0%] Built target gen-pkgconfig
[  4%] Built target libwebp
[  6%] Built target libjasper
[  9%] Built target IlmImf
[ 10%
[ 19%] Building

-


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

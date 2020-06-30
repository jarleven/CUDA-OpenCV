#/bin/bash

# Description
# https://gist.github.com/kmhofmann/e368a2ebba05f807fa1a90b3bf9a1e03/e79e25b3a847abe69c392d8ed356e58dc879234a

set -e  # Exit immediately if a command exits with a non-zero status. (Exit on error)
set -x  # Print commands and their arguments as they are executed.
set -u  # Treat unset variables as an error when substituting.


cd ~
sudo apt install -y python3-dev python3-pip
pip3 install -U --user pip six numpy wheel setuptools mock 'future>=0.17.1'
pip3 install -U --user keras_applications --no-deps
pip3 install -U --user keras_preprocessing --no-deps



# Download the Bazel version we need
cd ~
wget https://github.com/bazelbuild/bazel/releases/download/0.29.1/bazel-0.29.1-linux-x86_64

# Replace default Bazel
sudo rm -rf /usr/bin/bazel
sudo mv bazel-0.29.1-linux-x86_64 /usr/bin/bazel
sudo chmod +x /usr/bin/bazel


#If you need to test the installed Bazel version run :
# which bazel
# bazel --version


# Clone the Tensorflow repository
cd ~ 
git clone https://github.com/tensorflow/tensorflow.git
cd tensorflow
git checkout v2.1.0

# Setup environment to use CUDA
# TODO if this is to be generic it should handle different versions of CUDA !
source ~/CUDA-OpenCV/CUDA102-OpenCV420/environmet.sh



bazel build --config=opt \
             --python_path=/usr/bin/python3 \
             --config=cuda \
             --config=tensorrt \
             --config=nonccl \
             --noincompatible_strict_action_env //tensorflow/tools/pip_package:build_pip_package \
             --noincompatible_do_not_split_linking_cmdline

exit


TODO install


bazel build --config=opt --python_path=/usr/bin/python3 --config=cuda --noincompatible_strict_action_env //tensorflow/tools/pip_package:build_pip_package --noincompatible_do_not_split_linking_cmdline




# --noincompatible_do_not_split_linking_cmdline   FOR THE CuDNN issue



TBD...
# BUILD DIRECTLY ON CLI, need to test again
bazel build --config=opt --config=cuda --noincompatible_strict_action_env //tensorflow/tools/pip_package:build_pip_package --noincompatible_do_not_split_linking_cmdline


# Build python package
./bazel-bin/tensorflow/tools/pip_package/build_pip_package /tmp/tensorflow_pkg

# Install python package
pip install /tmp/tensorflow_pkg/tensorflow-2.1.0-cp36-cp36m-linux_x86_64.whl

# --noincompatible_do_not_split_linking_cmdline   FOR THE CuDNN issue



TBD...
# BUILD DIRECTLY ON CLI, need to test again
bazel build --config=opt --config=cuda --noincompatible_strict_action_env //tensorflow/tools/pip_package:build_pip_package --noincompatible_do_not_split_linking_cmdline


# Build python package
./bazel-bin/tensorflow/tools/pip_package/build_pip_package /tmp/tensorflow_pkg

# Install python package
pip install /tmp/tensorflow_pkg/tensorflow-2.1.0-cp36-cp36m-linux_x86_64.whl

Have a look here, does this specify all the build parameters ?
https://github.com/tensorflow/tensorflow/issues/35623


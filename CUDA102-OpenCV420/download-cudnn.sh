
# cudnn 7.6.5 for CUDA 10.2 is available here:
# https://developer.nvidia.com/rdp/cudnn-download

cd ~
# tar -zxf cudnn-10.2-linux-x64-v7.6.5.32.tgz

cd cuda
sudo cp -P lib64/* /usr/local/cuda/lib64/
sudo cp -P include/* /usr/local/cuda/include/
cd ~

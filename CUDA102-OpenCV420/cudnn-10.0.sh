# cudnn 7.6.5 for CUDA 10.2 is available here:
# https://developer.nvidia.com/rdp/cudnn-download


# Link to cuDNN for CUDA 10.0
# https://developer.nvidia.com/rdp/cudnn-download#a-collapse765-10

source .setupvars

cd ~

#sudo dpkg -i libcudnn7_7.6.5.32-1+cuda10.0_amd64.deb
#sudo dpkg -i libcudnn7-dev_7.6.5.32-1+cuda10.0_amd64.deb 
#sudo dpkg -i libcudnn7-doc_7.6.5.32-1+cuda10.0_amd64.deb 


sudo dpkg -i libcudnn7_7.6.4.38-1+cuda10.0_amd64.deb
sudo dpkg -i libcudnn7-dev_7.6.4.38-1+cuda10.0_amd64.deb
sudo dpkg -i libcudnn7-doc_7.6.4.38-1+cuda10.0_amd64.deb





cp -r /usr/src/cudnn_samples_v7/ $HOME
cd  $HOME/cudnn_samples_v7/mnistCUDNN
make clean && make
./mnistCUDNN

# TDOD we can test that this command was OK









#while true
#do
#
#    if md5sum -c cudnn-10.0.md5; then
#        # The MD5 sum matched
#        echo "OK, found cuDNN files"
#
#        tar -zxf  cudnn-10.0-linux-x64-v7.6.5.32.tgz
#        cd cuda
#        sudo cp -P lib64/* /usr/local/cuda-10.0/lib64/
#        sudo cp -P include/* /usr/local/cuda-10.0/include/
#
#        break
#
#    else
#        echo "cuDNN installer not found, please download from link below and save cudnn-10.2-linux-x64-v7.6.5.32.tgz in home directory "
#        echo "https://developer.nvidia.com/rdp/cudnn-download"
#	sleep 10
#    fi
#
#done


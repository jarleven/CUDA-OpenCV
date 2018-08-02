Automated script according to the following description
 * https://www.nvidia.com/en-us/data-center/gpu-accelerated-applications/tensorflow/
 
 
 
 * 64-bit Linux
 * Python 2.7
 * CUDA 7.5 (CUDA 8.0 required for Pascal GPUs)
 * cuDNN v5.1 (cuDNN v6 if on TF v1.3)



sudo apt-get install -y libcupti-dev
sudo apt install -y python-pip

### pip install --upgrade pip
### hash -d pip
### pip install --user --upgrade pip

### pip install tensorflow-gpu

# Tensorflow for CUDA 8 !!!
pip install tensorflow-gpu==1.4.1

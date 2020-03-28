#!/bin/bash



# https://github.com/protocolbuffers/protobuf/releases/

cd ~
sudo apt-get install autoconf automake libtool curl make g++ unzip



wget https://github.com/protocolbuffers/protobuf/releases/download/v3.11.4/protobuf-all-3.11.4.tar.gz

#wget https://github.com/protocolbuffers/protobuf/releases/download/v3.6.1/protobuf-all-3.6.1.tar.gz 

tar xvzf protobuf-all-3.11.4.tar.gz
cd protobuf-3.11.4
./configure
make -j$(nproc)
make check
sudo make install
sudo ldconfig 


#!/bin/bash

DISKSIZE=4G
DISKSIZE=$(grep MemTotal /proc/meminfo |  awk '{printf "%.0fG", $2=0.3*$2/1024^2}')


sudo mkdir -p /tmp/ramdisk
sudo chmod 777 /tmp/ramdisk
sudo mount -t tmpfs -o size=$DISKSIZE myramdisk /tmp/ramdisk

mkdir -p /tmp/ramdisk/full
mkdir -p /tmp/ramdisk/log

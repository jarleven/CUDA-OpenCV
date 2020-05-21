#!/bin/bash


sudo mkdir -p /tmp/ramdisk
sudo chmod 777 /tmp/ramdisk
sudo mount -t tmpfs -o size=4G myramdisk /tmp/ramdisk
mkdir -p /tmp/ramdisk/full


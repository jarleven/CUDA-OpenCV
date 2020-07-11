#!/bin/bash

# Not really the place for this kind of stuff but for the record and my own convinience I save this here


sudo -i

echo -e "deb http://downloads.linux.hpe.com/SDR/repo/mcp/ bionic/current non-free" > /etc/apt/sources.list.d/hpe.list
curl http://downloads.linux.hpe.com/SDR/hpPublicKey1024.pub       | apt-key add - 
curl http://downloads.linux.hpe.com/SDR/hpPublicKey2048.pub       | apt-key add -
curl http://downloads.linux.hpe.com/SDR/hpPublicKey2048_key1.pub  | apt-key add -
curl http://downloads.linux.hpe.com/SDR/hpePublicKey2048_key1.pub | apt-key add -
apt-get update && apt-get upgrade -y && apt-get install -y ssacli


#!/bin/bash

#https://gist.github.com/douglasrizzo/c70e186678f126f1b9005ca83d8bd2ce

cd ~

git clone https://github.com/douglasrizzo/detection_util_scripts.git

pip install pandas
pip install sklearn

echo "Copy annotated images from USB"
cp -r /media/$USER/CUDA/salmon/ ~/ 


cd detection_util_scripts

python generate_csv.py /home/$USER/salmon salmon.csv

python generate_train_eval.py salmon.csv 

python generate_pbtxt.py csv salmon.csv salmon_label_map.pbtxt


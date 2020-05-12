#!/bin/bash


rm ~/TensorFlow/workspace/training_demo/annotations/*
rm -rf ~/TensorFlow/workspace/training_demo/annotations/*

cd ~/datasetTmp/

cp -r train ~/TensorFlow/workspace/training_demo/images/
cp -r test ~/TensorFlow/workspace/training_demo/images/
cp ~/datasetTmp/datasetInfo.txt ~/TensorFlow/workspace/training_demo/images/


# Copy the label map file
cp ~/CUDA-OpenCV/CUDA102-OpenCV420/label_map.pbtxt ~/TensorFlow/workspace/training_demo/annotations/label_map.pbtxt


# Some utilities
cp ~/CUDA-OpenCV/CUDA102-OpenCV420/xml_to_csv.py ~/TensorFlow/scripts/preprocessing/
cp ~/CUDA-OpenCV/CUDA102-OpenCV420/generate_tfrecord.py ~/TensorFlow/scripts/preprocessing


cd ~/TensorFlow/scripts/preprocessing
python3 xml_to_csv.py -i ~/TensorFlow/workspace/training_demo/images/train -o ~/TensorFlow/workspace/training_demo/annotations/train_labels.csv
python3 xml_to_csv.py -i ~/TensorFlow/workspace/training_demo/images/test -o ~/TensorFlow/workspace/training_demo/annotations/test_labels.csv

# NOTE ABSOLUTE PATHE IS OF IMPORTANCE HERE
python3 generate_tfrecord.py --label=salmon --csv_input=/home/$USER/TensorFlow/workspace/training_demo/annotations/train_labels.csv --output_path=/home/$USER/TensorFlow/workspace/training_demo/annotations/train.record --img_path=/home/$USER/TensorFlow/workspace/training_demo/images/train
python3 generate_tfrecord.py --label=salmon --csv_input=/home/$USER/TensorFlow/workspace/training_demo/annotations/test_labels.csv --output_path=/home/$USER/TensorFlow/workspace/training_demo/annotations/test.record --img_path=/home/$USER/TensorFlow/workspace/training_demo/images/test

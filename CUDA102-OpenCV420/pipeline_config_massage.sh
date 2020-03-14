#!/bin/bash

NUM_CLASSES=1
BATCH_SIZE=2
NUM_STEPS=200000

sed -i "/num_classes:/c\    num_classes: $NUM_CLASSES" pipeline.config
sed -i "/batch_size:/c\  batch_size: $BATCH_SIZE" pipeline.config
sed -i "/num_steps:/c\  num_steps: $NUM_STEPS" pipeline.config

sed -i '/train.record/c\  input_path: "annotations\/train.record"' pipeline.config
sed -i '/val.record/c\  input_path: "annotations\/test.record"' pipeline.config
sed -i '/label_map.pbtxt/c\  label_map_path: "annotations\/label_map.pbtxt"' pipeline.config
sed -i 's/PATH_TO_BE_CONFIGURED/pre-trained-model/g' pipeline.config




#!/bin/bash

sed -i "/num_classes:/c\    num_classes: 1" pipeline.config
sed -i "/batch_size:/c\  batch_size: 2" pipeline.config
sed -i '/train.record/c\  input_path: "annotations\/train.record"' pipeline.config
sed -i '/val.record/c\  input_path: "annotations\/test.record"' pipeline.config
sed -i '/label_map.pbtxt/c\  label_map_path: "annotations\/label_map.pbtxt"' pipeline.config
sed -i 's/PATH_TO_BE_CONFIGURED/pre-trained-model/g' pipeline.config

#sed -i "/fine_tune_checkpoint: "PATH_TO_BE_CONFIGURED\/model.ckpt"/c\fine_tune_checkpoint: "pre-trained-model\/model.ckpt"" pipeline.config



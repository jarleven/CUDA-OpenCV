#!/bin/bash


#### Exporting the model
AT_STEP=921575

#Check if we have the files 
#In ~/TensorFlow/workspace/training_demo/training/
#The completet states have 3x files
#-rw-r--r-- 1 jarleven jarleven     68630 mars  27 20:07 model.ckpt-921575.index
#-rw-r--r-- 1 jarleven jarleven  73929056 mars  27 20:07 model.ckpt-921575.data-00000-of-00001
#-rw-r--r-- 1 jarleven jarleven  16862597 mars  27 20:08 model.ckpt-921575.meta


# Check if this exixts - Make a backup ?
mkdir ~/EXPORT
cd ~/TensorFlow/models/research/object_detection


python3 export_inference_graph.py \
    --input_type image_tensor \
    --pipeline_config_path /home/$USER/TensorFlow/workspace/training_demo/training/pipeline.config \
    --trained_checkpoint_prefix /home/$USER/TensorFlow/workspace/training_demo/training/model.ckpt-$AT_STEP \
    --output_directory /home/$USER/EXPORT


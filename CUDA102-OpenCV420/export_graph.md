

# WHERE ARE THE FILES

# SIZE : THE INPUT SHAPES

INPUT_TENSORS='normalized_input_image_tensor'
OUTPUT_TENSORS='TFLite_Detection_PostProcess,TFLite_Detection_PostProcess:1,TFLite_Detection_PostProcess:2,TFLite_Detection_PostProcess:3'


mkdir /home/jarleven/frozen
cd ~/TensorFlow/models/research/object_detection



python3 export_tflite_ssd_graph.py \
  --pipeline_config_path="/home/jarleven/TensorFlow/workspace/training_demo/training/ssd_mobilenet_v2_quantized_pipeline.config" \
  --trained_checkpoint_prefix="/home/jarleven/TensorFlow/workspace/training_demo/training/model.ckpt-" \
  --output_directory="/home/jarleven/frozen" \
  --add_postprocessing_op=true
  

tflite_convert \
  --output_file="/home/jarleven/frozen/output_tflite_graph.tflite" \
  --graph_def_file="/home/jarleven/frozen/tflite_graph.pb" \
  --inference_type=QUANTIZED_UINT8 \
  --input_arrays="${INPUT_TENSORS}" \
  --output_arrays="${OUTPUT_TENSORS}" \
  --mean_values=128 \
  --std_dev_values=128 \
  --input_shapes=1,300,300,3 \
  --change_concat_input_ranges=false \
  --allow_nudging_weights_to_use_fast_gemm_kernel=true \
  --allow_custom_ops
  
  
  
 

cd $HOME/frozen
edgetpu_compiler output_tflite_graph.tflite
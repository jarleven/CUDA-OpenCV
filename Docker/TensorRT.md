``` TensorRT

# For ultralytics/yolov5:latest we need TensorRT packages to run in TensorRT
pip install nvidia-pyindex
pip install nvidia-tensorrt

# Convert/export the PyTorch model to TensorRT
python export.py --device 0 --weights /model/fiskAI_v2.pt --include engine


cp /model/detect_jee_v3.py .

python export.py --device 0 --weights /model/fiskAI_v2.pt --include engine

python detect.py \
	--weights /model/fiskAI_v2.engine \
	--save-crop \
	--nosave \
	--save-txt \
	--project /model/detect \
	--conf-thres 0.4 \
	--source /filesrv/
  
  
  ```

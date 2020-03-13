Googel Coral

user mendel
pw mendel


Serialport 115200

Remove the key from /home/mendel/.ssh/authorized_keys on the device via the serial console




mdt devices

deft-apple		(192.168.100.2)


mdt shell





ssh-keygen
mdt pushkey ~/.ssh/id_rsa.pub





git clone --depth 1



mendel@deft-apple:/usr/bin$ find . | grep edgetpu_demo
./edgetpu_demo


mendel@deft-apple:/usr/bin$ find . | grep edgetpu_detect
./edgetpu_detect
./edgetpu_detect_server


mendel@deft-apple:/usr/bin$ find . | grep edgetpu_detect
./edgetpu_detect
./edgetpu_detect_server




You cannot train a model directly with TensorFlow Lite; instead you must convert your model from a TensorFlow file (such as a .pb file) to a TensorFlow Lite file (a .tflite file), using the TensorFlow Lite converter.

https://www.tensorflow.org/lite/convert/





https://blog.tensorflow.org/2019/03/build-ai-that-works-offline-with-coral.html
"The following code snippet shows how simple it is to convert and quantize a model using TensorFlow Lite nightly and TensorFlow 2.0 alpha:"





#!/bin/bash

readonly TEST_DATA="/usr/share/edgetpudemo"
readonly VIDEO_DEVICE_FILE="${TEST_DATA}/video_device.mp4"
readonly VIDEO_STREAM_FILE="${TEST_DATA}/video_stream.mp4"
readonly TPU_MODEL_FILE="${TEST_DATA}/mobilenet_ssd_v1_coco_quant_postprocess_edgetpu.tflite@Running MobileNet SSD v1 on Edge TPU"
readonly CPU_MODEL_FILE="${TEST_DATA}/mobilenet_ssd_v1_coco_quant_postprocess.tflite@Running MobileNet SSD v1 on CPU"
readonly LABELS_FILE="${TEST_DATA}/coco_labels.txt"

if [[ "$1" == "--device" ]]; then
  echo "Press 'q' to quit."
  echo "Press 'n' to switch between models."

  edgetpu_detect \
      --source "${VIDEO_DEVICE_FILE}" \
      --model "${TPU_MODEL_FILE},${CPU_MODEL_FILE}" \
      --labels "${LABELS_FILE}" \
      --filter car,truck \
      --max_area 0.1 \
      --color white \
      --loop \
      --displaymode fullscreen
elif [[ "$1" == "--stream" ]]; then
  echo "Press 'q' to quit."
  echo "Press 'n' to switch between models."

  SERVER_INDEX_HTML="${TEST_DATA}/index.html" edgetpu_detect_server \
      --source "${VIDEO_STREAM_FILE}" \
      --model "${TPU_MODEL_FILE},${CPU_MODEL_FILE}" \
      --labels "${LABELS_FILE}" \
      --filter car,truck \
      --max_area 0.1 \
      --color white \
      --loop
else
                                                                                                                          6,105         Top

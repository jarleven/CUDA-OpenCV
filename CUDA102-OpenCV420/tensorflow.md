


# 
# ssh to your machine
# Run the following command
# export DISPLAY=:0
# If you now run xeyes the x application will pop up on the screen connected to your machine. Not on your remote session.
#



###
# Errors and warninngs
#
# ERROR: launchpadlib 1.10.6 requires testresources, which is not installed.
# Warning: /home/linuxbrew/.linuxbrew/bin is not in your PATH.
#
#


sudo apt-get install -y git ssh build-essential linuxbrew-wrapper

# Install PIP for Python 3
sudo apt install -y python3-pip
python3 -m pip install --upgrade --user pip


# TODO how to answer yes ??
brew install protobuf


# Why not bashrc ??? 
echo 'export PATH="/home/linuxbrew/.linuxbrew/bin:$PATH"' >>~/.bash_profile
echo 'export MANPATH="/home/linuxbrew/.linuxbrew/share/man:$MANPATH"' >>~/.bash_profile
echo 'export INFOPATH="/home/linuxbrew/.linuxbrew/share/info:$INFOPATH"' >>~/.bash_profile

# Set path and update
# TODO why not bashrc
echo "export PATH=$PATH:~/.local/bin" >> ~/.bash_profile
source ~/.bash_profile

echo 'export PYTHONPATH="$PYTHONPATH:$HOME/TensorFlow/models/research:$HOME/TensorFlow/models/research/slim"' >>~/.bashrc



source ~/.bash_profile
source ~/.bashrc



#sudo apt install -y python3-dev python3-numpy
python3 -m pip install --upgrade --force-reinstall Cython --user
python3 -m pip install --upgrade --force-reinstall pycocotools --user
python3 -m pip install --upgrade --force-reinstall pandas --user


# At the time of writing 1.15 is the lastest / final 1.x version.
python3 -m pip install --upgrade --force-reinstall tensorflow==1.15 --user


# Make the folder structure 

mkdir ~/TensorFlow

cd ~/TensorFlow

mkdir workspace
mkdir workspace/training_demo
mkdir workspace/training_demo/annotations
mkdir workspace/training_demo/images
mkdir workspace/training_demo/images/test
mkdir workspace/training_demo/images/train
mkdir workspace/training_demo/pre-trained-model
mkdir workspace/training_demo/training

mkdir scripts
mkdir scripts/preprocessing





# Get the "Models and examples built with TensorFlow"
cd ~/TensorFlow
git clone https://github.com/tensorflow/models.git
cd ~/TensorFlow/models/tutorials/image/imagenet

# If you would like to test if Tensorflow is working
# python3 classify_image.py



cd ~/TensorFlow/models/research/

# From within TensorFlow/models/research/
protoc object_detection/protos/*.proto --python_out=.

# From within TensorFlow/models/research/
python3 setup.py build
sudo python3 setup.py install






cd ~
git clone https://github.com/cocodataset/cocoapi.git
cd cocoapi/PythonAPI
# TODO edit python to python3 two places in the Makefile 
# git diff --ignore-space-at-eol -b -w --ignore-blank-lines > ~/TensorFlow/patches/cocoapi-python3.diff
make
cp -r pycocotools ~/TensorFlow/models/research/




cp -r /media/jarleven/CUDA/laks ~/

cd ~/laks
cp {00001..00080}.jpg ~/TensorFlow/workspace/training_demo/images/test/
cp {00001..00080}.xml ~/TensorFlow/workspace/training_demo/images/test/
cp * ~/TensorFlow/workspace/training_demo/images/train



# Create the label map file
vi ~/TensorFlow/workspace/training_demo/annotations/label_map.pbtxt

# put the following in this file

item {
    id: 1
    name: 'salmon'
}




# Paste the xml_to_csv.py from https://tensorflow-object-detection-api-tutorial.readthedocs.io/en/latest/training.html into your own file
cd ~/TensorFlow/scripts/preprocessing/
vi xml_to_csv.py

# Paste the generate_tfrecord.py from https://tensorflow-object-detection-api-tutorial.readthedocs.io/en/latest/training.html into your own file
cd ~/TensorFlow/scripts/preprocessing 
vi generate_tfrecord.py




cd ~/TensorFlow/scripts/preprocessing 
python3 xml_to_csv.py -i ~/TensorFlow/workspace/training_demo/images/train -o ~/TensorFlow/workspace/training_demo/annotations/train_labels.csv
python3 xml_to_csv.py -i ~/TensorFlow/workspace/training_demo/images/test -o ~/TensorFlow/workspace/training_demo/annotations/test_labels.csv




# ABSOLUTE PATH IS NEEDED HERE !!!!!!!!

# THE label is the labels used in your annotations.

python3 generate_tfrecord.py --label=salmon --csv_input=/home/jarleven/TensorFlow/workspace/training_demo/annotations/train_labels.csv --output_path=/home/jarleven/TensorFlow/workspace/training_demo/annotations/train.record --img_path=/home/jarleven/TensorFlow/workspace/training_demo/images/train
python3 generate_tfrecord.py --label=salmon --csv_input=/home/jarleven/TensorFlow/workspace/training_demo/annotations/test_labels.csv --output_path=/home/jarleven/TensorFlow/workspace/training_demo/annotations/test.record --img_path=/home/jarleven/TensorFlow/workspace/training_demo/images/test


cd ~
wget http://download.tensorflow.org/models/object_detection/ssd_inception_v2_coco_2018_01_28.tar.gz
tar xvzf ssd_inception_v2_coco_2018_01_28.tar.gz
cd ssd_inception_v2_coco_2018_01_28

cp -r * ~/TensorFlow/workspace/training_demo/pre-trained-model/

cp pipeline.config ~/TensorFlow/workspace/training_demo/training/
vi ~/TensorFlow/workspace/training_demo/training/pipeline.config

diff ~/TensorFlow/workspace/training_demo/training/pipeline.config ~/ssd_inception_v2_coco_2018_01_28/pipeline.config > ~/pipeline.patch


cp ~/TensorFlow/models/research/object_detection/legacy/train.py ~/TensorFlow/workspace/training_demo/


# The above DID NOT WORK, I had to download a new pipeline.config file
python3 train.py --logtostderr --train_dir=training/ --pipeline_config_path=training/ssd_inception_v2_coco.config

# TODO investigate diff !

wget https://raw.githubusercontent.com/developmentseed/label-maker/94f1863945c47e1b69fe0d6d575caa0b42aa8d63/examples/utils/ssd_inception_v2_coco.config

cp ssd_inception_v2_coco.config  ~/TensorFlow/workspace/training_demo/training/
vi ~/TensorFlow/workspace/training_demo/training/ssd_inception_v2_coco.config



# Fire up the tensorboard 
cd ~/TensorFlow/workspace/training_demo
tensorboard --logdir=training




##### The salmon model is being created. Saved some of the paths for later in case I forgot to log some of the steps done to get here.

echo $PATH
/home/linuxbrew/.linuxbrew/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin:/home/jarleven/.local/bin


echo $PYTHONPATH
:/home/jarleven/TensorFlow/models/research/object_detection:/home/jarleven/TensorFlow/models/research/object_detection:/home/jarleven/TensorFlow/models/research/object_detection:/home/jarleven/TensorFlow/models/research:/home/jarleven/TensorFlow/models/research/slim



cat ~/.bash_profile
export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin:~/.local/bin
export PATH="/home/linuxbrew/.linuxbrew/bin:$PATH"
export MANPATH="/home/linuxbrew/.linuxbrew/share/man:$MANPATH"
export INFOPATH="/home/linuxbrew/.linuxbrew/share/info:$INFOPATH"






# Making a custom salmon object detector
# Journey starts here https://tensorflow-object-detection-api-tutorial.readthedocs.io/en/latest/training.html

# Thanks to :
#	* https://github.com/tzutalin/labelImg
#	* https://github.com/datitran/raccoon_dataset
#	* https://pythonprogramming.net/training-custom-objects-tensorflow-object-detection-api-tutorial/



###
# Errors and warninngs (Taken care of but not tested)
#
# ERROR: launchpadlib 1.10.6 requires testresources, which is not installed.
# Warning: /home/linuxbrew/.linuxbrew/bin is not in your PATH.
#
#


sudo apt-get install -y git ssh build-essential linuxbrew-wrapper


# Install PIP for Python 3
sudo apt install -y python3-pip
python3 -m pip install --upgrade --user pip

sudo apt install -y python3-testresources


# TODO how to answer yes ??
brew install protobuf



# Set paths

#
#  The right place to define environment variables such as PATH is ~/.profile (or ~/.bash_profile if you don't care about shells other than bash)
#  https://superuser.com/questions/183870/difference-between-bashrc-and-bash-profile/183980#183980
#
# 


# https://unix.stackexchange.com/questions/26047/how-to-correctly-add-a-path-to-path
# An important point is that, even if system scripts do not use this (I wonder why)*1, the bullet-proof way to add a path (e.g., $HOME/bin) to the PATH environment variable to
# avoid the spurious leading/trailing colon when $PATH is initially empty, which can have undesired side effects and can become a nightmare,

# for appending
# PATH="${PATH:+${PATH}:}$HOME/bin"
# for prepending 
# PATH="$HOME/bin${PATH:+:${PATH}}"

echo 'export PYTHONPATH="${PYTHONPATH:+${PYTHONPATH}:}$HOME/TensorFlow/models/research/object_detection:$HOME/TensorFlow/models/research:$HOME/TensorFlow/models/research/slim"' >> ~/.bash_profile

# Yes this is done above "export PYTHONPATH=$PYTHONPATH:`pwd`:`pwd`/slim"

echo 'export PATH="${PATH:+${PATH}:}$HOME/.local/bin:/home/linuxbrew/.linuxbrew/bin"' >> ~/.bash_profile



echo 'export MANPATH="${MANPATH:+${MANPATH}:}/home/linuxbrew/.linuxbrew/share/man"' >> ~/.bash_profile
echo 'export INFOPATH="${INFOPATH:+${INFOPATH}:}/home/linuxbrew/.linuxbrew/share/info"' >> ~/.bash_profile

source ~/.bash_profile



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



# Copy the backup of all the images annotaed with LabelImg
cp -r /media/jarleven/CUDA/laks ~/

# Split in approx 10% test and 90% train images (I had 800 annotated images)
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

# Follow the training on:
# http://localhost:6006/
# http://192.168.3.108:6006/


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





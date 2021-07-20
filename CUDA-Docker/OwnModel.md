## My own model.

* LabelImg
* Resize images
* Transform images
* Train/evaluate
* Replace default LearnPet in https://coral.ai/docs/edgetpu/retrain-detection/#start-training


### LabelImg
```
cd $HOME
git clone https://github.com/tzutalin/labelImg.git

sudo apt install -y python3-pip
sudo apt install -y pyqt5-dev-tools
cd $HOME/labelImg/
sudo pip3 install -r requirements/requirements-linux-python3.txt
make qt5py3


```



### Resize images - Keep annotation of course
```
mkdir -p $HOME/tmp
cd $HOME
git clone https://github.com/italojs/resize_dataset_pascalvoc

# I had isseuse with the requirements.txt due to version conflicts, so here is the libraries I needed.

sudo apt install -y python3-pip
pip install opencv_python numpy

# If on a headless server
sudo apt-get install -y libgl1-mesa-dev 

cd resize_dataset_pascalvoc

#
# python3 main.py -p <IMAGES_&_XML_PATH> --output <IMAGES_&_XML> --new_x <NEW_X_SIZE> --new_y <NEW_X_SIZE> --save_box_images <FLAG>"
#

python3 main.py -p $HOME/model/ --output $HOME/tmp/ --new_x 300 --new_y 300

python3 main.py -p $HOME/model --output $HOME/tmp --new_x 300 --new_y 300


```



### Train and evaluate dirtribution
```
cd $HOME

git clone https://github.com/jarleven/Notes.git

mkdir -p $HOME/model
cp -r $HOME/Notes/SalmonModel/* $HOME/model
cd $HOME/model

ls -1 *.jpg | sed -e 's/\..*$//' > list.txt

NUMELEMENTS=$(wc -l < list.txt)

PERCENTAGE=70
a=$((  NUMELEMENTS *PERCENTAGE/100))
b=$((a + 1))

echo $a
echo $b

sort -R list.txt > list.tmp
head -n $a list.tmp > trainval.txt
tail -n +$b list.tmp > test.txt

cp *.txt $HOME/tmp

```
### Copy replace the cats and dogs in the "Google Coral Retrain an object detection model"
```
sudo rm $HOME/google-coral/tutorials/docker/object_detection/out/pet/pet_label_map.pbtxt
sudo rm $HOME/google-coral/tutorials/docker/object_detection/out/pet/annotations/*.txt
sudo rm -rf $HOME/google-coral/tutorials/docker/object_detection/out/pet/annotations/xmls
sudo rm -rf $HOME/google-coral/tutorials/docker/object_detection/out/pet/images

sudo mkdir $HOME/google-coral/tutorials/docker/object_detection/out/pet/annotations/xmls
sudo mkdir $HOME/google-coral/tutorials/docker/object_detection/out/pet/images
	

sudo cp $HOME/tmp/*.txt $HOME/google-coral/tutorials/docker/object_detection/out/pet/annotations/
sudo cp $HOME/tmp/*.xml $HOME/google-coral/tutorials/docker/object_detection/out/pet/annotations/xmls/
sudo cp $HOME/tmp/*.jpg $HOME/google-coral/tutorials/docker/object_detection/out/pet/images/

cd $HOME
rm -rf pet_label_map.pbtxt pipeline.config
wget https://raw.githubusercontent.com/jarleven/CUDA-OpenCV/master/CUDA-Docker/pet_label_map.pbtxt	
wget https://raw.githubusercontent.com/jarleven/CUDA-OpenCV/master/CUDA-Docker/pipeline.config

sudo cp pet_label_map.pbtxt $HOME/google-coral/tutorials/docker/object_detection/out/pet/


sudo cp pipeline.config $HOME/google-coral/tutorials/docker/object_detection/out/ckpt/


Inside Docker
cd object_detection/dataset_tools/
rm create_pet_tf_record.py 
wget https://raw.githubusercontent.com/jarleven/CUDA-OpenCV/master/CUDA-Docker/create_pet_tf_record.py

cd ../../

source "$PWD/constants.sh"
python object_detection/dataset_tools/create_pet_tf_record.py \
   --label_map_path="${DATASET_DIR}/pet_label_map.pbtxt" \
   --data_dir="${DATASET_DIR}"  \
   --output_dir="${DATASET_DIR}"







TODO edit below

# The Salmon model only contain one class so we should edit the "num_classes: 1"


cd $HOME/google-coral/tutorials/docker/object_detection/out/ckpt

sed -i "s/batch_size:.*/batch_size: 28/g" pipeline.config
sed -i "s/num_classes:.*/num_classes: 1/g" pipeline.config


# Setup model (modify to not download the pet dataset)
# Don't use trimpas
#
# Somewhere in here .....
#/google-coral/tutorials/docker/object_detection/scripts$ vi prepare_checkpoint_and_dataset.sh
#python object_detection/model_main.py \

#/google-coral/tutorials/docker/object_detection/scripts$ vi prepare_checkpoint_and_dataset.sh 
#python object_detection/dataset_tools/create_pet_tf_record.py \





```


### File structure, some cleanup TODO
```bash
tree  $HOME/google-coral/tutorials/docker/object_detection/out > tree.txt


home $HOME/google-coral/tutorials/docker/object_detection/out
├── ckpt
│   └── pipeline.config
├── pet
│   ├── annotations
│   │   ├── list_petsdataset.txt
│   │   ├── list.txt
│   │   ├── README
│   │   ├── test_petsdataset.txt
│   │   ├── test.txt
│   │   ├── trainval_petsdataset.txt
│   │   ├── trainval.txt
│   │   ├── trimaps
│   │   │   └── IMAGE.png
│   │   └── xmls
│   │       └── IMAGE.xml
│   └── images
│   │   └── IMAGE.jpg
│   └── pet_label_map.pbtxt
└── train
```




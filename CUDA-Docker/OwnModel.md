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



### Resize images - Keep annotation ofcourse
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
head -n $a list.tmp > test.txt
tail -n +$b list.tmp > trainval.txt
```




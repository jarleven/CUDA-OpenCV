Automated script according to the following description
 * 
 
 
 * 64-bit Linux Ubuntu 16.04.5 LTS
 * Python 2.7 (On 2.7.12 at the moment)
 * CUDA 8.0 
 * cuDNN v6 for TF v1.4.1


```
sudo apt-get install -y libcupti-dev
sudo apt install python-pip
pip install --user --upgrade pip
hash -d pip
pip install --upgrade pip
pip install tensorflow-gpu==1.4.1
```


All the stuff with pip is due to some issue, error message I got is below.
```

Traceback (most recent call last):
  File "/usr/bin/pip", line 9, in <module>
    from pip import main
ImportError: cannot import name main

pip install --ignore-installed tensorflow-gpu==1.4.1
```

When isntalling tensorflow I got complaints about permissions:
I set the myself as owner of these folders.
```
sudo chown -R jarleven:jarleven /usr/local/lib/python2.7/dist-packages/
sudo chown -R jarleven:jarleven /usr/local/bin/
```

To do image analysis install the tensorflow models
```
git clone https://github.com/tensorflow/models.git
cd models/tutorials/image/imagenet
python classify_image.py
```


```
A little experiment 25.08.2018 (Non GPU and Python3)
Tensorflow versions are here : https://www.tensorflow.org/versions/

"use --user at last of your install command, so that the package will be installed only for the current user, not for all."

pip install xxxxxx --user

sudo apt-get install -y libcupti-dev
sudo apt install python3-pip

pip3 install --user --upgrade pip

hash -d pip3
pip3 install --upgrade pip

pip3 show pip

pip3 install tensorflow==1.10 --user

# Getting an error about six "ImportError: No module named six.moves"
sudo apt-get install python3-six
pip3 uninstall six
pip3 install six


Good exersise, the --user flag probably fixed my issues from before !


# Better use this way to install .... I will try again with 

sudo python3 -m pip uninstall -y six
sudo python3 -m pip install six
sudo python3 -m pip install tensorflow==1.10

sudo python3 -m pip install tensorflow==1.10 --ignore-installed


```

Tested : Ubuntu 18.04.3 LTS
Trying to make a simple description for some students
Date 25. Oct 2019
```

sudo apt install -y git
sudo apt install -y python3-pip

python3 -m pip install --upgrade --user pip 

export PATH=$PATH:/home/jarleven/.local/bin

python3 -m pip install --upgrade --force-reinstall --user six

python3 -m pip install --upgrade --force-reinstall tensorflow==1.10 --user


cd ~

git clone https://github.com/tensorflow/models.git
cd models/tutorials/image/imagenet


python3 classify_image.py

```


# Version 2 not supported !
# python3 -m pip install --upgrade --force-reinstall tensorflow --user









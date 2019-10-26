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

## Tested : Ubuntu 18.04.3 LTS
* Trying to make a simple description for some students
* Date 25. Oct 2019

```
Download : http://releases.ubuntu.com/18.04/ubuntu-18.04.3-desktop-amd64.iso
Tensorflow versions are here : https://www.tensorflow.org/versions/

# Norwegian keyboard map
setxkbmap no

# Set path (Need to test again when to do this. Does this path exist after installing Ubuntu ?)
export PATH=$PATH:~/.local/bin

# Add it permanently
# echo "export PATH=$PATH:~/.local/bin" >> ~/.bash_profile

# Install 
sudo apt install -y git
sudo apt install -y python3-pip

python3 -m pip install --upgrade --user pip 

# Some dependency issue, this is not installed by Tensorflow 
python3 -m pip install --upgrade --force-reinstall --user six

python3 -m pip install --upgrade --force-reinstall tensorflow==1.10 --user
# Edit At the time 1.15 is the lastest. Will test with this version.

# Get the "Models and examples built with TensorFlow"
cd ~
git clone https://github.com/tensorflow/models.git
cd ~/models/tutorials/image/imagenet

# Test if everything works
python3 classify_image.py


```

Output is 
```
>> Downloading inception-2015-12-05.tgz 100.0%
Successfully downloaded inception-2015-12-05.tgz 88931400 bytes.
2019-10-25 12:51:16.934624: W tensorflow/core/framework/op_def_util.cc:346] Op BatchNormWithGlobalNormalization is deprecated. It will cease to work in GraphDef version 9. Use tf.nn.batch_normalization().
2019-10-25 12:51:17.098627: I tensorflow/core/platform/cpu_feature_guard.cc:141] Your CPU supports instructions that this TensorFlow binary was not compiled to use: AVX2 FMA
2019-10-25 12:51:17.271974: W tensorflow/core/framework/allocator.cc:108] Allocation of 8257536 exceeds 10% of system memory.
giant panda, panda, panda bear, coon bear, Ailuropoda melanoleuca (score = 0.89107)
indri, indris, Indri indri, Indri brevicaudatus (score = 0.00779)
lesser panda, red panda, panda, bear cat, cat bear, Ailurus fulgens (score = 0.00296)
custard apple (score = 0.00147)
earthstar (score = 0.00117)
```

To classify your image use this style
```
python classify_image.py --NameOfYourImage.jpg
```

Info about Python and PIP versions
```

python --version
Python 2.7.15+

python3 -m pip --version
pip 19.3.1 from /home/jarleven/.local/lib/python3.6/site-packages/pip (python 3.6)


```



 Version 2 not supported. If you don't specify a version as above you get v2 of Tensorflow!
```
python3 -m pip install --upgrade --force-reinstall tensorflow --user
```









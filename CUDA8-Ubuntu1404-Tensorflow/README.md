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


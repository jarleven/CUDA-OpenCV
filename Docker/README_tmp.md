### Ubuntu users on the Fileserver
```
sudo useradd -m mrtroll                   # Add user with home directory
sudo usermod -s /bin/bash mrtroll         # Use bash as default shell


sudo usermod -aG sudo mrtroll             # Add to sudoers list (NOT ON THE FILESERVER !!!!)


IP addr 192.168.1.199  Mellanox 10Gbit 00:02:c9:4f:5b:94

IP addr 192.168.1.165  Mellanox 10Gbit 00:02:c9:4e:1e:7c
  

```

### Colab and Roboflow - Custom object detection model
```

https://colab.research.google.com/github/roboflow-ai/yolov5-custom-training-tutorial/blob/main/yolov5-custom-training.ipynb

https://roboflow.com/


https://github.com/ultralytics/yolov5/wiki/Docker-Quickstart

sudo docker run --ipc=host -it --gpus all ultralytics/yolov5:latest


sudo docker run --ipc=host -it  --gpus all -v "$(pwd)"/modeldir:/usr/ ultralytics/yolov5:latest

python detect.py --weights yolov5s.pt --source path/to/images



ERROR: pip's dependency resolver does not currently take into account all the packages that are installed. This behaviour is the source of the following dependency conflicts.
google-colab 1.0.0 requires requests~=2.23.0, but you have requests 2.25.1 which is incompatible.
datascience 0.10.6 requires folium==0.2.1, but you have folium 0.8.3 which is incompatible.
albumentations 0.1.12 requires imgaug<0.2.7,>=0.2.5, but you have imgaug 0.2.9 which is incompatible.

```

### Run YOLOv5 locally in Docker
```
sudo docker run --ipc=host -it  --gpus all -v /home/jarleven/test:/model ultralytics/yolov5:latest

python detect.py --weights /model/Aleks.pt --source /model/bilder


# Make some folders locally on your PC
mkdir $HOME/test
mkdir $HOME/test/images

# Copy the model and some images or videos to the home/test/images folder
#
# cp *.pt  $HOME/test
# cp *.png *.mp4 *.jpg $HOME/test/images


sudo docker run --ipc=host -it  --gpus all -v $HOME/test:/model ultralytics/yolov5:latest

# Alternative - Pass the display to Docker. You can then run X applications from inside Docker.
sudo xhost +local:root;
sudo docker run --ipc=host -it  --gpus all -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix:rw -v $HOME/test:/model ultralytics/yolov5:latest

# Results saved to runs/detect/exp

feh -F  --auto-zoom --slideshow-delay 1 runs/detect/exp
# q to quit feh  (Light weight image viewer)


```

### Utilities and non AI stuff
```

https://mlhive.com/2022/02/read-and-write-pascal-voc-xml-annotations-in-python

from pascal_voc_writer import Writer

# create pascal voc writer (image_path, width, height)
writer = Writer('path/to/img.jpg', 800, 598)

# add objects (class, xmin, ymin, xmax, ymax)
writer.addObject('truck', 1, 719, 630, 468)
writer.addObject('person', 40, 90, 100, 150)

# write to file
writer.save('path/to/img.xml'),


```



### Installing Docker and the NVIDIA Container Toolkit
```
# https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/install-guide.html#docker


sudo apt update
sudo apt upgrade -y
sudo apt install -y curl vim git

# For older versions of Ubuntu
sudo add-apt-repository ppa:graphics-drivers/ppa -y
sudo apt update
# To search for available drivers
apt search nvidia-driver 
sudo apt install nvidia-driver-510 -y
# ( For a headless system sudo apt install nvidia-headless-510 -y  )


git clone https://github.com/NVIDIA/object-detection-tensorrt-example.git

curl https://get.docker.com | sh && sudo systemctl --now enable docker

# Test Docker
sudo docker run hello-world


# Add the NVIDIA Toolkit to the APT sources list
distribution=$(. /etc/os-release;echo $ID$VERSION_ID) \
      && curl -s -L https://nvidia.github.io/libnvidia-container/gpgkey | sudo apt-key add - \
      && curl -s -L https://nvidia.github.io/libnvidia-container/$distribution/libnvidia-container.list | sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list
      
      
sudo apt update

sudo apt install -y nvidia-docker2
sudo systemctl restart docker

# Test the NVIDIA Container Toolkit
sudo docker run --rm --gpus all nvidia/cuda:11.0-base nvidia-smi

# After aquiering the NGC license key you can download and run the NGC deep learning Docker image

sudo docker run --gpus all -it --rm nvcr.io/nvidia/tensorflow:22.03-tf2-py3



#
#  --gpus
#   -it

#  --rm
#  --name

#   -e
#   -v
#
#  --ipc
#  --ulimit memlock=-1
#  --ulimit stack=
#

#  --net

 

 #   sudo    : admin privilages
 #   docker  : calling docker which we installed earlier
 #   run     : asking docker to run the image which we will describe ahead
 #   — — runtime=nvidia : initiating the layer of nvidia-docker (installed earlier)
 #   -it     : this will keep the container interactive, will allow us to write/edit commands inside the container.
 #   -d       : represents detach mode, meaning it will print the container ID and container will be running in background, which we will access it afterwards.
 #   -e DISPLAY=$DISPLAY : is to set environmental variables, meaning giving container the path to DISPLAY in a same fashion our ubuntu uses display.
 #   — — name=dst : it is the name of your container, I have used ‘Thor’, you can use what ever you like BlackWidow, KhalDrogo, NightKing are all good names.
 #   -v $HOME/Documents/DS_computer_vision/:/home/ : This ‘-v’ helps us to mount the directory from our host system inside the container, syntax is something like HOST MACHINE ADDR(documents/DS_computer_vision):ADDR INSIDE CONTAINER(/home/). And since we know the container is following ubuntu kernel, there would be a folder name home. so all our files will be mounted inside home folder of container and I feel very comfortable working with this as there is no place like HOME.
 #   — — net=host : this lets the container to communicate through internet on all ports , you can restrict it by using -p publish command. but its not worth it so dont try.
 #   — — gpus=all : helps NVIDIA-DOCKER to access to all gpus on your machine, and since before all this docker you have installed NVIDIA_DRIVERS AND CUDA , this helps our container to see the Gpu on your machine.
    nvcr.io/nvidia/deepstream:5.1-21.02-triton : Last but not least is the name of the main DEEPSTREAM image which will be now converted to container name — ‘dst’.


sudo docker run --runtime=nvidia -it -d -e DISPLAY=$DISPLAY --name Thor -v $HOME/Documents/DS_computer_vision/:/home/ --net=host --gpus all nvcr.io/nvidia/deepstream:5.1-21.02-triton





```



### XEyes and GLX Gears
```   

# Allow Docker containers access to the display
sudo xhost +local:root;

# Start the container
sudo docker run --gpus all -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix:rw  -it --rm nvcr.io/nvidia/tensorflow:22.03-tf2-py3

# Fix the memory warning
sudo docker run --gpus all --ipc=host --ulimit memlock=-1 --ulimit stack=67108864 -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix:rw  -it --rm nvcr.io/nvidia/tensorflow:22.03-tf2-py3


# From inside the container install and run XEyes:
apt update && apt install -qqy x11-apps && xeyes

# Some 3D rendering with GLX Gears
apt install mesa-utils
glxgears

```

### Camera Eidselva
```

rtsp://192.168.1.87:554/user=admin&password=&channel=0&stream=0.sdp?real_stream

rtsp://192.168.1.170:554/user=admin&password=&channel=0&stream=0.sdp?real_stream


```


### Tesla K80
```   

wget https://us.download.nvidia.com/tesla/470.103.01/NVIDIA-Linux-x86_64-470.103.01.run

chmod +x NVIDIA-Linux-x86_64-470.103.01.run
sudo sh NVIDIA-Linux-x86_64-470.103.01.run


https://volkovlabs.com/we-tried-pytorch-in-docker-container-with-nvidia-gpu-support-on-google-cloud-5e30c49d9864


BIOS "Above 4GB Decoding" must be enabled!

sudo apt-get install nvidia-headless-470-server nvidia-utils-470-server nvidia-container-runtime nvidia-container-toolkit nvidia-docker2

sudo apt-get install -y nvidia-driver-510-server
sudo systemctl restart docker


https://docs.nvidia.com/datacenter/tesla/tesla-installation-notes/index.html

jarleven@tesla:~$ nvidia-smi
Thu May 12 06:59:49 2022
+-----------------------------------------------------------------------------+
| NVIDIA-SMI 470.103.01   Driver Version: 470.103.01   CUDA Version: 11.4     |
|-------------------------------+----------------------+----------------------+
| GPU  Name        Persistence-M| Bus-Id        Disp.A | Volatile Uncorr. ECC |
| Fan  Temp  Perf  Pwr:Usage/Cap|         Memory-Usage | GPU-Util  Compute M. |
|                               |                      |               MIG M. |
|===============================+======================+======================|
|   0  Tesla K80           Off  | 00000000:03:00.0 Off |                    0 |
| N/A   34C    P0    54W / 149W |      0MiB / 11441MiB |      0%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+
|   1  Tesla K80           Off  | 00000000:04:00.0 Off |                    0 |
| N/A   40C    P0    74W / 149W |      0MiB / 11441MiB |    100%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+

+-----------------------------------------------------------------------------+
| Processes:                                                                  |
|  GPU   GI   CI        PID   Type   Process name                  GPU Memory |
|        ID   ID                                                   Usage      |
|=============================================================================|
|  No running processes found                                                 |
+-----------------------------------------------------------------------------+


GPU Name
GK210
GPU Variant
GK210-885-A1
Architecture
Kepler 2.0


https://docs.nvidia.com/deeplearning/frameworks/support-matrix/index.html
https://catalog.ngc.nvidia.com/orgs/nvidia/containers/pytorch

"Release 21.10 is based on NVIDIA CUDA 11.4.2 with cuBLAS 11.6.5.2, which requires NVIDIA Driver release 470 or later."
docker pull nvcr.io/nvidia/pytorch:21.10-py3

docker pull nvcr.io/nvidia/pytorch:17.12


apt install -y git
git clone https://github.com/ultralytics/yolov5.git

 cd yolov5
 pip install -r requirements.txt

```   

### Looking at Google Colab
```
!python --version
Python 3.7.13


!nvidia-smi
!lsb_release -a

!pip freeze



print("Hello world")
!nvidia-smi
!lsb_release -a



!pip freeze

Hello world
Tue May 17 07:05:29 2022       
+-----------------------------------------------------------------------------+
| NVIDIA-SMI 460.32.03    Driver Version: 460.32.03    CUDA Version: 11.2     |
|-------------------------------+----------------------+----------------------+
| GPU  Name        Persistence-M| Bus-Id        Disp.A | Volatile Uncorr. ECC |
| Fan  Temp  Perf  Pwr:Usage/Cap|         Memory-Usage | GPU-Util  Compute M. |
|                               |                      |               MIG M. |
|===============================+======================+======================|
|   0  Tesla T4            Off  | 00000000:00:04.0 Off |                    0 |
| N/A   36C    P8     9W /  70W |      0MiB / 15109MiB |      0%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+
                                                                               
+-----------------------------------------------------------------------------+
| Processes:                                                                  |
|  GPU   GI   CI        PID   Type   Process name                  GPU Memory |
|        ID   ID                                                   Usage      |
|=============================================================================|
|  No running processes found                                                 |
+-----------------------------------------------------------------------------+
No LSB modules are available.
Distributor ID:	Ubuntu
Description:	Ubuntu 18.04.5 LTS
Release:	18.04
Codename:	bionic




absl-py==1.0.0
alabaster==0.7.12
albumentations==0.1.12
altair==4.2.0
appdirs==1.4.4
argon2-cffi==21.3.0
argon2-cffi-bindings==21.2.0
arviz==0.12.0
astor==0.8.1
astropy==4.3.1
astunparse==1.6.3
atari-py==0.2.9
atomicwrites==1.4.0
attrs==21.4.0
audioread==2.1.9
autograd==1.4
Babel==2.10.1
backcall==0.2.0
beautifulsoup4==4.6.3
bleach==5.0.0
blis==0.4.1
bokeh==2.3.3
Bottleneck==1.3.4
branca==0.5.0
bs4==0.0.1
CacheControl==0.12.11
cached-property==1.5.2
cachetools==4.2.4
catalogue==1.0.0
certifi==2021.10.8
cffi==1.15.0
cftime==1.6.0
chardet==3.0.4
charset-normalizer==2.0.12
click==7.1.2
cloudpickle==1.3.0
cmake==3.22.4
cmdstanpy==0.9.5
colorcet==3.0.0
colorlover==0.3.0
community==1.0.0b1
contextlib2==0.5.5
convertdate==2.4.0
coverage==3.7.1
coveralls==0.5
crcmod==1.7
cufflinks==0.17.3
cupy-cuda111==9.4.0
cvxopt==1.2.7
cvxpy==1.0.31
cycler==0.11.0
cymem==2.0.6
Cython==0.29.28
daft==0.0.4
dask==2.12.0
datascience==0.10.6
debugpy==1.0.0
decorator==4.4.2
defusedxml==0.7.1
descartes==1.1.0
dill==0.3.4
distributed==1.25.3
dlib @ file:///dlib-19.18.0-cp37-cp37m-linux_x86_64.whl
dm-tree==0.1.7
docopt==0.6.2
docutils==0.17.1
dopamine-rl==1.0.5
earthengine-api==0.1.307
easydict==1.9
ecos==2.0.10
editdistance==0.5.3
en-core-web-sm @ https://github.com/explosion/spacy-models/releases/download/en_core_web_sm-2.2.5/en_core_web_sm-2.2.5.tar.gz
entrypoints==0.4
ephem==4.1.3
et-xmlfile==1.1.0
fa2==0.3.5
fastai==1.0.61
fastdtw==0.3.4
fastjsonschema==2.15.3
fastprogress==1.0.2
fastrlock==0.8
fbprophet==0.7.1
feather-format==0.4.1
filelock==3.6.0
firebase-admin==4.4.0
fix-yahoo-finance==0.0.22
Flask==1.1.4
flatbuffers==2.0
folium==0.8.3
future==0.16.0
gast==0.5.3
GDAL==2.2.2
gdown==4.4.0
gensim==3.6.0
geographiclib==1.52
geopy==1.17.0
gin-config==0.5.0
glob2==0.7
google==2.0.3
google-api-core==1.31.5
google-api-python-client==1.12.11
google-auth==1.35.0
google-auth-httplib2==0.0.4
google-auth-oauthlib==0.4.6
google-cloud-bigquery==1.21.0
google-cloud-bigquery-storage==1.1.1
google-cloud-core==1.0.3
google-cloud-datastore==1.8.0
google-cloud-firestore==1.7.0
google-cloud-language==1.2.0
google-cloud-storage==1.18.1
google-cloud-translate==1.5.0
google-colab @ file:///colabtools/dist/google-colab-1.0.0.tar.gz
google-pasta==0.2.0
google-resumable-media==0.4.1
googleapis-common-protos==1.56.0
googledrivedownloader==0.4
graphviz==0.10.1
greenlet==1.1.2
grpcio==1.44.0
gspread==3.4.2
gspread-dataframe==3.0.8
gym==0.17.3
h5py==3.1.0
HeapDict==1.0.1
hijri-converter==2.2.3
holidays==0.10.5.2
holoviews==1.14.8
html5lib==1.0.1
httpimport==0.5.18
httplib2==0.17.4
httplib2shim==0.0.3
humanize==0.5.1
hyperopt==0.1.2
ideep4py==2.0.0.post3
idna==2.10
imageio==2.4.1
imagesize==1.3.0
imbalanced-learn==0.8.1
imblearn==0.0
imgaug==0.2.9
importlib-metadata==4.11.3
importlib-resources==5.7.1
imutils==0.5.4
inflect==2.1.0
iniconfig==1.1.1
intel-openmp==2022.1.0
intervaltree==2.1.0
ipykernel==4.10.1
ipython==5.5.0
ipython-genutils==0.2.0
ipython-sql==0.3.9
ipywidgets==7.7.0
itsdangerous==1.1.0
jax==0.3.8
jaxlib @ https://storage.googleapis.com/jax-releases/cuda11/jaxlib-0.3.7+cuda11.cudnn805-cp37-none-manylinux2014_x86_64.whl
jedi==0.18.1
jieba==0.42.1
Jinja2==2.11.3
joblib==1.1.0
jpeg4py==0.1.4
jsonschema==4.3.3
jupyter==1.0.0
jupyter-client==5.3.5
jupyter-console==5.2.0
jupyter-core==4.10.0
jupyterlab-pygments==0.2.2
jupyterlab-widgets==1.1.0
kaggle==1.5.12
kapre==0.3.7
keras==2.8.0
Keras-Preprocessing==1.1.2
keras-vis==0.4.1
kiwisolver==1.4.2
korean-lunar-calendar==0.2.1
libclang==14.0.1
librosa==0.8.1
lightgbm==2.2.3
llvmlite==0.34.0
lmdb==0.99
LunarCalendar==0.0.9
lxml==4.2.6
Markdown==3.3.6
MarkupSafe==2.0.1
matplotlib==3.2.2
matplotlib-inline==0.1.3
matplotlib-venn==0.11.7
missingno==0.5.1
mistune==0.8.4
mizani==0.6.0
mkl==2019.0
mlxtend==0.14.0
more-itertools==8.12.0
moviepy==0.2.3.5
mpmath==1.2.1
msgpack==1.0.3
multiprocess==0.70.12.2
multitasking==0.0.10
murmurhash==1.0.7
music21==5.5.0
natsort==5.5.0
nbclient==0.6.2
nbconvert==5.6.1
nbformat==5.3.0
nest-asyncio==1.5.5
netCDF4==1.5.8
networkx==2.6.3
nibabel==3.0.2
nltk==3.2.5
notebook==5.3.1
numba==0.51.2
numexpr==2.8.1
numpy==1.21.6
nvidia-ml-py3==7.352.0
oauth2client==4.1.3
oauthlib==3.2.0
okgrade==0.4.3
opencv-contrib-python==4.1.2.30
opencv-python==4.1.2.30
openpyxl==3.0.9
opt-einsum==3.3.0
osqp==0.6.2.post0
packaging==21.3
palettable==3.3.0
pandas==1.3.5
pandas-datareader==0.9.0
pandas-gbq==0.13.3
pandas-profiling==1.4.1
pandocfilters==1.5.0
panel==0.12.1
param==1.12.1
parso==0.8.3
pathlib==1.0.1
patsy==0.5.2
pep517==0.12.0
pexpect==4.8.0
pickleshare==0.7.5
Pillow==7.1.2
pip-tools==6.2.0
plac==1.1.3
plotly==5.5.0
plotnine==0.6.0
pluggy==0.7.1
pooch==1.6.0
portpicker==1.3.9
prefetch-generator==1.0.1
preshed==3.0.6
prettytable==3.2.0
progressbar2==3.38.0
prometheus-client==0.14.1
promise==2.3
prompt-toolkit==1.0.18
protobuf==3.17.3
psutil==5.4.8
psycopg2==2.7.6.1
ptyprocess==0.7.0
py==1.11.0
pyarrow==6.0.1
pyasn1==0.4.8
pyasn1-modules==0.2.8
pycocotools==2.0.4
pycparser==2.21
pyct==0.4.8
pydata-google-auth==1.4.0
pydot==1.3.0
pydot-ng==2.0.0
pydotplus==2.0.2
PyDrive==1.3.1
pyemd==0.5.1
pyerfa==2.0.0.1
pyglet==1.5.0
Pygments==2.6.1
pygobject==3.26.1
pymc3==3.11.4
PyMeeus==0.5.11
pymongo==4.1.1
pymystem3==0.2.0
PyOpenGL==3.1.6
pyparsing==3.0.8
pyrsistent==0.18.1
pysndfile==1.3.8
PySocks==1.7.1
pystan==2.19.1.1
pytest==3.6.4
python-apt==0.0.0
python-chess==0.23.11
python-dateutil==2.8.2
python-louvain==0.16
python-slugify==6.1.2
python-utils==3.1.0
pytz==2022.1
pyviz-comms==2.2.0
PyWavelets==1.3.0
PyYAML==3.13
pyzmq==22.3.0
qdldl==0.1.5.post2
qtconsole==5.3.0
QtPy==2.1.0
regex==2019.12.20
requests==2.23.0
requests-oauthlib==1.3.1
resampy==0.2.2
rpy2==3.4.5
rsa==4.8
scikit-image==0.18.3
scikit-learn==1.0.2
scipy==1.4.1
screen-resolution-extra==0.0.0
scs==3.2.0
seaborn==0.11.2
semver==2.13.0
Send2Trash==1.8.0
setuptools-git==1.2
Shapely==1.8.1.post1
simplegeneric==0.8.1
six==1.15.0
sklearn==0.0
sklearn-pandas==1.8.0
smart-open==6.0.0
snowballstemmer==2.2.0
sortedcontainers==2.4.0
SoundFile==0.10.3.post1
soupsieve==2.3.2.post1
spacy==2.2.4
Sphinx==1.8.6
sphinxcontrib-serializinghtml==1.1.5
sphinxcontrib-websupport==1.2.4
SQLAlchemy==1.4.36
sqlparse==0.4.2
srsly==1.0.5
statsmodels==0.10.2
sympy==1.7.1
tables==3.7.0
tabulate==0.8.9
tblib==1.7.0
tenacity==8.0.1
tensorboard==2.8.0
tensorboard-data-server==0.6.1
tensorboard-plugin-wit==1.8.1
tensorflow @ file:///tensorflow-2.8.0-cp37-cp37m-linux_x86_64.whl
tensorflow-datasets==4.0.1
tensorflow-estimator==2.8.0
tensorflow-gcs-config==2.8.0
tensorflow-hub==0.12.0
tensorflow-io-gcs-filesystem==0.25.0
tensorflow-metadata==1.7.0
tensorflow-probability==0.16.0
termcolor==1.1.0
terminado==0.13.3
testpath==0.6.0
text-unidecode==1.3
textblob==0.15.3
Theano-PyMC==1.1.2
thinc==7.4.0
threadpoolctl==3.1.0
tifffile==2021.11.2
tinycss2==1.1.1
tomli==2.0.1
toolz==0.11.2
torch @ https://download.pytorch.org/whl/cu113/torch-1.11.0%2Bcu113-cp37-cp37m-linux_x86_64.whl
torchaudio @ https://download.pytorch.org/whl/cu113/torchaudio-0.11.0%2Bcu113-cp37-cp37m-linux_x86_64.whl
torchsummary==1.5.1
torchtext==0.12.0
torchvision @ https://download.pytorch.org/whl/cu113/torchvision-0.12.0%2Bcu113-cp37-cp37m-linux_x86_64.whl
tornado==5.1.1
tqdm==4.64.0
traitlets==5.1.1
tweepy==3.10.0
typeguard==2.7.1
typing-extensions==4.2.0
tzlocal==1.5.1
uritemplate==3.0.1
urllib3==1.24.3
vega-datasets==0.9.0
wasabi==0.9.1
wcwidth==0.2.5
webencodings==0.5.1
Werkzeug==1.0.1
widgetsnbextension==3.6.0
wordcloud==1.5.0
wrapt==1.14.0
xarray==0.18.2
xgboost==0.90
xkit==0.0.0
xlrd==1.1.0
xlwt==1.3.0
yellowbrick==1.4
zict==2.2.0
zipp==3.8.0



```   



### Credits
```   

https://medium.com/mlearning-ai/computer-vision-ai-in-production-using-nvida-deepstream-6c90d3daa8a5

```   

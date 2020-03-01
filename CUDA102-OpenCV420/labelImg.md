## Extra utilities that goes hand in hand with LabelImg.
 

### Install Google Chrome
```bash
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo apt install -y ./google-chrome-stable_current_amd64.deb
```
### Batch download images with Fatkun Batch Download Image
Link to [Faktun plugin](https://chrome.google.com/webstore/detail/fatkun-batch-download-ima/nnjjahlikiabnchcpehcpkdeckfgnohf/RK%3D2/RS%3DPnB3CMxxSoOYRnLD3KKFviCVQvs-).

###  At some point we should check our dataset for duplicate images
Some utilities in no particular order
```bash
fdupes .
```


###  LabelImg hotkeys shortcuts

- ctrl+s  : Save
- w	: Rectangle box
- d : Next images

In the LabelImg file menu view set the following for quick annotation of a single class :
  [x] Auto Save mode
  [x] Single class mode 

You can find more shortcuts on the [LabelImg github page](https://github.com/tzutalin/labelImg).


### List fileformat types in a folder
```bash
find . -type f | awk -F. '!a[$NF]++{print $NF}'
```
Example output
```
 jpg
 jpeg
 png
 PNG
```


### Rename file extension "s/oldExtension/newExtension/" *.txt
```bash
rename "s/jpeg/jpg/" *.jpeg
rename "s/JPG/jpg/" *.JPG
rename "s/JPEG/jpg/" *.JPEG
rename "s/PNG/png/" *.PNG
```

### Convert images from png to jpg format
```bash
mogrify -format jpg *.png
rm *.png
```



### Rename the files in sequence
Output filenames are 00001.jpg, 00002.jpg .....

```bash
#!/bin/bash

a=1
for i in *.jpg; do
  new=$(printf "%05.jpg" "$a") 
  mv -i -- "$i" "$new"
  let a=a+1
done
```


### Check jpeg file for errors
```bash
find . -iname "*.jpg" -exec jpeginfo -c {} \; | grep -E "WARNING|ERROR"
```
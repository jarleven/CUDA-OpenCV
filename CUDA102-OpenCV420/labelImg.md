


# Install Google Chrome

wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo apt install -y ./google-chrome-stable_current_amd64.deb


# Batch download images with Fatkun Batch Download Image
# https://chrome.google.com/webstore/detail/fatkun-batch-download-ima/nnjjahlikiabnchcpehcpkdeckfgnohf/RK%3D2/RS%3DPnB3CMxxSoOYRnLD3KKFviCVQvs-

# At some point we should check our dataset for duplicate images
# https://towardsdatascience.com/how-to-build-an-image-duplicate-finder-f8714ddca9d2


# LabelImg hotkeys shortcuts

# ctrl+s  : Save
# w	: Rectangle box
# d : Next images

In the file menu view. Set Auto Save mode and single class mode for quick annotation of a single class.

You can find more shortcuts on the LabelImg github page https://github.com/tzutalin/labelImg





https://tensorflow-object-detection-api-tutorial.readthedocs.io/en/latest/training.html

# List fileformat types in a folder
find . -type f | awk -F. '!a[$NF]++{print $NF}'

# exapple outrput
# jpg
# jpeg
# png
# PNG



# rename "s/oldExtension/newExtension/" *.txt

rename "s/jpeg/jpg/" *.jpeg
rename "s/JPG/jpg/" *.JPG
rename "s/JPEG/jpg/" *.JPEG

rename "s/PNG/png/" *.PNG


# Convert images from png to jpg format
mogrify -format jpg *.png
rm *.png




# Rename the files in sequence
# 00001.jpg, 00002.jpg .....
#

#!/bin/bash

a=1
for i in *.jpg; do
  new=$(printf "%05.jpg" "$a") 
  mv -i -- "$i" "$new"
  let a=a+1
done



# Check jpeg file for errors
find . -iname "*.jpg" -exec jpeginfo -c {} \; | grep -E "WARNING|ERROR"



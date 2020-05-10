# Just a hack to print debug images for my dataset

import numpy as np
import cv2 as cv
import time
from timeit import default_timer as timer



#pip3 install opencv-python libs numpy
#cp -r ~/labelImg/libs/ .


# labelImg test_io.py thanks to https://github.com/tzutalin/labelImg
# Unserstand the xml format https://towardsdatascience.com/coco-data-format-for-object-detection-a4c5eaf518c5
from libs.pascal_voc_io import PascalVocWriter, PascalVocReader

# File and path modifications
import glob
from pathlib import Path, PurePosixPath, PurePath
import os

# For copying files
import shutil

# TODO: Pass on cli!
modelpath="/home/jarleven/EXPORTED/frozen_inference_graph.pb"
inputpath="/tmp/ramdisk/full/"
rootpath="/tmp/ramdisk/annotated"
rootpathdebug="/tmp/ramdisk/annotateddebug"
xmlpathheader="/home/jarleven/tmp"
scorelimit="0.9"

import sys, getopt

# MAGIC STRINGS AND NUMBERS
objectname="salmon"


# The name of this script
scriptname=__file__

print("python3 %s -i <inputfolder> -o <outputfolder>" % scriptname)


def printHelp():
    print("")
    print("python3 %s -i <inputfolder> -o <outputfolder>" % scriptname)
    print("")

def debugParams():
    print(" Test model ")
    print("Input folder is  : ", inputpath)
    print("Output folder is : ", outputpath)
    print("")


try:
    opts, args = getopt.getopt(sys.argv[1:],"hi:o:d:m:l:t",["inputpath=","outputpath="])
except getopt.GetoptError:
      print("Arguments error")
      debugParams()
      printHelp()
      sys.exit(2)
for opt, arg in opts:
    if opt == '-h':
       printHelp()
       sys.exit()
    elif opt in ("-i", "--inputpath"):
       inputpath = arg
    elif opt in ("-o", "--outputpath"):
       outputpath = arg



# TODO add params
#   Swrite xml optional
#   verbose
#   Create folders if they don't exist




# The files to process
# TODO there is a job to do regarding paths
filenames = glob.glob(inputpath+"*.jpg")
filenames.sort()




from datetime import datetime



for name in filenames:

    cap = cv.VideoCapture(name)
    ret, img = cap.read()


    if ret == False:
        break

    print("Processing file %s" % name)


    rows = img.shape[0]
    cols = img.shape[1]
  #  inp = cv.resize(img, (800, 800))
  #  inp = inp[:, :, [2, 1, 0]]  # BGR2RGB

    #TODO get the depth from the image

    filename=PurePosixPath(name).name
    filexml=Path(name).stem + '.xml'
    filepng=Path(name).stem + '.png'

    printname=Path(name).stem





    xmlfilepath=PurePath(inputpath, filexml)
    jpgfilepath=PurePath(outputpath, filename)

    pngfilepath=PurePath(outputpath, filepng)


    print("XML file %s" % xmlfilepath)

    reader = PascalVocReader(xmlfilepath)
    shapes = reader.getShapes()
    print(reader.verified)

    print(shapes)
    print(len(shapes))

    #[('salmon', [(1, 262), (337, 262), (337, 588), (1, 588)], None, None, True)]
    # Scale font to picture but anything smaller than 0.55 is not readable
    font_scale=max(float(cols/1000),0.55)
    #fontsize=float(cols/1000)
    text_offset_x=int(cols/40)
    text_offset_y=int(rows/40) + 10
    #linesize=1
    font = cv.FONT_HERSHEY_PLAIN
    #double scale = 0.4;
    thickness = 1;
    baseline = 0;



    # set the rectangle background to white
    rectangle_bgr = (255, 255, 255)


    numshapes=len(shapes)


    print("Boxes %d   Img size %dx%d    %3.2f   %d %d" % (numshapes, rows, cols, font_scale, text_offset_x, text_offset_y))
    text= "Boxes %d   Img size %dx%d" % (numshapes, rows, cols)
    # get the width and height of the text box
    (text_width, text_height) = cv.getTextSize(text, font, fontScale=font_scale, thickness=1)[0]

    # make the coords of the box with a small padding of two pixels Thanks to https://gist.github.com/aplz/fd34707deffb208f367808aade7e5d5c
    box_coords = ((text_offset_x, text_offset_y), (text_offset_x + text_width + 2, text_offset_y - text_height - 2))
    cv.rectangle(img, box_coords[0], box_coords[1], rectangle_bgr, cv.FILLED)
    cv.putText(img, text, (text_offset_x, text_offset_y), font, fontScale=font_scale, color=(0, 0, 0), thickness=thickness)



    for x in range(0, numshapes):

        print(shapes[x])
        upperleft=shapes[x][1][0]
        lowerright=shapes[x][1][2]


        cv.rectangle(img, upperleft, lowerright, (125, 255, 51), thickness=thickness)

    #fontsize=0.79999


    #cv.putText(img, label, (fontposx, fontposy), cv.FONT_HERSHEY_SIMPLEX, scale, (125, 255, 51), linesize)





    cv.imwrite(os.path.join(outputpath , filepng),img)
    #sys.exit()

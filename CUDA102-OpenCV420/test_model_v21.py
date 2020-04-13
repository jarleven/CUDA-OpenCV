import numpy as np
import tensorflow as tf
import cv2 as cv
from timeit import default_timer as timer

from libs.pascal_voc_io import PascalVocWriter



import glob
from pathlib import Path, PurePosixPath, PurePath

# For copying files
import shutil


#Path('/root/dir/sub/file.ext').stem




print("Hello World")


filenames = glob.glob("./*.jpg")
filenames.sort()

#images = [cv.imread(img) for img in filenames]

for name in filenames:
    print(name)


print("----------")

#
# For tensorflow 2.1. File was upgraded with 
# tf_upgrade_v2 --infile test_model.py --outfile test_model_v21.py
#
#


#
#  Use the labelImg xml lib for writing Pascal VOC xml files
#  wget https://raw.githubusercontent.com/tzutalin/labelImg/master/libs/pascal_voc_io.py
#

#
#  Unserstand the xml format
#  https://towardsdatascience.com/coco-data-format-for-object-detection-a4c5eaf518c5

imagefile="img01.jpg"

#cap = cv.VideoCapture("fisk.mp4")

#cap = cv.VideoCapture("/home/jarleven/IMAGESEQUENCE/%5d.jpg")
#cap = cv.VideoCapture("/tmp/ramdisk/full/%05d.jpg")
cap = cv.VideoCapture("./img01.jpg")




from datetime import datetime



# Read the graph.
with tf.io.gfile.GFile('/home/jarleven/EXPORTED/frozen_inference_graph.pb', 'rb') as f:
    graph_def = tf.compat.v1.GraphDef()
    graph_def.ParseFromString(f.read())



with tf.compat.v1.Session() as sess:
    # Restore session
    sess.graph.as_default()
    tf.import_graph_def(graph_def, name='')
    imgnum=0
    totalhits=0
    print("\nStarting object detection\n")
    print(datetime.utcnow().strftime('%Y-%m-%d %H:%M:%S.%f')[:-3])

    #while True:
    for name in filenames:

        cap = cv.VideoCapture(name)


        start = timer()
        ret, img = cap.read()

        if ret == False:
            break

        imgnum=imgnum+1
        # Read and preprocess an image.
        #img = cv.imread('/home/jarleven/TESTIMAGE/example.jpg')
        rows = img.shape[0]
        cols = img.shape[1]
        inp = cv.resize(img, (800, 800))
        inp = inp[:, :, [2, 1, 0]]  # BGR2RGB



        # Run the model
        out = sess.run([sess.graph.get_tensor_by_name('num_detections:0'),
                    sess.graph.get_tensor_by_name('detection_scores:0'),
                    sess.graph.get_tensor_by_name('detection_boxes:0'),
                    sess.graph.get_tensor_by_name('detection_classes:0')],
                   feed_dict={'image_tensor:0': inp.reshape(1, inp.shape[0], inp.shape[1], 3)})


        # Visualize detected bounding boxes.
        hit=False

        #TODO get the depth from the image
        # labelImg test_io.py thanks to https://github.com/tzutalin/labelImg


        filename=PurePosixPath(name).name
        filexml=Path(name).stem + '.xml'

        xmlfilepath=PurePath("/home/jarleven/annotated", filexml)
        jpgfilepath=PurePath("/home/jarleven/annotated", filename)

        debugfilepath=PurePath("/home/jarleven/annotateddebug", filename)

        print("Files:")
        print(xmlfilepath)
        print(jpgfilepath)
        print(debugfilepath)
        print("Files end")

        depth=3  # Depth is 3 for color images
        objectname="salmon"
        writer = PascalVocWriter("/home/jarleven/tmp", filename, (cols, rows, depth))
        difficult = 1

        print("File [%s] Object [%s] width [%d]   height [%d]  depth [%d]" % (filename, objectname, cols, rows, depth))



        maxscore_img=0
        num_detections = int(out[0][0])
        for i in range(num_detections):
            classId = int(out[3][0][i])
            score = float(out[1][0][i])
            bbox = [float(v) for v in out[2][0][i]]
            if score > 0.3:
                if score > maxscore_img:
                    maxscore_img = score
                x = bbox[1] * cols
                y = bbox[0] * rows
                right = bbox[3] * cols
                bottom = bbox[2] * rows
                cv.rectangle(img, (int(x), int(y)), (int(right), int(bottom)), (125, 255, 51), thickness=2)

                xmin=int(x)
                ymin=int(y)
                xmax=int(right)
                ymax=int(bottom)

                hit=hit+1
                print("         xmin[%d] ymin[%d] xmax[%d] ymax[%d] " % (xmin, ymin, xmax, ymax))

                writer.addBndBox(xmin, ymin, xmax, ymax, objectname, difficult)


        end = timer()
        print("Image analyzed in %.3f seconds " % (end - start))

        if(hit > 0):
            #writer.addBndBox(113, 40, 450, 403, 'face', difficult)
            writer.save(xmlfilepath)
            shutil.copyfile(filename, jpgfilepath)

            # labelImg test_io.py
            totalhits=totalhits+1
            cv.putText(img, "%02d hits with max score %.3f" % (hit, maxscore_img), (50, 50), cv.FONT_HERSHEY_SIMPLEX, 0.5, (125, 255, 51), 2)
            savefile = "%d.png" % (imgnum)
            cv.imwrite(savefile, img)
            cv.imshow('object detection', cv.resize(img, (800,600)))
            if cv.waitKey(25) & 0xFF == ord('q'):
                cv.destroyAllWindows()
                break

print(datetime.utcnow().strftime('%Y-%m-%d %H:%M:%S.%f')[:-3])
print("Total hits   = %05d" % totalhits)
print("Total images = %05d" % imgnum)

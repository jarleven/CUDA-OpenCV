import numpy as np
import tensorflow as tf
import cv2 as cv


#cap = cv.VideoCapture("fisk.mp4")

#cap = cv.VideoCapture("/home/jarleven/IMAGESEQUENCE/%5d.jpg")
cap = cv.VideoCapture("/tmp/ramdisk/full/%05d.jpg")


from datetime import datetime



# Read the graph.
with tf.gfile.FastGFile('/home/jarleven/EXPORTED/frozen_inference_graph.pb', 'rb') as f:
    graph_def = tf.GraphDef()
    graph_def.ParseFromString(f.read())



with tf.Session() as sess:
    # Restore session
    sess.graph.as_default()
    tf.import_graph_def(graph_def, name='')
    imgnum=0
    totalhits=0
    print("\nStarting object detection\n")
    print(datetime.utcnow().strftime('%Y-%m-%d %H:%M:%S.%f')[:-3])

    while True:

        ret, img = cap.read()

        if ret == False:
            break

        imgnum=imgnum+1
        # Read and preprocess an image.
        #img = cv.imread('/home/jarleven/TESTIMAGE/example.jpg')
        rows = img.shape[0]
        cols = img.shape[1]
        inp = cv.resize(img, (300, 300))
        inp = inp[:, :, [2, 1, 0]]  # BGR2RGB



        # Run the model
        out = sess.run([sess.graph.get_tensor_by_name('num_detections:0'),
                    sess.graph.get_tensor_by_name('detection_scores:0'),
                    sess.graph.get_tensor_by_name('detection_boxes:0'),
                    sess.graph.get_tensor_by_name('detection_classes:0')],
                   feed_dict={'image_tensor:0': inp.reshape(1, inp.shape[0], inp.shape[1], 3)})


        # Visualize detected bounding boxes.
        hit=False
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

                hit=hit+1






        if(hit > 0):
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

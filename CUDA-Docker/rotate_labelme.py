#https://www.programmersought.com/article/24574758997/

import sys
import os
import cv2
import numpy as np
import random
import time
import json
import base64
 
from math import cos ,sin ,pi,fabs,radians
 
 
 
 
 #Read json
def readJson(jsonfile):
    with open(jsonfile,encoding='utf-8') as f:
        jsonData = json.load(f)
    return jsonData
 
def rotate_bound(image, angle):
    """
         Rotate image
         :param image: image
         :param angle: angle
         :return: the rotated image
    """
    h, w,_ = image.shape
    # print(image.shape)
    (cX, cY) = (w // 2, h // 2)
    print(cX,cY)
 
    M = cv2.getRotationMatrix2D((cX, cY), -angle, 1.0)
    cos = np.abs(M[0, 0])
    sin = np.abs(M[0, 1])
 
    nW = int((h * sin) + (w * cos))
    nH = int((h * cos) + (w * sin))
    # print(nW,nH)
    M[0, 2] += (nW / 2) - cX
    M[1, 2] += (nH / 2) - cY
    # print( M[0, 2], M[1, 2])
    image_rotate = cv2.warpAffine(image, M, (nW, nH),borderValue=(255,255,255))
    return image_rotate,cX,cY,angle
 
 
def dumpRotateImage(img, degree):
    height, width = img.shape[:2]
    heightNew = int(width * fabs(sin(radians(degree))) + height * fabs(cos(radians(degree))))
    widthNew = int(height * fabs(sin(radians(degree))) + width * fabs(cos(radians(degree))))
    matRotation = cv2.getRotationMatrix2D((width // 2, height // 2), degree, 1)
    matRotation[0, 2] += (widthNew - width) // 2
    matRotation[1, 2] += (heightNew - height) // 2
    print(width // 2,height // 2)
    imgRotation = cv2.warpAffine(img, matRotation, (widthNew, heightNew), borderValue=(255, 255, 255))
    return imgRotation,matRotation
 
 
def rotate_xy(x, y, angle, cx, cy):
    """
         Point (x,y) rotates around (cx,cy) point
    """
    # print(cx,cy)
    angle = angle * pi / 180
    x_new = (x - cx) * cos(angle) - (y - cy) * sin(angle) + cx
    y_new = (x - cx) * sin(angle) + (y - cy) * cos(angle) + cy
    return x_new, y_new
 
 
 # base64
def image_to_base64(image_np):
    image = cv2.imencode('.jpg', image_np)[1]
    image_code = str(base64.b64encode(image))[2:-1]
    return image_code
 
 #Coordinate rotation
def rotatePoint(Srcimg_rotate,jsonTemp,M,imagePath):
    json_dict = {}
    for key, value in jsonTemp.items():
        if key=='imageHeight':
            json_dict[key]=Srcimg_rotate.shape[0]
            print('gao',json_dict[key])
        elif key=='imageWidth':
            json_dict[key] = Srcimg_rotate.shape[1]
            print('kuai',json_dict[key])
        elif key=='imageData':
            json_dict[key] = image_to_base64(Srcimg_rotate)
        elif key=='imagePath':
            json_dict[key] = imagePath
        else:
            json_dict[key] = value
    for item in json_dict['shapes']:
        for key, value in item.items():
            if key == 'points':
                for item2 in range(len(value)):
                    pt1=np.dot(M,np.array([[value[item2][0]],[value[item2][1]],[1]]))
                    value[item2][0], value[item2][1] = pt1[0][0], pt1[1][0]
    return json_dict
 
 #Save json
def writeToJson(filePath,data):
    fb = open(filePath,'w')
    fb.write(json.dumps(data,indent=2)) # ,encoding='utf-8'
    fb.close()
 
if __name__=='__main__':
 
    #path = './image/'
   
    import argparse

    # Parse command line arguments
    parser = argparse.ArgumentParser(
        description='Train Mask R-CNN to detect balloons.')
    parser.add_argument('--image', required=True,
                        metavar="path or URL to image",
                        help='Image to rotate')
    parser.add_argument('--angle',  type=int, required=True,
                        metavar="Angle to totate image",
                        help='')
    args = parser.parse_args()

    
    imagepath=os.path.splitext(args.image)[0]
    imagename=os.path.basename(imagepath)
    
    print(imagepath + " " + imagename)
    
 
    Srcimg = cv2.imread(imagepath + '.jpg')  ##########gai label1,label2
    jsonData = readJson(imagepath + '.json') ######## Read json
    Srcimg_rotate,M = dumpRotateImage(Srcimg, args.angle) ###### 270 degrees counterclockwise
    jsonData2=rotatePoint(Srcimg_rotate,jsonData,M,imagepath + '.jpg')
    cv2.imwrite('./result/' + imagename + '_rotated_' + str(args.angle) + '.jpg' , Srcimg_rotate)
    writeToJson('./result/' + imagename + '_rotated_' + str(args.angle) + '.json', jsonData2)
    print('ok')
 

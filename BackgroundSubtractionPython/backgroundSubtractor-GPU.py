"""
    Simple example of a connection to 

    IPC (720P) Motorized Zoom & Auto Focal LEN 1/3" Aptina AR0130 CMOS Hi3518C CCTV IP camera
    Default IP 192.168.1.10

    Sony IMX module
    Default IP 192.168.1.88

"""
import os
import cv2
import sys
import numpy as np
from time import gmtime, strftime, time

print ('Number of arguments:', len(sys.argv), 'arguments.')
print ('Argument List:', str(sys.argv))

if len(sys.argv) == 2:
    inputfile = str(sys.argv[1])
else:
    print("Please specify input file")


inPath, inFile = os.path.split(inputfile)

camera = cv2.VideoCapture(inputfile)


bShadowDetection = False
history = 300
varThreshold = 100

fgbg = cv2.createBackgroundSubtractorMOG2(history, varThreshold, bShadowDetection)

t = open('contourslog.txt','a')

print("Procesing %s " % inputfile)

starttime=gmtime()
startsec=time()

print(strftime("%Y-%m-%d %H:%M:%S", gmtime()))

bigblob = 0
bigblobid = 0
frameid = 0
skip = 0
height = 960
width = 1280

ret, mat = camera.read()
if ret == False:
    print("Read error")

frame = cv2.UMat(mat)
tresh = frame

savecounter=0

while(1):
    save = False
    frameid = frameid + 1
    skip = skip + 1

    ret, mat = camera.read()
    crop_original = mat
    frame = cv2.UMat(mat)

    continue

    frame_copy= frame

    if ret == False:
        print("End of file %s" % inputfile)
        print("Processed %d seconds of film. Saved %d tumbnails" % (int(frameid/24), savecounter ))
        stopsec = time()
        print(strftime("%Y-%m-%d %H:%M:%S", gmtime()), strftime("%Y-%m-%d %H:%M:%S", starttime))
        print("Start stop diff %d %d %d secs speed %f" % (stopsec, startsec, stopsec-startsec, float((frameid/24)/(stopsec-startsec)) ))
        break

    #height, width, channels = frame.shape

    frame_copy = fgbg.apply(frame_copy)
    

    if frameid < 5:
        continue

    if skip < 6:
        continue

    skip=0

    frame_copy = cv2.dilate(frame_copy, None, iterations=2)
    (_, cnts, _) = cv2.findContours(frame_copy, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)
    #(_, cnts, _) = cv2.findContours(thresh.copy(), cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)


    
    ypos=0
    xpos=0
    # loop over the contours
    for c in cnts:
        # if the contour is too small, ignore it
        if cv2.contourArea(c) < 3000:
            continue

            
        (x,y),radius = cv2.minEnclosingCircle(c)
            
        x = int(x)
        y = int(y)
        center = (x, y)
        radius = int(radius*2)
        cv2.circle(frame,center,radius,(0,255,0),2)

        

        savecounter=savecounter+1    
        save=True
        
        #print("framesize w:h  %d:%d  centerx:y %d:%d  radius %d" % (width, height, x, y, radius))

        if radius > x:
         xpos = 0 
         print("Left border")

        elif radius+x > width:
         xpos = width - (radius*2)
         print("Right border")
	
        else:
         print("Horisontal center")
         xpos = x-radius

        if radius > y:
         ypos = 0
         print("Top border")

        elif radius+y > height:
         ypos = height - (radius*2)
         print("Bottom border")

        else:
         print("Vertical center")
         ypos = y-radius

        lengde=radius*2

        cv2.rectangle(frame,(xpos,ypos),(xpos+lengde,ypos+lengde),(0,255,255),2)	

          
        #print("box left:upper  %d:%d   width = %d" % (x, y, radius*2 ))
        
        
    	#mat = cv2.UMat.get(frame)
        crop_img = crop_original[ypos:lengde+ypos, xpos:lengde+xpos]

        #cv2.imshow('Cropped', crop_img)

        resized = cv2.resize(crop_img, (240,240), interpolation = cv2.INTER_AREA)
        #cv2.imshow("resized", resized)


        savefile = "%s_%d_%d.%s" % (inFile, frameid, savecounter,"jpg")

        print("saving %s" % (savefile))
        cv2.imwrite(savefile, resized)
        writebuf = "%s %d %s_%d.%s" % (inputfile, frameid, inFile, frameid, "jpg")
        t.write(writebuf +"\n")

        #cv2.imshow('Cropped', crop_img)

        ##resized = cv2.resize(crop_img, (240,240), interpolation = cv2.INTER_AREA)
        #cv2.imshow("resized", resized)

    
    '''
    #cv2.putText(frame, "%d " % int(maxcont), cv2.FONT_HERSHEY_SIMPLEX, 0.5, (255, 255, 255), 2)
    cv2.putText(frame, "%d %d time %f   size x:y %d:%d   cropped x:y %d:%d" % (bigblob, maxcont, (frameid/(60*25)), height, width, xpos, ypos), (50, 50), 
                cv2.FONT_HERSHEY_SIMPLEX, 0.5, (255, 255, 255), 2)
    
    #cv2.imshow('fgmask',frame)
    #cv2.imshow('frame',thresh)

    #http://answers.opencv.org/question/175912/how-to-display-multiple-images-in-one-window/
    image = cv2.resize(frame, (0, 0), None, .7, .7)
    
    grey = cv2.resize(thresh, (0, 0), None, .7, .7)
    
    #the grey scale image have three channels
    grey_3_channel = cv2.cvtColor(grey, cv2.COLOR_GRAY2BGR)
    
    numpy_vertical = np.hstack((image, grey_3_channel))
    
    numpy_horizontal_concat = np.concatenate((image, grey_3_channel), axis=1)
    
    #cv2.imshow('Main', image)
    cv2.imshow('Numpy Vertical', numpy_vertical)


    '''

    #if maxcont > bigblob:
    #    bigblob = maxcont
    #    blobid = frameid
    #    if bigblob > 20000:
    #        save = True

    if save:
        #savefile = "%s_%d.%s" % (inFile, frameid, "jpg")
        fullsavefile = "%s_%d-full.%s" % (inFile, frameid, "jpg")

        #print("saving %s" % (savefile))
        #cv2.imwrite(savefile, resized)
        cv2.imwrite(fullsavefile, frame)
        #writebuf = "%s %d %s_%d.%s" % (inputfile, frameid, inFile, frameid, "jpg")
        #t.write(writebuf +"\n")

    '''
    #cv2.imshow('VIDEO', frame)
    cv2.waitKey(1)
    
    key = cv2.waitKey(1) & 0xFF
    
    # if the `q` key is pressed, break from the lop
    if key == ord("q"):
        break
    '''
    
camera.release()
cv2.destroyAllWindows()
#writebuf = "%d %d %s " % (bigblob, blobid, inputfile)
#print(writebuf)
#t.write(writebuf +"\n")

t.close()
print(strftime("%Y-%m-%d %H:%M:%S", gmtime()))


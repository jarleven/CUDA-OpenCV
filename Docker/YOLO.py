# In utils/dataloaders.py   (used to be dataset.py)

from datetime import datetime


    def new_video(self, path):

        now = datetime.now()

        current_time = now.strftime("%H:%M:%S")
        print("%s  opening video %s" % (current_time, path))

        self.frame = 0
        #self.cap = cv2.VideoCapture(path, cv2.CAP_FFMPEG)
        self.cap = cv2.VideoCapture(path)
        self.frames = int(self.cap.get(cv2.CAP_PROP_FRAME_COUNT))

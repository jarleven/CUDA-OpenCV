#/bin/bash

STARTDATE=$(date)

rm /tmp/ramdisk/full/*
rm /media/jarleven/Extended/tmp/annotated/*
rm /media/jarleven/Extended/tmp/debug/*


rm list.txt
touch list.txt


find /media/jarleven/Extended/ -name '*.mp4'  -print0 |
    while IFS= read -r -d '' line; do
	    file "$line"
	    echo $line >> list.txt

            ./background_subtraction "$line"
	    python3 ~/CUDA-OpenCV/CUDA102-OpenCV420/test_model_v21.py -m /home/jarleven/EXPORTED4/frozen_inference_graph.pb -o /media/jarleven/Extended/tmp/annotated -d /media/jarleven/Extended/tmp/debug
	    rm /tmp/ramdisk/full/*
    done

ENDDATE=$(date)


echo "Num files"
cat list.txt | wc -l

echo ""
echo "Size"
du -ch `cat list.txt` | tail -1 | cut -f 1


echo $STARTDATE
echo $ENDDATE



## My own model.

* LabelImg
* Resize images
* Transform images
* Train/evaluate
* Replace default LearnPet in https://coral.ai/docs/edgetpu/retrain-detection/#start-training



### Train and evaluate dirtribution
```
cd $HOME

git clone https://github.com/jarleven/Notes.git

mkdir model
cp -r $HOME/Notes/SalmonModel/* $HOME/model
cd $HOME/model

ls -1 *.jpg | sed -e 's/\..*$//' > list.txt

NUMELEMENTS=$(wc -l < list.txt)

PERCENTAGE=70
a=$((  NUMELEMENTS *PERCENTAGE/100))
b=$((a + 1))

echo $a
echo $b

sort -R list.txt > list.tmp
head -n $a list.tmp > test.txt
tail -n +$b list.tmp > trainval.txt
```




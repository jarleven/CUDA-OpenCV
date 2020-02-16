#!/bin/bash


source .setupstate

echo "We are at sate $OPENCV_SETUPSTATE "

case $OPENCV_SETUPSTATE in

  1)
    echo -n "Update system \n\n"

    echo "OPENCV_SETUPSTATE="2"" > .setupstate
    ;;

  2)
    echo -n "Install drivers \n\n"
    ;;

  3)
    echo -n "cleanup \n\n"
    ;;

  10)
    echo -n "We are done \n\n"
    ;;

  *)
    echo -n "unknown install state \n\n"
    ;;
esac


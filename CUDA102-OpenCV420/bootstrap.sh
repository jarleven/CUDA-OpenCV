#!/bin/bash

set -e  # Exit immediately if a command exits with a non-zero status. Exit on error
set -x  # Print commands and their arguments as they are executed.
set -u  # Treat unset variables as an error when substituting.


echo "Bootstrapping this script, so it will run on next boot"
echo "Run the following command to remove the bootstrap/stop the script"
echo "rm ~/.config/autostart/opencv.desktop"
echo ""
	
mkdir ~/.config/autostart
cp opencv.desktop ~/.config/autostart/

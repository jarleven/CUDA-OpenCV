#!/bin/bash

#
# Create a list of installed packages on your system
#

# cd into the folder where this script is located
cd "$(dirname "$0")"


date > installed-packages.txt

echo -e "APT Packages\n" >> installed-packages.txt
sudo apt list --installed >> installed-packages.txt

echo ""
echo -e "PIP3 Packages\n" >> installed-packages.txt

pip3 list >> installed-packages.txt


echo ""
echo -e "PIP Packages\n" >> installed-packages.txt
pip list >> installed-packages.txt


echo ""
echo -e "Homebrew Packages\n" >> installed-packages.txt
brew list >> installed-packages.txt




# pip3 list --not-required

# https://pip.pypa.io/en/stable/reference/pip_list/
# --not-required
# List packages that are not dependencies of installed packages.

#
# sudo apt list --installed
# pip3 list
# pip list

# brew list
# brew cask list

# brew leaves shows you all top-level packages. That is packages that are not dependencies. This should be the most interesting if you are using the list to re-install packages

# https://unix.stackexchange.com/questions/369136/list-top-level-manually-installed-packages-without-their-dependencies
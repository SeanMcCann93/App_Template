#!/bin/bash

echo " "
echo "List of current Docker Images"
echo "----------------------------------------------------------------------------"
docker images # Show a list of Images
echo "----------------------------------------------------------------------------"
echo " "
read -p "What is the image Repository? " ImgName
read -p "What is the image Tag? "ImgTag
read -p "What Port is the image to run on? " Port
read -p "Detach from container $Hint? " yn
case $yn in
    [Yy]* ) # Force the content through
        Hint="(Y/N)"
        Flags="dp" # Detach and allow for port to be assigned
        break;;
    [Nn]* ) # Change the contents of ImgName and run test again
        Hint="(Y/N)"
        Flags="p" # Allow Port to be assignend
        break;;
    * ) # Not a valid entry
        Hint="(Please answer with 'Yy' or 'Nn' only!)" # Change Hint to assist user
        echo " ";;
esac
docker run -$Flags $Port:$Port $ImgName:$ImgTag
echo "List of current Docker Pods"
echo "----------------------------------------------------------------------------"
docker ps # Show a list of Pods
echo "----------------------------------------------------------------------------"
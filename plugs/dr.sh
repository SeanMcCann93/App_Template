#!/bin/bash

# Docker Remove Image Plug ~ dremove
echo " "
echo "List of current Docker Images"
echo "----------------------------------------------------------------------------"
docker images # Show a list of Images
echo "----------------------------------------------------------------------------"
echo " "
echo "REMOVE IMAGE"
echo " "
echo "To remove many at one time, use a space between each in line!"
echo "If you wish to remove all images then type 'all' and press enter"
echo " "
read -p "What is the 'IMAGE ID'? - " ImgID
echo " "
if [ $ImgID = "all"]
then
    docker images -a -q | xargs docker rmi -f
else
    docker rmi $ImgID
fi
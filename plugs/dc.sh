#!/bin/bash

SpaceTest=false
Hint="(Y/N)"

# Docker Create Image Plug ~ dcreate
echo " "
echo "List of current Docker Images"
echo "----------------------------------------------------------------------------"
docker images # Show a list of Images
echo "----------------------------------------------------------------------------"
echo " "
echo "CREATE NEW IMAGE"
echo " "
echo "Please, only use '-', '_' or CamulCase for spacing in naming!"
echo " "
read -p "What is the name of this new 'image'? - " ImgName
echo " "
while [ $SpaceTest = false ]
do
    case "$ImgName" in  
        *\ * )
            echo "----------------------------------------------------------------------------"
            echo "Warning !"
            echo "----------------------------------------------------------------------------"
            echo " "
            echo "'docker build -t $ImgName:*'"
            echo " "
            echo "is not a valid input recomended for this tool."
            echo "Spaces can run potentially run additional commands."
            read -p "Do you wish to continue $Hint? " yn # Optional Pull of git changes
            case $yn in
                [Yy]* ) 
                    echo " "
                    $SpaceTest = true
                    Hint="(Y/N)"
                    break;;
                [Nn]* )
                    echo " "
                    Hint="(Y/N)"
                    read -p "What is the new name of the 'image'? - " ImgName
                    echo " ";;
                * )
                    Hint="(Please answer with 'Yy' or 'Nn' only!)"
                    echo " ";;
            esac
            ;;
        *)
            $SpaceTest = true
            break;;
    esac
done

read -p "What tag? (i.e. version-*, v*, *.)    - " ImgTag

$SpaceTest = false

while [ $SpaceTest = false ]
do
    case "$ImgTag" in  
        *\ * )
            echo "----------------------------------------------------------------------------"
            echo "Warning !"
            echo "----------------------------------------------------------------------------"
            echo " "
            echo "'docker build -t $ImgName:$ImgTag'"
            echo " "
            echo "is not a valid input recomended for this tool."
            echo "Spaces can run potentially run additional commands."
            read -p "Do you wish to continue $Hint? " yn # Optional Pull of git changes
            case $yn in
                [Yy]* ) 
                    echo " "
                    $SpaceTest = true
                    break;;
                [Nn]* )
                    echo " "
                    Hint="(Y/N)"
                    read -p "What is the new name of the 'image Tag'? - " ImgTag
                    echo " ";;
                * )
                    Hint="(Please answer with 'Yy' or 'Nn' only!)"
                    echo " "
                ;;
            esac
            ;;
        *)
            $SpaceTest = true
            break;;
    esac
done

docker build -t $ImgName:$ImgTag
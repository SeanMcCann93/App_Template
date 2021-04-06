#!/bin/bash

SpaceTest=false # Space test will be used to cheack spaces in naming
Hint="(Y/N)" # Used to assist the user with correct imputs

# Docker Build Image Plug ~ dbuild
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
read -p "What is the name of this new 'image'? - " ImgName # Set a name for the image
echo " "
while [ $SpaceTest = false ]
do
    case "$ImgName" in  
        *\ * ) # If the variable holds any spaces, run the following
            echo "----------------------------------------------------------------------------"
            echo "Warning !"
            echo "----------------------------------------------------------------------------"
            echo " "
            echo "'docker build -t $ImgName:*'"
            echo " "
            echo "is not a valid input recomended for this tool."
            echo "Spaces can run potentially run additional commands."
            read -p "Do you wish to continue $Hint? " yn
            case $yn in
                [Yy]* ) # Force the content through
                    echo " "
                    $SpaceTest = true
                    Hint="(Y/N)"
                    break;;
                [Nn]* ) # Change the contents of ImgName and run test again
                    echo " "
                    Hint="(Y/N)"
                    read -p "What is the new name of the 'image'? - " ImgName
                    echo " ";;
                * ) # Not a valid entry
                    Hint="(Please answer with 'Yy' or 'Nn' only!)" # Change Hint to assist user
                    echo " ";;
            esac
            ;;
        *) # Data has no spaces and assed test
            $SpaceTest = true
            break;;
    esac
done
read -p "What tag? (i.e. version-*, v*, *.)    - " ImgTag # Set the Tag associated with image
$SpaceTest = false
while [ $SpaceTest = false ]
do
    case "$ImgTag" in  
        *\ * ) # If the variable holds any spaces, run the following
            echo "----------------------------------------------------------------------------"
            echo "Warning !"
            echo "----------------------------------------------------------------------------"
            echo " "
            echo "'docker build -t $ImgName:$ImgTag'"
            echo " "
            echo "is not a valid input recomended for this tool."
            echo "Spaces can run potentially run additional commands."
            read -p "Do you wish to continue $Hint? " yn
            case $yn in
                [Yy]* ) # Force the content through
                    echo " "
                    $SpaceTest = true
                    break;;
                [Nn]* ) # Change the contents of ImgName and run test again
                    echo " "
                    Hint="(Y/N)"
                    read -p "What is the new name of the 'image Tag'? - " ImgTag
                    echo " ";;
                * ) # Not a valid entry
                    Hint="(Please answer with 'Yy' or 'Nn' only!)" # Change Hint to assist user
                    echo " "
                ;;
            esac
            ;;
        *) # Data has no spaces and assed test
            $SpaceTest = true
            break;;
    esac
done

docker build -t $ImgName:$ImgTag # Build the image using the variable data established
echo " "
docker image prune # If this creates a Hanging Image (dispalyed and <none>) then it will be removed
echo " "
echo "----------------------------------------------------------------------------"
docker image $ImgName # Show New Images
echo "----------------------------------------------------------------------------"
#!/bin/bash

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
read -p "What tag? (i.e. version-*, v*, *.)    - " ImgTag
echo " "


SpaceTest=false

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
            read -p "Do you wish to continue (Y/N)? " yn # Optional Pull of git changes
                case $yn in
                    [Yy]* ) 
                        $SpaceTest=true
                        break;;
                    [Nn]* )
                        echo " "
                        read -p "What is the new name of the 'image'? - " ImgName
                        echo " ";;
                    * )
                        echo "Please answer with 'y' or 'n'."
                    ;;
                esac
            ;;
        *)
            $SpaceTest=true
            ;;
    esac
done

case "$ImgTag" in  
     *\ * )
        echo "Warning !"
        echo " "
        echo "'docker build -t $ImgName:$ImgTag'"
        echo " "
        echo "is not a valid input recomended for this tool."
        echo "Spaces can run potentially run additional commands."
        read -p "Do you wish to continue (Y/N)? " yn # Optional Pull of git changes
            case $yn in
                [Yy]* ) 
                    break;;
                [Nn]* )
                    echo " "
                    read -p "What is the new name of the 'image Tag'? - " ImgTag
                    echo " "
                    break;;
                * )
                    echo "Please answer with 'y' or 'n'."
                ;;
            esac
          ;;
       *)
           echo "NoSpacesInTag"
           ;;
esac

echo "docker build -t $ImgName:$ImgTag"
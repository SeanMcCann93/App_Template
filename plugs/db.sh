#!/bin/bash

SpaceTest=false # Space test will be used to cheack spaces in naming
Complete=false
DocDirs=$(ls -F | grep \/$)
DocDirsNUM=$(ls -F | grep \/$ | wc -l)
Fail=false
Return=false
NUMList=""

# Docker Build Image Plug ~ dbuild
echo " "
echo "List of current Docker Images"
echo "----------------------------------------------------------------------------"
docker images # Show a list of Images
echo "----------------------------------------------------------------------------"
while [ $Complete = false ] & [ $Fail = false ]
do
    if [ -d 'Dockerfile' ] # If the repository file .git is found in current directory...
    then # is found then...
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
                            Hint="(Y/N)"
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
        docker build -t $ImgName:$ImgTag $DocDir # Build the image using the variable data established
        echo " "
        docker image prune # If this creates a Hanging Image (dispalyed and <none>) then it will be removed
        echo " "
        echo "----------------------------------------------------------------------------"
        docker image $ImgName # Show New Images
        echo "----------------------------------------------------------------------------"
        if $Return = true
        then
            cd ..
        fi
    else # is not found
        if [ $Return = false ]
        then
            echo "----------------------------------------------------------------------------"
            echo "Warning !"
            echo "----------------------------------------------------------------------------"
            echo " "
            echo "No Dockerfile found. Please ensure that this file exists..."
            echo " "
            echo "Would it exist in one of the folloing directorires or more..."
            echo $DocDirs
            NUMList=$DocDirs
            if [ $DocDirsNUM = "0" ]
            then
                echo "No additional dirctories found."
                $Fail = true
                echo " "
                break
            fi
        else
            echo "No Docker File in $PWD"
            echo "$NUMList"
            $Return = false
            cd ..
            echo "Try another directory?"
            echo " "
        fi
        read -p "Yes or No (Y/N)? " yn
        sh ~/App_Template/plugs/Upgrade/NUMList.sh
        case $yn in
            [Yy]* )
                echo "----------------------------------------------------------------------------"
                echo "What Directory would you like to enter !"
                echo "----------------------------------------------------------------------------"
                echo "$NUMList"
                echo "----------------------------------------------------------------------------"
                read -p "What Number? " NUMLSel
                echo "----------------------------------------------------------------------------"
                cd ./$DocDirs[$NUMLSel - 1]/
                echo " "
                $Return = true
            ;;
            [Nn]* )
                echo "Thank You."
                $Complete = true
                $Return = false
                break;;
            * )
            while [ $yn != [Yy] or [Nn] ] then
            do
                read "Yes or No (Y/N)? " yn
            done;;
        esac
    fi
done
#!/bin/bash

echo " "
echo "List of current Docker Images"
echo "----------------------------------------------------------------------------"
docker images # Show a list of Images
echo "----------------------------------------------------------------------------"

read -p "Detach from container $Hint? " yn
case $yn in
    [Yy]* ) # Force the content through
        Hint="(Y/N)"
        Flags="dp"
        break;;
    [Nn]* ) # Change the contents of ImgName and run test again
        Hint="(Y/N)"
        Flags="p"
        break;;
    * ) # Not a valid entry
        Hint="(Please answer with 'Yy' or 'Nn' only!)" # Change Hint to assist user
        echo " ";;
esac

docker run -$Flags $Port:$Port 
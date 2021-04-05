#!/bin/bash

homedir=false

echo " "
echo "EXECUTING..."
echo "      ::::::::::::::::::::::::::::::::    ::: :::::::: :::       :::"
echo "    :+:    :+:   :+:        :+:   :+:+:   :+::+:    :+::+:       :+:"
echo "   +:+          +:+        +:+    :+:+:+  +:++:+    +:++:+       +:+"
echo "  :#:          +#+        +#+     +#+ +:+ +#++#+    +:++#+  +:+  +#+"
echo " +#+   +#+#   +#+        +#+      +#+  +#+#+#+#+    +#++#+ +#+#+ +#+"
echo "#+#    #+#   #+#        #+#       #+#   #+#+##+#    #+# #+#+# #+#+#"
echo "###################    ###        ###    #### ########   ###   ###"
echo " "
echo "Launched from '$(pwd)'"
echo " "
echo "----------------------------------------------------------------------------"
echo "CONFIRM PROJECT ROOT FOLDER"
echo "----------------------------------------------------------------------------"
echo ""
while [ $homedir = false ]
do
    if [ -d '.git' ]
    then
        echo ""
        echo "** PROJECT ROOT CONFIRMED **"
        echo ""
        echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
        gpush # Calls for the gpush command
        echo "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
        echo ""
        while true; do
            read -p "Do you wish to Pull Git Updates (Y/N)? " yn
            case $yn in
                [Yy]* ) 
                    echo " "
                    echo "----------------------------------------------------------------------------"
                    echo "EXECUTING: Pull"
                    echo "----------------------------------------------------------------------------"
                    echo " "
                    git pull
                    $homedir = true   
                    echo ""
                    echo "RETURN TO ORIGIN DIRECTORY >>> $(pwd)"
                    echo ""
                    break;;
                [Nn]* )
                    break;;
                * ) echo "Please answer with 'y' or 'n'.";;
            esac
        done          
        break
    else
        cd ..
        echo "CHANGE DIRECTORY: $(pwd)"
        if [ $PWD == $HOME ]
        then
            echo "Reached Home Directory. Unable to find root!"
            echo ""
            echo "gitmatch {unsuccessful}"
            echo ""
            break
        fi
    fi
done
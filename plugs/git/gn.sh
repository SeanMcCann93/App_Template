#!/bin/bash

ProjectRootDir=false # Set a new variable to we have found the corrent directory

echo " "
echo "       EXECUTING..."
echo "      ::::::::::::::::::::::::::::::::::    ::: :::::::: :::       :::"
echo "     :+:    :+:   :+:        :+:    :+:+:   :+::+:    :+::+:       :+:"
echo "     +:+          +:+        +:+    :+:+:+  +:++:+    +:++:+       +:+"
echo "     :#:          +#+        +#+    +#+ +:+ +#++#+    +:++#+  +:+  +#+"
echo "     +#+   +#+#   +#+        +#+    +#+  +#+#+#+#+    +#++#+ +#+#+ +#+"
echo "     #+#    #+#   #+#        #+#    #+#   #+#+##+#    #+# #+#+# #+#+#"
echo "      ###################    ###    ###    #### ########   ###   ###"
echo " "
echo "Launched from '$(pwd)'"
echo " "
echo "----------------------------------------------------------------------------"
echo "CONFIRM PROJECT ROOT FOLDER"
echo "----------------------------------------------------------------------------"
echo " "
while [ $ProjectRootDir = false ]
do
    if [ -d '.git' ] # If the repository file .git is found in current directory...
    then # is found then...
        echo " "
        echo "** PROJECT ROOT CONFIRMED **"
        echo " "
        echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
        echo "> PASS OVER TO 'Git PUSH' >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
        echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
        gpush # Calls for the gpush command to upload changes with custom message
        echo "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
        echo "< RETURN TO 'Git NOW' <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
        echo "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
        echo " "
        while true; do
            read -p "Do you wish to Pull Git Updates (Y/N)? " yn # Optional Pull of git changes
            case $yn in
                [Yy]* ) 
                    echo " "
                    echo "EXECUTING: Pull"
                    echo " "
                    echo "<--<--<--<--<--<--<--<--<--<--<--<--<--<--<--<--<--<--<--<--<--<--<--<--<--<"
                    echo " "
                    git pull # Pull down changes made to the repository
                    echo " "
                    echo "<--<--<--<--<--<--<--<--<--<--<--<--<--<--<--<--<--<--<--<--<--<--<--<--<--<"
                    echo " "
                    echo ">>> RETURNING TO ORIGIN DIRECTORY..."
                    echo " "
                    echo "GitNOW {successful}"
                    echo " "
                    break;;
                [Nn]* )
                    break;;
                * ) echo "Please answer with 'y' or 'n'.";;
            esac
        done 
        $ProjectRootDir = true # Set variable to 'True' to brake the loop.   
        break
    else
        cd .. # Go up a file directory.
        echo " - CHANGE DIRECTORY: $(pwd)" # Print out current location.
        if [ $PWD == $HOME ] # If passed and entering root location...
        then # the script is to abort.
            echo "Reached Home Directory. Unable to find root!"
            echo " "
            echo "GitNOW {unsuccessful}"
            echo " "
            break
        fi
    fi
done
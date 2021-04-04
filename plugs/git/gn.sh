#!/bin/bash

homedir=false

echo ""
echo "EXECUTING: GIT NOW!"
echo ""

echo "CONFIRM: Project Root..." 

while [ $homedir = false ]
do
    if [ -d '.git' ]
    then
        echo ""
        echo " ! Root found: $(pwd)"
        echo ""
        gpush # Calls for the gpush command
        while true; do
            read -p "Do you wish to Pull Git Updates?" yn
            case $yn in
                [Yy]* ) echo "EXECUTING: Pull"
                    echo ""
                    git pull
                    $homedir = true   
                    echo ""
                    echo "GIT NOW! {successful}"
                    echo ""
                    break;;
                [Nn]* )
                    break;;
                * ) echo "Please answer with 'y' or 'n'.";;
            esac
        done          
        break
    else
        echo "CHANGE: ./.." 
        cd ..
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
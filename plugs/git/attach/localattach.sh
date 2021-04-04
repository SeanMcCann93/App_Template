#!/bin/bash

# Return to packges
cd ..

# Proceed as Root User
sudo su

# Make files Exicutable
chmod +x ./*.sh

# Create Git Push command
# Create Git Now command
cp ./gp.sh /bin/gpush 
cp ./gn.sh /bin/gnow

# Leave Root User
exit

# Return to attach directory
cd ./attach
#!/bin/bash

cd .. # Return to packges

sudo su # Proceed as Root User

chmod +x ./*.sh # Make files Exicutable

cp ./gp.sh /bin/gpush # Create Git Push commad
cp ./gn.sh /bin/gnow # Create Git Now commad

exit # Leave Root User

cd ./attach # Return to attach directory
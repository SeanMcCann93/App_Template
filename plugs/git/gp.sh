#!/bin/bash

echo "EXECUTING: Git Push!"
echo ""
echo "EXECUTING: Add * from root"

# All files within currect directory is to be set for Upload to Git-Hub
git add .

echo " "

echo "---------------------------------------------------------"

echo "EXECUTING: Status"

echo "---------------------------------------------------------"

echo " "

# Display to the current user the status of the files being uploaded
git status

echo " "

echo "---------------------------------------------------------"
        
echo " "

echo "EXECUTING: Commit"

echo " "

# Request the user to imput a message that will be seen on Git-Hub as a commit message
read -p "Enter commit message: " commiting

echo " "

# Sent commit message and Date+Time Stamp
git commit -m "'${commiting}' ~ $(date +"%D @ %T")"

echo " "

echo "---------------------------------------------------------"

echo "EXECUTING: Status"

echo "---------------------------------------------------------"

# Show the status of the files again for the user to see its progress changed
git status

echo "---------------------------------------------------------"

echo " "

echo "EXECUTING: Push..."

echo " "

# Push the commit to Git-Hub Repository
git push

echo " "

echo 'repo upload {successful}'

echo " "
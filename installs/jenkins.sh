#!/bin/bash

# Install Jquery on the machine
sh java.sh

# Get key to add to apt repository
wget -q -O - http://pkg.jenkins-ci.org/debian/jenkins-ci.org.key | sudo apt-key add -

# Send link to path to enable Jenkins functionality
sudo sh -c 'echo deb http://pkg.jenkins-ci.org/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'

# Update new packets from defined path
sudo apt-get update  -y

# Install new Jenkins packets
sudo apt-get install jenkins  -y

# Start the Jenkins Engine
sudo systemctl start jenkins
#!/bin/bash

# Get token for repository access
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

# Add repository
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
$(lsb_release -cs) \
stable"

# Update apt repository
sudo apt update

# Install Docker
curl https://get.docker.com | sudo bash

# Set Docker as a main command
sudo usermod -aG docker $(whoami)

# Update files after install
sudo apt update

# Confirm Successful Installation
docker --version
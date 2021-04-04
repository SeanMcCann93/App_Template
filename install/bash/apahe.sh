#!/bin/bash

# Gather required Upadtes
apt update && apt upgrade -y

# Enable Uncomplicated Firewall
echo "y" | ufw enable

# Install Apache2
apt install apache2 -y

# Allow Ports to be opened
ufw allow 'Apache'
ufw allow 'OpenSSH'

# Restart Apache to launch application
systemctl restart apache2

# Restart system to confirm changes made to the ports
reset
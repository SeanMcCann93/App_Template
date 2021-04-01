#!/bin/bash
apt update && apt upgrade -y
echo "y" | ufw enable
apt install apache2 -y
ufw allow 'Apache'
ufw allow 'OpenSSH'
systemctl restart apache2
reset
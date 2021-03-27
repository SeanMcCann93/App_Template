#!/usr/bin/env bash

cd /var/lib/jenkins/workspace/${Project-Name}
 
sudo apt update -y
 
sudo apt install python3 -y
 
sudo apt install python3-pip -y
 
sudo apt install python3-venv -y
 
python3 -m venv venv

. /var/lib/jenkins/workspace/${Project-Name}/venv/bin/activate

source ~/.bashrc

pip3 install -r requirements.txt

gunicorn --bind=0.0.0.0:5000 app:app
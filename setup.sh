#!/bin/bash

# install deps
sudo apt update
sudo apt upgrade -y
sudo apt install -y sqlite3 git docker.io

# clone files
sudo git clone -b 1.0.0 https://github.com/ReinierNel/relayctl.git /etc/relayctl

# install cli deps
pip install --no-cache-dir --upgrade -r /etc/relayctl/cli/requirements.txt

# setup db
sudo python /etc/relayctl/db/setup.py

# setup cli
sudo cp /etc/relayctl/cli/main.py /usr/bin/relayctl
sudo chmod +x /usr/bin/relayctl

# start services
sudo docker build /etc/relayctl -t relayctl:1.0.0

# service
sudo chmod +x /etc/relayctl/api/start.sh
sudo /etc/relayctl/start-api.sh
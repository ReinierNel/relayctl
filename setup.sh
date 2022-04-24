#!/bin/bash

# install deps
sudo apt update
sudo apt upgrade -y
sudo apt install sqlite3 git docker.io

#pip install fastapi
#pip install "uvicorn[standard]"
pip install typer
pip install tabulate
#pip install daemonize

# clone files
sudo git clone -b 1.0.0 https://github.com/ReinierNel/relayctl.git /etc/relayctl

# setup db
sudo python /etc/relayctl/db/setup.py

# setup cli
sudo cp /etc/relayctl/cli/main.py /usr/bin/relayctl
sudo chmod +x /usr/bin/relayctl

# start services
sudo docker build /etc/relayctl -t relayctl:1.0.0
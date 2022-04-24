#!/bin/bash

# install deps
sudo apt update
sudo apt upgrade -y
sudo apt install sqlite3 git

pip install fastapi
pip install "uvicorn[standard]"
pip install typer
pip install tabulate
pip install daemonize

# clone files
git clone -b 1.0.0 https://github.com/ReinierNel/relayctl.git /etc/relayctl

# setup db
python /etc/relayctl/db/setup.py
# setup services
sudo cp /etc/relayctl/service/relayctl-api.service /lib/systemd/system/relayctl-api.service
sudo cp /etc/relayctl/service/relayctl-scheduler.service /lib/systemd/system/relayctl-scheduler.service
# setup cli
sudo cp /etc/relayctl/cli/main.py /usr/bin/relayctl
sudo chmod +x /usr/bin/relayctl
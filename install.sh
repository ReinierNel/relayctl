#!/bin/bash

sudo apt update
sudo apt upgrade -y
sudo apt install python3 python3-pip python-setuptools

pip install fastapi
pip install "uvicorn[standard]"
pip install typer
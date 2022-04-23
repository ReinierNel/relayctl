#!/bin/bash

sudo apt update
sudo apt upgrade -y
sudo apt install sqlite3

pip install fastapi
pip install "uvicorn[standard]"
pip install typer
pip install tabulate
pip install daemonize

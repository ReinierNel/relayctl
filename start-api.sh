#!/bin/bash

export RELAYCTL_DB_PATH="./db/relayctl.db"
export RELAYCTL_HTML_PATH="./web"

uvicorn --app-dir=./api main:app --reload --host 0.0.0.0
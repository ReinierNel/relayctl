#!/bin/bash

export RELAYCTL_DB_PATH="/etc/relayctl/db/relayctl.db"
export RELAYCTL_HTML_PATH="/etc/relayctl/web"

uvicorn --app-dir=/etc/relayctl/api main:app --reload --host 0.0.0.0
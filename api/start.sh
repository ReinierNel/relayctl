#!/bin/bash

echo "starting deamon"
python /relayctl/api/scheduler.py
echo "starting api"
uvicorn --app-dir=/relayctl/api main:app --host 0.0.0.0 --port 8000
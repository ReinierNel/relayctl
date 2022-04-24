#!/bin/bash

python /relayctl/api/scheduler.py
uvicorn --app-dir=/relayctl/api main:app --host 0.0.0.0 --port 8000
from time import sleep
from datetime import datetime
import requests
import json
from daemonize import Daemonize

pid = "/tmp/test.pid"

def switches():
    response = requests.get(f"http://127.0.0.1:8000/switches")
    if response.status_code == 200:
        return response.json()
        
def relay_on(id):
    response = requests.get(f"http://127.0.0.1:8000/relays/{id}/on")
    if response.status_code == 200:
        return response.json()

def relay_off(id):
    response = requests.get(f"http://127.0.0.1:8000/relays/{id}/off")
    if response.status_code == 200:
        return response.json()

def schedules():
    response = requests.get(f"http://127.0.0.1:8000/schedules")
    if response.status_code == 200:
        return response.json()

# Main loop of service
def main():
    while True:
        current_time =  datetime.now().hour*60 + datetime.now().minute

        for sw in switches():
            if sw["status"] == sw["action"]:
                relay_on(sw["relay_id"])
            else:
                relay_off(sw["relay_id"])

        for sch in schedules():
            start_time = int(sch["start"].split(":")[0])*60 + int(sch["start"].split(":")[1])
            end_time = int(sch["end"].split(":")[0])*60 + int(sch["end"].split(":")[1])

            if start_time <= current_time and end_time >= current_time:
                if sch["action"] == 1:
                    relay_on(sch["relay_id"])
                else:
                    relay_off(sch["relay_id"])

        # set sleep to debug output with 
        # use ps -aux | grep scheduler.py | grep -v grep | cut -d ' ' -f 9 | xargs strace -e write -p
        # to see output
        sleep(0.2)

# Run daemon
daemon = Daemonize(app="relayctl", pid=pid, action=main)
daemon.start()

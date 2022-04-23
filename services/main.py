from time import sleep
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
        
# Main loop of service
def main():
    while True:
        for sw in switches():
            if sw["status"] == sw["mode"]:
                relay_on(sw["relay_id"])
            else:
                relay_off(sw["relay_id"])

        # set sleep to debug output with 
        # use ps -aux | grep main.py | grep -v grep | cut -d ' ' -f 9 | xargs strace -e write -p
        # to see output
        sleep(0.2)

# Run daemon
daemon = Daemonize(app="relayctl", pid=pid, action=main)
daemon.start()

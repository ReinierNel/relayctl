from typing import Optional
from fastapi import FastAPI
from pydantic import BaseModel
import os

class Relay(BaseModel):
    id: int
    status: bool

class Schedule(BaseModel):
    id: int
    start: str
    end: str
    days: list
    relay_id: int
    status: bool

class Switch(BaseModel):
    id: str
    relay_id: int
    status: bool

app = FastAPI()

# uptime check
@app.get("/uptime")
def read_health():
    return {"uptime": os.popen('uptime -p').read()[:-1]}

# relays
@app.get("/relays")
def read_relays():
    return [
            {"id": 0, "status": True},
            {"id": 1, "status": False},
            {"id": 2, "status": True},
            {"id": 3, "status": True},
            {"id": 4, "status": False},
            {"id": 5, "status": True}
    ]

@app.get("/relays/{relay_id}")
def read_relay(relay_id: int):
    return {"id": relay_id, "status": True}

@app.get("/relays/{relay_id}/on")
def on_relay(relay_id: int):
    return {"id": relay_id, "status": True}

@app.get("/relays/{relay_id}/off")
def off_relay(relay_id: int):
    return {"id": relay_id, "status": False}

# schedules
@app.get("/schedules")
def read_schedules():
    return [
        {
            "id": 0,
            "start": "00:00:00",
            "end": "01:00:00",
            "days": [1, 2, 3, 4, 5, 6, 7],
            "relay_id": 0,
            "status": False
        },
        {
            "id": 1,
            "start": "00:00:00",
            "end": "01:00:00",
            "days": [1, 2, 3, 4, 5, 6, 7],
            "relay_id": 1,
            "status": True
        }
    ]

@app.put("/schedules/add")
def add_schedules(schedule: Schedule):
    return {
        "action": "add",
        "schedule": {
            "id": schedule.id,
            "start": schedule.start,
            "end": schedule.end,
            "days": schedule.days,
            "relay_id": schedule.relay_id,
            "status": schedule.status
        }
    }

@app.delete("/schedules/delete/{id}")
def add_schedules(id: int):
    return {
        "action": "delete",
        "schedule": {
            "id": id
        }
    }

# switches
@app.get("/switches")
def read_schedules():
    return [
        {
            "id": 0,
            "relay_id": 0,
            "status": True
        },
        {
            "id": 1,
            "relay_id": 1,
            "status": False
        }
    ]

@app.put("/switches/add")
def add_schedules(switch: Switch):
    return {
        "action": "add",
        "switch": {
            "id": switch.id,
            "relay_id": switch.relay_id,
            "status": switch.status
        }
    }

@app.delete("/switches/delete/{id}")
def add_schedules(id: int):
    return {
        "action": "delete",
        "switch": {
            "id": id
        }
    }
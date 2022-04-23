import os
import RPi.GPIO as GPIO
import time
import sqlite3
from typing import Optional
from fastapi import FastAPI
from pydantic import BaseModel, Field
from fastapi.responses import HTMLResponse
from pathlib import Path

GPIO.setwarnings(False)
GPIO.setmode(GPIO.BCM)

db_path = os.environ.get("RELAYCTL_DB_PATH")
html_path = os.environ.get("RELAYCTL_HTML_PATH")

def init_gpio(gpio):
    GPIO.setup(init_relay["gpio"], GPIO.OUT)

def fetch_relays():
    connect = sqlite3.connect(db_path)
    cursor = connect.cursor()
    data = []
    for relay_mapping in cursor.execute(''' SELECT id, gpio FROM relays; '''):
        formated = {}
        counter = 0
        for format_relay_mappings in relay_mapping:
            if counter == 0:
                formated["id"] = format_relay_mappings
            if counter == 1:
                formated["gpio"] = format_relay_mappings
            counter = counter + 1
        data.append(formated)
    connect.commit()
    connect.close()
    return data

def fetch_relay(id):
    connect = sqlite3.connect(db_path)
    cursor = connect.cursor()
    sql = ''' SELECT gpio FROM relays WHERE id = ?; '''
    cursor.execute(sql, (str(id),))
    data = cursor.fetchone()[0]
    connect.commit()
    connect.close()
    return data

def add_relay(gpio):
    connect = sqlite3.connect(db_path)
    cursor = connect.cursor()
    sql = ' INSERT into relays (gpio) VALUES (?); '
    cursor.execute(sql, (str(gpio),))
    relay_id = cursor.lastrowid
    connect.commit()
    connect.close()
    GPIO.setup(gpio, GPIO.OUT)
    return relay_id

def delete_relay(id):
    connect = sqlite3.connect(db_path)
    cursor = connect.cursor()
    sql = ''' DELETE FROM relays WHERE id = ?; '''
    cursor.execute(sql, (str(id),))
    connect.commit()
    connect.close()

def fetch_switches():
    connect = sqlite3.connect(db_path)
    cursor = connect.cursor()
    data = []
    for switch_mapping in cursor.execute(''' SELECT id, gpio, relay_id, mode, action FROM switches; '''):
        formated = {}
        counter = 0
        for format_switch_mappings in switch_mapping:
            if counter == 0:
                formated["id"] = format_switch_mappings
            if counter == 1:
                formated["gpio"] = format_switch_mappings
                try:
                    formated["status"] = GPIO.input(format_switch_mappings)
                except:
                    GPIO.setup(format_switch_mappings, GPIO.IN, pull_up_down=GPIO.PUD_DOWN)
                    formated["status"] = GPIO.input(format_switch_mappings)
            if counter == 2:
                formated["relay_id"] = format_switch_mappings
            if counter == 3:
                formated["mode"] = format_switch_mappings
            if counter == 4:
                formated["action"] = format_switch_mappings
            counter = counter + 1
        data.append(formated)
    connect.commit()
    connect.close()
    return data

def fetch_switch(id):
    connect = sqlite3.connect(db_path)
    cursor = connect.cursor()
    sql = ''' SELECT id, gpio, relay_id, mode, action FROM switches WHERE id = ?; '''
    cursor.execute(sql, (str(id),))
    data = cursor.fetchone()
    connect.commit()
    connect.close()
    try:
        GPIO.input(data[1])
    except:
        GPIO.setup(data[1], GPIO.IN, pull_up_down=GPIO.PUD_DOWN)
    return {"id": data[0], "gpio": data[1], "status": GPIO.input(data[1]),"relay_id": data[2], "mode": data[3], "action": data[4]}

def add_switch(data):
    connect = sqlite3.connect(db_path)
    cursor = connect.cursor()
    sql = ''' INSERT into switches (id, gpio, relay_id, mode, action) VALUES (?,?,?,?,?); '''
    cursor.execute(sql, data)
    switch_id = cursor.lastrowid
    connect.commit()
    connect.close()
    return switch_id

def delete_switch(id):
    connect = sqlite3.connect(db_path)
    cursor = connect.cursor()
    sql = ''' DELETE FROM switches WHERE id = ?; '''
    cursor.execute(sql, str(id))
    connect.commit()
    connect.close()

def fetch_schedules():
    connect = sqlite3.connect(db_path)
    cursor = connect.cursor()
    data = []
    for schedules_mapping in cursor.execute(''' SELECT id, relay_id, action, start, end FROM schedules; '''):
        formated = {}
        counter = 0
        for format_schedules_mappings in schedules_mapping:
            if counter == 0:
                formated["id"] = format_schedules_mappings
            if counter == 1:
                formated["relay_id"] = format_schedules_mappings
            if counter == 2:
                formated["action"] = format_schedules_mappings
            if counter == 3:
                formated["start"] = format_schedules_mappings
            if counter == 4:
                formated["end"] = format_schedules_mappings
            counter = counter + 1
        data.append(formated)
    connect.commit()
    connect.close()
    return data

def add_schedule(data):
    connect = sqlite3.connect(db_path)
    cursor = connect.cursor()
    sql = ''' INSERT into schedules (relay_id, action, start, end) VALUES (?,?,?,?); '''
    cursor.execute(sql, data)
    schedule_id = cursor.lastrowid
    connect.commit()
    connect.close()
    return schedule_id

def delete_schedule(id):
    connect = sqlite3.connect(db_path)
    cursor = connect.cursor()
    sql = ''' DELETE FROM schedules WHERE id = ?; '''
    cursor.execute(sql, str(id))
    connect.commit()
    connect.close()

class Relay(BaseModel):
    id: Optional[int]
    gpio: int
    status: Optional[int]

class Switch(BaseModel):
    id: Optional[int]
    gpio: int
    relay_id: int
    mode: int
    action: int
    status: Optional[int]

class Schedule(BaseModel):
    id: Optional[int]
    relay_id: int
    action: int
    start: str
    end: str

# init relays
for init_relay in fetch_relays():
    GPIO.setup(init_relay["gpio"], GPIO.OUT)

# init switches
for init_switches in fetch_switches():
    GPIO.setup(init_switches["gpio"], GPIO.IN, pull_up_down=GPIO.PUD_DOWN)

app = FastAPI()

# relays

@app.get("/relays")
def relays_status():
    output = []
    for relay in fetch_relays():
        output.append({"relay": relay["id"], "gpio": relay["gpio"], "status": GPIO.input(relay["gpio"])})
    return output

@app.post("/relays/add")
def relays_add(relay: Relay):
    gpio_pin = relay.gpio
    new_relay_id = add_relay(gpio_pin)
    return {"id" : new_relay_id, "status": "add"}

@app.delete("/relays/delete/{id}")
def relays_delete(id: int):
    delete_relay(id)
    return {"id" : id, "status": "delete"}

@app.get("/relays/{id}")
def relay_status(id: int):
    return {"id": id, "gpio": fetch_relay(id), "status": GPIO.input(fetch_relay(id))}

@app.get("/relays/{id}/on")
def relay_on(id: int):
    GPIO.output(fetch_relay(id), GPIO.HIGH)
    return {"relay": id, "status": 1}

@app.get("/relays/{id}/off")
def relay_off(id: int):
    GPIO.output(fetch_relay(id), GPIO.LOW)
    return {"relay": id, "status": 0}

# switches
@app.get("/switches")
def switches_status():
    return fetch_switches()

@app.get("/switches/{id}")
def switch_status(id: int):
    return fetch_switch(id)

@app.post("/switches/add")
def switches_add(switch: Switch):
    new_switch_id = add_switch((switch.id, switch.gpio, switch.relay_id, switch.mode, switch.action))
    return {"id" : new_switch_id, "status": "add"}

@app.delete("/switches/delete/{id}")
def switches_delete(id: int):
    delete_switch(id)
    return {"id" : id, "status": "delete"}

# schedules

@app.get("/schedules")
def schedules_status():
    return fetch_schedules()

@app.post("/schedules/add")
def schedule_add(schedule: Schedule):
    new_schedule_id = add_schedule((
        schedule.relay_id,
        schedule.action,
        schedule.start,
        schedule.end
    ))
    return {"id" : new_schedule_id, "status": "add"}

@app.delete("/schedules/delete/{id}")
def schedules_delete(id: int):
    delete_schedule(id)
    return {"id" : id, "status": "delete"}


# web ui
@app.get("/", response_class=HTMLResponse)
async def read_items():
    html = Path(f"{html_path}/index.html").read_text()
    return html
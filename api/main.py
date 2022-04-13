import RPi.GPIO as GPIO
import time
import sqlite3
from typing import Optional
from fastapi import FastAPI
from pydantic import BaseModel, Field

GPIO.setwarnings(False)
GPIO.setmode(GPIO.BCM)

db_path = "../db/relayctl.db"

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
    for switch_mapping in cursor.execute(''' SELECT id, relay_id, mode, action FROM switches; '''):
        formated = {}
        counter = 0
        for format_switch_mappings in switch_mapping:
            if counter == 0:
                formated["id"] = format_switch_mappings
            if counter == 1:
                formated["relay_id"] = format_switch_mappings
            if counter == 2:
                formated["mode"] = format_switch_mappings
            if counter == 3:
                formated["action"] = format_switch_mappings
            counter = counter + 1
        data.append(formated)
    connect.commit()
    connect.close()
    return data

def add_switch(data):
    connect = sqlite3.connect(db_path)
    cursor = connect.cursor()
    sql = ''' INSERT into switches (id, relay_id, mode, action) VALUES (?,?,?,?); '''
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
    for schedules_mapping in cursor.execute(''' SELECT id, relay_id, action, start, end, mon, tue, wed, thu, fri, sat, sun FROM schedules; '''):
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
            if counter == 5:
                formated["mon"] = format_schedules_mappings
            if counter == 6:
                formated["tue"] = format_schedules_mappings
            if counter == 7:
                formated["wed"] = format_schedules_mappings
            if counter == 8:
                formated["thu"] = format_schedules_mappings
            if counter == 9:
                formated["fri"] = format_schedules_mappings
            if counter == 10:
                formated["sat"] = format_schedules_mappings
            if counter == 11:
                formated["sun"] = format_schedules_mappings
            counter = counter + 1
        data.append(formated)
    connect.commit()
    connect.close()
    return data

def add_schedule(data):
    connect = sqlite3.connect(db_path)
    cursor = connect.cursor()
    sql = ''' INSERT into schedules (relay_id, action, start, end, mon, tue, wed, thu, fri, sat, sun) VALUES (?,?,?,?,?,?,?,?,?,?,?); '''
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

class Switch(BaseModel):
    id: Optional[int]
    relay_id: int
    mode: int
    action: int

class Schedule(BaseModel):
    id: Optional[int]
    relay_id: int
    action: int
    start: str
    end: str
    mon: int
    tue: int
    wed: int
    thu: int
    fri: int
    sat: int
    sun: int

# init relays
for init_relay in fetch_relays():
    GPIO.setup(init_relay["gpio"], GPIO.OUT)

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

@app.post("/switches/add")
def switches_add(switch: Switch):
    new_switch_id = add_switch((switch.id, switch.relay_id, switch.mode, switch.action))
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
        schedule.end,
        schedule.mon,
        schedule.tue,
        schedule.wed,
        schedule.thu,
        schedule.fri,
        schedule.sat,
        schedule.sun
    ))
    return {"id" : new_schedule_id, "status": "add"}

@app.delete("/schedules/delete/{id}")
def schedules_delete(id: int):
    delete_schedule(id)
    return {"id" : id, "status": "delete"}

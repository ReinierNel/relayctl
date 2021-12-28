#!/bin.bash
# set the GPIO PIN that each relay is connected to
# Note that pisition 1 = relay 0 and so on
relays=(22 23)
# where where is all the scripts located
wokring_dir="/home/pi"
# where is your scedule file located
schedule_file_path="/home/pi/schedule.list"
# where sould the logs be stored defaults to working directory
log_file_path="/home/pi/relayctl.log"
# scheduler frequency
scheduler_frequency="10"

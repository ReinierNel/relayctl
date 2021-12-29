#!/bin.bash
# set the GPIO PIN that each relay is connected to
# Note that pisition 1 = relay 0 and so on
relays=(__GPIO_PIN__)
# where where is all the scripts located
wokring_dir="/etc/relayctl"
# where is your scedule file located
schedule_file_path="/etc/relayctl/schedule.list"
# where sould the logs be stored defaults to working directory
log_file_path="/etc/relayctl/relayctl.log"
# scheduler frequency
scheduler_frequency="__SCHEDULAR_FREQUEMCY__"

#!/bin/bash
# set the GPIO PIN that each relay is connected to
# Note that pisition 1 = relay 0 and so on
relays=(__OUT_GPIO_PIN__)
# external inputs GPIO PINS
inputs_gpio=(__IN_GPIO_PIN__)
# where where is all the scripts located
wokring_dir="/etc/relayctl"
# where is your scedule file located
schedule_file_path="/etc/relayctl/schedule.list"
# where sould the logs be stored defaults to working directory
log_file_path="/etc/relayctl/relayctl.log"
# scheduler frequency
scheduler_frequency="10"
# external input map file
external_input_file="/etc/relayctl/inputs.list"
# enable or disable logging
logging="enable"
# set where to log to by default
log_where="file"
# should date, error level and other metada show in the logs
logging_metadata="disabled"

#!/bin/bash

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" &> /dev/null && pwd)

# setup share variables
source "$SCRIPT_DIR"/settings.sh

# setup shared functions
source "$SCRIPT_DIR"/functions.sh

log_file="$log_file_path"

# inti logfile
create_file "$log_file"
log "$log_where" i "{ \"script\": \"$0\", \"executied_by\": \"$(whoami)\" }" "$log_file"

# init gpio
function init_gpio() {
        if [ ! -d "/sys/class/gpio/gpio$1" ]
        then
                echo "$1" > /sys/class/gpio/export
                echo "in" > /sys/class/gpio/gpio"$1"/direction
		echo "0" > /sys/class/gpio/gpio"$1"/active_low
        fi
}

function read_gpio_value() {
	cat /sys/class/gpio/gpio"$1"/value
}

# read input map file
function load_inputs() {
        while read inputs
        do
                if [[ "$inputs" != "#"* ]]
                then
                    name=$(cut -d '|' -f 1 <<< "$inputs")
					input_index=$(cut -d '|' -f 2 <<< "$inputs")
					relay_index=$(cut -d '|' -f 3 <<< "$inputs")
					mode=$(cut -d '|' -f 4 <<< "$inputs")

					init_gpio "${inputs_gpio[$input_index]}"
					gpio_pin_value=$(read_gpio_value "${inputs_gpio[$input_index]}")

					case "$mode" in
									on)
							if [ "$gpio_pin_value" = "1" ]
							then
								log "$log_where" i "{ \"script\": \"$0\", \"function\": \"load_inputs()\",\"input_index\":\"$input_index\", \"relay_index\": \"$relay_index\", \"mode\": \"on\" }" "$log_file"
								"$wokring_dir"/relayctl.sh -r="$relay_index" on
							else
								"$wokring_dir"/relayctl.sh -r="$relay_index" off
							fi
									;;
									off)
							if [ "$gpio_pin_value" = "0" ]
							then
								log "$log_where" i "{ \"script\": \"$0\", \"function\": \"load_inputs()\",\"input_index\":\"$input_index\", \"relay_index\": \"$relay_index\", \"mode\": \"off\" }" "$log_file"
														"$wokring_dir"/relayctl.sh -r="$relay_index" on
												else
														"$wokring_dir"/relayctl.sh -r="$relay_index" off
												fi
									;;
									cmd)
											cmd=$(cut -d '|' -f 5 <<< "$inputs")
							if [ "$gpio_pin_value" = "1" ]
												then
								log "$log_where" i "{ \"script\": \"$0\", \"function\": \"load_inputs()\",\"input_index\":\"$input_index\", \"relay_index\": \"$relay_index\", \"mode\": \"cmd\" }" "$log_file"
								evel "$cmd"
												fi
									;;
                	esac

                fi
        done < "$1"
}

# main function
function main() {
	while true
	do
		load_inputs "$1"
		sleep "$external_input_frequency"
	done
}

# run
main "$external_input_file"

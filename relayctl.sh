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

# handel script arguments
for arg in "$@"
do

        if [[ "$*" == *"test"* ]]
        then
                run_tests=true
                break 1
        else
                case "$arg" in
                        --relay=*|-r=*)
                                relay_index="${arg#*=}"
                        ;;
                        on)
                                action="on"
                        ;;
                        off)
                                action="off"
                        ;;
                        status)
                                check_status=true
                        ;;
                esac
        fi
done

# validate script arguments
if [ -z "$run_tests" ] && [ -z "$check_status" ]
then
        mandatory_args=("relay_index" "action")
        for arg_to_check in "${mandatory_args[@]}"
        do
                if [ -z "${!arg_to_check}" ]
                then
                        case "$arg_to_check" in
                                relay_index)
                                        log "all" e "{ \"script\": \"$0\", \"validation\": \"argument --relay= missing\" }" "$log_file"
                                ;;
                                action)
                                        log "all" e "{ \"script\": \"$0\", \"validation\": \"no action set use 'on' or 'off'\" }" "$log_file"
                                ;;
                        esac
                        log screen h "{ \"usage\": \"$0 --relay=0 on\" }"
                        exit 1
                fi
        done
fi

# setup gpio pins
function init_gpio() {
        if [ ! -d "/sys/class/gpio/gpio$1" ]
        then
                log file i "[ init_gpio() ] initializing gpio pin $1" "$log_file"
                log "$log_where" i "{ \"script\": \"$0\", \"function\": \"init_gpio()\", \"gpio\": \"$1\", \"state\": \"exported\" }" "$log_file"
                echo "$1" > /sys/class/gpio/export
                echo "out" > /sys/class/gpio/gpio"$1"/direction
        fi
}

# unset gpio pins
function remove_gpio() {
        log "$log_where" i "{ \"script\": \"$0\", \"function\": \"remove_gpio()\", \"gpio\": \"$1\", \"state\": \"unexported\" }" "$log_file"
        echo "$1" > /sys/class/gpio/unexport
}

# set gpio pin to high or low
function relay_ctl() {
        if [ "$2" = "on" ]
        then
                log "all" i "{ \"script\": \"$0\", \"function\": \"relay_ctl()\", \"gpio\": \"$1\", \"state\": \"high\" }" "$log_file"
                echo "1" > /sys/class/gpio/gpio"$1"/value
        fi

        if [ "$2" = "off" ]
        then
                log "all" i "{ \"script\": \"$0\", \"function\": \"relay_ctl()\", \"gpio\": \"$1\", \"state\": \"low\" }" "$log_file"
                echo "0" > /sys/class/gpio/gpio"$1"/value
        fi
}

# test relays one by one
function relay_test() {
        log "all" w "{ \"script\": \"$0\", \"function\": \"relay_test()\", \"state\"=\"start\" }" "$log_file"
        for relay in "${!relays[@]}"
        do
                init_gpio "${relays[$relay]}"
                relay_ctl "${relays[$relay]}" "on"
                sleep 0.5
                relay_ctl "${relays[$relay]}" "off"
                sleep 0.5
                remove_gpio "${relays[$relay]}"
        done
        log "all" w "{ \"script\": \"$0\", \"function\": \"relay_test()\", \"state\"=\"end\" }" "$log_file"

}

# check of gpio pin
function check_gpio() {

        if [ -d "/sys/class/gpio/gpio$1" ]
        then
                status=$(</sys/class/gpio/gpio"$1"/value)

                if [ "$status" = "1" ]
                then
                        log "all" i "{ \"script\": \"$0\", \"function\": \"check_gpio()\", \"gpio\": \"$1\", \"state\": \"high\" }" "$log_file"
                else
                        log "all" i "{ \"script\": \"$0\", \"function\": \"check_gpio()\", \"gpio\": \"$1\", \"state\": \"low\" }" "$log_file"
                fi
        else
                log "all" w "{ \"script\": \"$0\", \"function\": \"check_gpio()\", \"gpio\": \"$1\", \"state\": \"unexported\" }" "$log_file"
        fi
}

# main logic
function main() {
        init_gpio "${relays[$relay_index]}"
        relay_ctl "${relays[$relay_index]}" "$action"
}

# run test, status checks or main logic
if [ -n "$run_tests" ]
then
        relay_test
elif [ -n "$check_status" ]
then
        check_gpio "${relays[$relay_index]}"
else
        main
fi

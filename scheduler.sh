#!/bin/bash

# runs as background process checkes times agains a schedule and executes scripts almost like cron

SCRIPT_DIR=$(cd $(dirname "${BASH_SOURCE[0]}") &> /dev/null && pwd)

# setup share variables
. "$SCRIPT_DIR"/settings.sh

# setup shared functions
. "$SCRIPT_DIR"/functions.sh

schedule_file="$schedule_file_path"
frequency="$scheduler_frequency"
log_file="$log_file_path"

# inti logfile
create_file "$log_file"
log file i "$0 executied by $(whoami)" "$log_file"

# main function
function schedule() {
        while read schedule
        do
                time_now=$(date +'%H:%M:%S')
                epoch_time_now=$(date -d "$time_now" +'%s')
                day_of_week=$(date +'%u')
                month_of_year=$(date +'%m')
                if [[ "$schedule" != "#"* ]]
                then
                        name=$(cut -d '|' -f 1 <<< "$schedule")
                        start_time=$(cut -d '|' -f 2 <<< "$schedule")
                        start_epoch_time=$(date -d "$start_time" +'%s')
                        end_time=$(cut -d '|' -f 3 <<< "$schedule")
                        end_epoch_time=$(date -d "$end_time" +'%s')
                        days=($(cut -d '|' -f 4 <<< "$schedule"))
                        months=($(cut -d '|' -f 5 <<< "$schedule"))
                        relay_index=$(cut -d '|' -f 6 <<< "$schedule")
                        on_cmd=$(cut -d '|' -f 7 <<< "$schedule")
                        off_cmd=$(cut -d '|' -f 8 <<< "$schedule")

                        # month
                        for month in "${months[@]}"
                        do
                                if [[ "$month" == "$month_of_year" ]]
                                then
                                        # week day
                                        for day in "${days[@]}"
                                        do
                                                if [[ "$day" == "$day_of_week" ]]
                                                then
                                                        # Hourly
                                                        if  [ "$start_epoch_time" -gt "$epoch_time_now" ] || [  "$epoch_time_now" -gt "$end_epoch_time" ]
                                                        then
                                                                log file i "[ $0 ] $name off" "$log_file"
                                                                eval "$off_cmd"
                                                        else
                                                                log file i "[ $0 ] $name on" "$log_file"
                                                                eval "$on_cmd"
                                                        fi
                                                fi
                                        done
                                fi
                        done
                fi
        done < "$1"
}

# main function
function main() {
        while true
        do
                schedule "$1"
                sleep "$2"
        done
}

# run main function
main "$schedule_file" "$frequency"

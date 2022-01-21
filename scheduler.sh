#!/bin/bash

# runs as background process checkes times agains a schedule and executes scripts almost like cron

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" &> /dev/null && pwd)

# setup share variables
source "${SCRIPT_DIR}"/settings.sh

# setup shared functions
source "$SCRIPT_DIR"/functions.sh

schedule_file="$schedule_file_path"
frequency="$scheduler_frequency"
log_file="$log_file_path"

# inti logfile
create_file "$log_file"
log "$log_where" i "{ \"script\": \"$0\", \"executied_by\": \"$(whoami)\" }" "$log_file"

# main function
function schedule() {
        while read -r schedule
        do
                epoch_time_now=$(date -d "$(date +'%Y-%m-%d %H:%M:%S')" +'%s')
                day_of_week=$(date +'%u')
                if [[ "$schedule" != "#"* ]]
                then
                        name=$(cut -d '|' -f 1 <<< "$schedule")
                        start_time=$(cut -d '|' -f 2 <<< "$schedule")
                        start_epoch_time=$(date -d "$(date +'%Y-%m-%d') $start_time" +'%s')
                        end_time=$(cut -d '|' -f 3 <<< "$schedule")
                        end_epoch_time=$(date -d "$(date +'%Y-%m-%d') $end_time" +'%s')
                        string_2_array "$(cut -d '|' -f 4 <<< "$schedule")" " "
			days=("${s2a_output[@]}")
                        relay_index=$(cut -d '|' -f 5 <<< "$schedule")
			action=$(cut -d '|' -f 6 <<< "$schedule")

                        # week day
                        for day in "${days[@]}"
                        do
                                if [[ "$day" == "$day_of_week" ]]
                                then
                                        # Hourly
                                        if  [ "$epoch_time_now" -gt "$start_epoch_time" ] && [  "$epoch_time_now" -lt "$end_epoch_time" ]
                                        then
                                                log "$log_where" i "{ \"script\": \"$0\", \"function\": \"schedule()\", \"schedule_name\": \"$name\", \"action\": \"$action\" }" "$log_file"
                                                eval "$wokring_dir/relayctl.sh -r=$relay_index $action"
                                        fi
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

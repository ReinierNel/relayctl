#!/bin/bash

# logging function
function log() {
        declare -A level=(
                [i]="{ \"date\": \"$(date)\", \"level\": \"info\","
                [w]="{ \"date\": \"$(date)\", \"level\": \"warning\","
                [e]="{ \"date\": \"$(date)\", \"level\": \"error\","
                [d]="{ \"date\": \"$(date)\", \"level\": \"debug\","
                [h]="{ \"date\": \"$(date)\", \"level\": \"hint\","
        )
        if [ "$logging" = "enable" ]
        then
                if [ "$logging_metadata" = "enable" ]
                then
                        log_msg="${level[$2]} \"message\": $3}"
                else
                        log_msg="$3"
                fi

                if [ "$logging_per_users" = "enabled" ]
                then
                        file_name="$4/$(whoami)_relayctl.log"
                else
                        file_name="$4/relayctl.log"
                fi

                case "$1" in
                        screen)
                                echo "$log_msg"
                        ;;
                        file)
                                echo "$log_msg" >> "$file_name"
                        ;;
                        *)
                                echo "$log_msg" | tee -a "$file_name"
                esac
        fi
}

function create_file() {
        if [ ! -e "$1" ] ; then
            touch "$1"
        fi
}

function string_2_array() {
        mapfile -t -d "$2" array <<< "$1"
        s2a_output=()
        for i in "${array[@]}"
        do
                s2a_output+=("$( echo "$i" | tr --delete '\n')")

        done
}


# must redeclare array as input array-2-json "$(declare -p some_array)"
function array-2-json() {

        declare -A input_array=${1#*=}
        json_string="{"
        loop_counter=0
        array_counter="${#input_array[@]}"

        for element in "${!input_array[@]}"
        do
                ((loop_counter="$loop_counter" + 1))
                if [ "$loop_counter" = "$array_counter" ]
                then
                        json_string+="\"$element\":\"${input_array[$element]}\""
                else
                        json_string+="\"$element\":\"${input_array[$element]}\","
                fi
        done

        json_string+="}"

        echo "$json_string"
}

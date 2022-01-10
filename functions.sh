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
                case "$1" in
                        screen)
                                echo "${level[$2]} \"message\": $3}"
                        ;;
                        file)
                                echo "${level[$2]} \"message\": $3}" >> "$4"
                        ;;
                        *)
                                echo "${level[$2]} \"message\": $3}" | tee -a "$4"
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

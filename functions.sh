#!/bin/bash

# logging function
function log() {
        declare -A level=(
                [i]="[ $(date) ] [ info ]"
                [w]="[ $(date) ] [ warn ]"
                [e]="[ $(date) ] [ error ]"
                [d]="[ $(date) ] [ debug ]"
                [h]="[ $(date) ] [ hint ]"
        )

        case "$1" in
                screen)
                        echo "${level[$2]} $3"
                ;;
                file)
                        echo "${level[$2]} $3" >> "$4"
                ;;
                *)
                        echo "${level[$2]} $3" | tee -a "$4"
        esac
}

function create_file() {
        if [ ! -e "$1" ] ; then
            touch "$1"
        fi
}

function file_2_array() {

        if [ ! -e "$1" ] ; then
            log screen e "File $1 does exist ending scripts!"
            exit 1
        fi

        declare -a array_file=()

        while read line_from_file
        do
                array_file+=("$line_from_file")
        done < "$1"

        eval file_2_array_results=("${array_file[@]}")
}

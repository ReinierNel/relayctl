#!/bin/bash

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" &> /dev/null && pwd)

# setup share variables
source "$SCRIPT_DIR"/settings.sh

# setup shared functions
source "$SCRIPT_DIR"/functions.sh

if ! [ -d "$temp_dir" ]
then
    mkdir "$temp_dir"
    chmod 777 "$temp_dir"
fi


while true
do
    if test -f "$temp_dir/relay.action"
    then
        action=$(<"$temp_dir"/relay.action)

        if ! [ "$action" = "" ]
        then
            relay_index=$(echo "$action" | cut -d "," -f 1)
            relay_action=$(echo "$action" | cut -d "," -f 2)
            bash "$SCRIPT_DIR"/relayctl.sh -r="$relay_index" "$relay_action"
            rm -f "$temp_dir"/relay.action
        fi
    fi
done
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
        case "$arg" in
                --reset)
                        reset="true"
                ;;
                --check-key=*)
                        check_key="${arg#*=}"
                ;;
                *)
                        no_args="true"
        esac
done

if [ "$no_args" = "true" ]
then
        log "$all" e "{ \"error\": \"invalid arguments set\", \"hint\": \"$0 --reset or $0 --check-key=[API KEY TO CHECK]\" }" "$log_file"
        exit 1
fi

if [ "$reset" = "true" ] && [ -z "$check_key" ]
then
	log "$log_where" w "{ \"date\": \"${date}\", \"api-key\": \"reset\", \"by\": \"$(whoami)\" }" "$log_file"
	api_key=$(hexdump -n 16 -e '4/4 "%08X" 1 "\n"' /dev/urandom)
	openssl passwd -6 -salt $(tr -dc A-Za-z0-9 </dev/urandom | head -c 13 ; echo '') -stdin -noverify <<< $(echo $api_key) > /etc/relayctl/api.key
	echo "{\"api-key\": \"$api_key\"}"
	exit 0
fi

if [ -z "$reset" ] && [ -n "$check_key" ]
then
	hash=$(</etc/relayctl/api.key)
        algorithm=$(echo $hash | cut -d '$' -f 2)
        salt=$(echo $hash | cut -d '$' -f 3)

        key_received=$(openssl passwd -$algorithm -salt $salt -stdin -noverify <<< $(echo "$check_key" ))

	if [ "$key_received" = "$hash" ]
        then
                log "screen" i "{ \"api-key\": \"true\" }"
		exit 0
        else
		log "screen" w "{ \"api-key\": \"false\" }"
                exit 1
        fi
fi

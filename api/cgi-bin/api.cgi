#!/bin/bash

response_json="{"

declare -A status_code=(
        [200]="200 OK"
        [201]="201 Created"
        [202]="202 Accepted"
        [400]="400 Bad Request"
        [401]="401 Unauthorized"
        [403]="403 Forbidden"
        [404]="404 Not Found"
        [405]="405 Method Not Allowed"
        [422]="422 Unprocessable Entity"
)

function content {
        declare -a headers=(
                "Content-Type: application/json"
                "Status: $1"
        )

        for header in "${headers[@]}"
        do
                printf "$header \n"
        done

        printf "\n $2"
}

function validate() {

        case $1 in
                int)
                        regex='^[0-9]+$'
                ;;
                no_special)
                        regex='^[a-zA-Z0-9]+$'
                ;;
                time)
                        regex='^[0-2]+[0-9]+\:+[0-2]+[0-9]+\:+[0-5]+[0-9]+$'
                ;;
                days)
                        regex='^[1-7]+\s.+$'
                ;;
                json)
                        if jq -e . >/dev/null 2>&1 <<< "$2"
                        then
                                regex='^.*'
                        else
                                regex='\/'
                        fi
                ;;
        esac


        if [[ "$2" =~  $regex ]]
        then
                validation='true'
                return 0
        else
                validation='false'
                return 1
        fi
}


function request() {

        case "$REQUEST_METHOD" in
                GET)
                        status="${status_code[200]}"
                        response_json+="\"status\": \"200 OK\","
                        response_json+="$1"
                ;;
                POST|DELETE)
                        if [ "$CONTENT_LENGTH" -gt 0 ]
                        then
                                data_in="$(cat)"

                                if validate "json" "$data_in"
                                then
                                        status="${status_code[200]}"
                                        response_json+="\"status\": \"200 OK\","
                                        response_json+="$1"
                                else
                                        status="${status_code[400]}"
                                        response_json+="\"status\": \"400 Bad Request\", \"hint\": \"invlid json sent\""
                                fi
                        else
                                status="${status_code[400]}"
                                response_json+="\"status\": \"400 Bad Request\""
                        fi
                ;;
                *)
                        status="${status_code[405]}"
                        response_json+="\"status\": \"405 Method Not Allowed\""
                ;;
        esac
}

function auth() {
        if [ -n "$HTTP_APIKEY" ]
        then
                hash=$(</etc/relayctl/api.key)
                algorithm=$(echo $hash | cut -d '$' -f 2)
                salt=$(echo $hash | cut -d '$' -f 3)

                key_received=$(openssl passwd -$algorithm -salt $salt -stdin -noverify <<< $(echo $HTTP_AUTHORIZATION))

                if [ "$key_received" = "$hash" ]
                then
                        no_auth="false"
                else
                        status="${status_code[403]}"
                        response_json+="\"status\": \"403 Forbidden\""
                        no_auth="true"
                fi
        else
                status="${status_code[403]}"
                response_json+="\"status\": \"403 Forbidden\""
                no_auth="true"
        fi
}

function router() {
        if [ "$QUERY_STRING" = "" ]
        then
                status="${status_code[400]}"
                response_json+="\"status\": \"400 Bad Request\""
        else
                path=$(echo -n "$QUERY_STRING" | cut -d '/' -f 1)
                slug=$(echo -n "$QUERY_STRING" | cut -d '/' -f 2)
                action=$(echo -n "$QUERY_STRING" | cut -d '/' -f 3)

                case "$path" in
                        relays)
                                if [ "$slug" = "" ]
                                then
                                        gpio_in_use=""
                                        source /etc/relayctl/settings.sh
                                        for pins in "${!relays[@]}"
                                        do
                                                relays_output=$(/etc/relayctl/relayctl.sh -r="$pins" status)
                                                gpio_in_use+="\"r$pins\": $relays_output,"
                                        done

                                        gpio_in_use=$(echo "$gpio_in_use" | sed 's/\(.*\),/\1 /')
                                        request "$gpio_in_use"

                                elif validate int "$slug"
                                then
                                        if [ "$action" = "on" ] || [ "$action" = "off" ] || [ "$action" = "status" ]
                                        then
                                                relays_output=$(/etc/relayctl/relayctl.sh -r="$slug" "$action")
                                                request "\"r$slug\": $relays_output"
                                        else
                                                status="${status_code[400]}"
                                                response_json+="\"status\": \"400 Bad Request\""
                                        fi
                                else
                                        status="${status_code[400]}"
                                        response_json+="\"status\": \"400 Bad Request\""
                                fi
                        ;;
                        schedules)
                                case "$slug" in
                                        add)
                                                if [ "$REQUEST_METHOD" = "POST" ]
                                                then
                                                        request "\"schedule\": \"added\","

							if [ $(echo "$data_in" | jq empty > /dev/null 2>&1; echo "$?") -eq 0 ]
							then
	                                                        name=$(echo "$data_in" | jq -r ."name")
	                                                        start_time=$(echo "$data_in" | jq -r ."start_time")
	                                                        end_time=$(echo "$data_in" | jq -r ."end_time")
	                                                        days=$(echo "$data_in" | jq -r ."days")
	                                                        relay_index=$(echo "$data_in" | jq -r ."relay_index")
	                                                        action=$(echo "$data_in" | jq -r ."action")

                                                                if ! validate 'no_special' "$name" 
                                                                then
                                                                        status="${status_code[400]}"
                                                                        response_json="{\"status\": \"400 Bad Request\", \"hint\": \"name alphanumeric characters only\""
                                                                fi

                                                                if ! validate 'time' "$start_time" 
                                                                then
                                                                        status="${status_code[400]}"
                                                                        response_json="{\"status\": \"400 Bad Request\", \"hint\": \"start time malformed\""
                                                                fi

                                                                if ! validate 'time' "$end_time" 
                                                                then
                                                                        status="${status_code[400]}"
                                                                        response_json="{\"status\": \"400 Bad Request\", \"hint\": \"end time malformed\""
                                                                fi

                                                                if ! validate 'days' "$days" 
                                                                then
                                                                        status="${status_code[400]}"
                                                                        response_json="{\"status\": \"400 Bad Request\", \"hint\": \"days malformed\""
                                                                fi

                                                                if ! validate 'int' "$relay_index" 
                                                                then
                                                                        status="${status_code[400]}"
                                                                        response_json="{\"status\": \"400 Bad Request\", \"hint\": \"relay_index can only be a int\""
                                                                fi

                                                                if ! validate 'no_special' "$action" 
                                                                then
                                                                        status="${status_code[400]}"
                                                                        response_json="{\"status\": \"400 Bad Request\", \"hint\": \"action alphanumeric characters only\""
                                                                fi

	                                                        if grep "$name|" /etc/relayctl/schedule.list
	                                                        then
	                                                                status="${status_code[422]}"
	                                                                response_json="{\"status\": \"422 Unprocessable Entity\", \"hint\": \"name already exist please use a unique name\""
	                                                        else
                                                                        if [ "$validation" = "true" ]
                                                                        then
                                                                                echo "$name|$start_time|$end_time|$days|$relay_index|$action" >> /etc/relayctl/schedule.list
                                                                                response_json+="\"name\": \"$name\","
                                                                                response_json+="\"start_time\": \"$start_time\","
                                                                                response_json+="\"end_time\": \"$end_time\","
                                                                                response_json+="\"days\": \"$days\","
                                                                                response_json+="\"relay_index\": \"$relay_index\","
                                                                                response_json+="\"action\": \"$action\""
                                                                        fi
	                                                        fi
							else
								status="${status_code[422]}"
                                                                response_json="{\"status\": \"422 Unprocessable Entity\", \"hint\": \"malformed json received\""
							fi

                                                else
                                                        status="${status_code[405]}"
                                                        response_json+="\"status\": \"405 Method Not Allowed\""
                                                fi
                                        ;;
                                        delete)
                                                if [ "$REQUEST_METHOD" = "DELETE" ]
                                                then
                                                        request "\"schedule\": \"deleted\","

							if [ $(echo "$data_in" | jq empty > /dev/null 2>&1; echo "$?") -eq 0 ]
                                                        then

	                                                        name=$(echo "$data_in" | jq -r ."name")
	                                                        start_time=$(echo "$data_in" | jq -r ."start_time")
	                                                        end_time=$(echo "$data_in" | jq -r ."end_time")
	                                                        days=$(echo "$data_in" | jq -r ."days")
	                                                        relay_index=$(echo "$data_in" | jq -r ."relay_index")
	                                                        action=$(echo "$data_in" | jq -r ."action")

                                                                if ! validate 'no_special' "$name" 
                                                                then
                                                                        status="${status_code[400]}"
                                                                        response_json="{\"status\": \"400 Bad Request\", \"hint\": \"name alphanumeric characters only\""
                                                                fi

                                                                if ! validate 'time' "$start_time" 
                                                                then
                                                                        status="${status_code[400]}"
                                                                        response_json="{\"status\": \"400 Bad Request\", \"hint\": \"start time malformed\""
                                                                fi

                                                                if ! validate 'time' "$end_time" 
                                                                then
                                                                        status="${status_code[400]}"
                                                                        response_json="{\"status\": \"400 Bad Request\", \"hint\": \"end time malformed\""
                                                                fi

                                                                if ! validate 'days' "$days" 
                                                                then
                                                                        status="${status_code[400]}"
                                                                        response_json="{\"status\": \"400 Bad Request\", \"hint\": \"days malformed\""
                                                                fi

                                                                if ! validate 'int' "$relay_index" 
                                                                then
                                                                        status="${status_code[400]}"
                                                                        response_json="{\"status\": \"400 Bad Request\", \"hint\": \"relay_index can only be a int\""
                                                                fi

                                                                if ! validate 'no_special' "$action" 
                                                                then
                                                                        status="${status_code[400]}"
                                                                        response_json="{\"status\": \"400 Bad Request\", \"hint\": \"action alphanumeric characters only\""
                                                                fi

	                                                        if grep "$name|$start_time|$end_time|$days|$relay_index|$action" /etc/relayctl/schedule.list
	                                                        then
                                                                        if [ "$validation" = "true" ]
                                                                        then
                                                                                grep -v "$name|$start_time|$end_time|$days|$relay_index|$action" /etc/relayctl/schedule.list > /tmp/schedule.list.temp
                                                                                mv /tmp/schedule.list.temp /etc/relayctl/schedule.list
                                                                                rm -f /tmp/schedule.list.temp

                                                                                response_json+="\"name\": \"$name\","
                                                                                response_json+="\"start_time\": \"$start_time\","
                                                                                response_json+="\"end_time\": \"$end_time\","
                                                                                response_json+="\"days\": \"$days\","
                                                                                response_json+="\"relay_index\": \"$relay_index\","
                                                                                response_json+="\"action\": \"$action\""
                                                                        else
                                                                                status="${status_code[400]}"
                                                                                response_json="{\"status\": \"400 Bad Request\", \"hint\": \"validation failed\""
                                                                        fi
	                                                        else
	                                                                status="${status_code[422]}"
	                                                                response_json="{\"status\": \"422 Unprocessable Entity\", \"hint\": \"scedule does not exist\""
	                                                        fi
							else
								status="${status_code[422]}"
                                                                response_json="{\"status\": \"422 Unprocessable Entity\", \"hint\": \"malformed json received\""
							fi
                                                else
                                                        status="${status_code[405]}"
                                                        response_json+="\"status\": \"405 Method Not Allowed\""
                                                fi
                                        ;;
                                        *)
                                                schedule_list=""
                                                while read -r schedule
                                                do
                                                        if [[ "$schedule" != "#"* ]]
                                                        then
                                                                name=$(cut -d '|' -f 1 <<< "$schedule")
                                                                start_time=$(cut -d '|' -f 2 <<< "$schedule")
                                                                end_time=$(cut -d '|' -f 3 <<< "$schedule")
                                                                days=$(cut -d '|' -f 4 <<< "$schedule")
                                                                relay_index=$(cut -d '|' -f 5 <<< "$schedule")
                                                                action=$(cut -d '|' -f 6 <<< "$schedule")

                                                                schedule_list+="\"$name\": {\"name\": \"$name\", \"start_time\": \"$start_time\", \"end_time\": \"$end_time\", \"days\": \"$days\", \"relay\": \"$relay_index\", \"action\": \"$action\"},"
                                                        fi
                                                done < "/etc/relayctl/schedule.list"

                                                schedule_list=$(echo "$schedule_list" | sed 's/\(.*\),/\1 /')
                                                request "$schedule_list"
                                        ;;
                                        esac
                        ;;
                        switches)
                                case "$slug" in
                                        add)
                                                if [ "$REQUEST_METHOD" = "POST" ]
                                                then
                                                        request "\"switches\": \"added\","

							if [ $(echo "$data_in" | jq empty > /dev/null 2>&1; echo "$?") -eq 0 ]
                                                        then

	                                                        name=$(echo "$data_in" | jq -r ."name")
	                                                        input_index=$(echo "$data_in" | jq -r ."input_index")
	                                                        relay_index=$(echo "$data_in" | jq -r ."relay_index")
	                                                        mode=$(echo "$data_in" | jq -r ."mode")
	                                                        cmd="#null"

                                                                if ! validate 'no_special' "$name" 
                                                                then
                                                                        status="${status_code[400]}"
                                                                        response_json="{\"status\": \"400 Bad Request\", \"hint\": \"name alphanumeric characters only\""
                                                                fi

                                                                if ! validate 'int' "$input_index" 
                                                                then
                                                                        status="${status_code[400]}"
                                                                        response_json="{\"status\": \"400 Bad Request\", \"hint\": \"input_index can only be a int\""
                                                                fi

                                                                if ! validate 'int' "$relay_index" 
                                                                then
                                                                        status="${status_code[400]}"
                                                                        response_json="{\"status\": \"400 Bad Request\", \"hint\": \"relay_index can only be a int\""
                                                                fi

                                                                if ! validate 'no_special' "$mode" 
                                                                then
                                                                        status="${status_code[400]}"
                                                                        response_json="{\"status\": \"400 Bad Request\", \"hint\": \"mode lphanumeric characters only\""
                                                                fi


	                                                        if grep "$name|" /etc/relayctl/inputs.list
	                                                        then
	                                                                status="${status_code[422]}"
	                                                                response_json="{\"status\": \"422 Unprocessable Entity\", \"hint\": \"name already exist please use a unique name\""
	                                                        else
                                                                        if [ "$validation" = "true" ]
                                                                        then
                                                                                echo "$name|$input_index|$relay_index|$mode|$cmd" >> /etc/relayctl/inputs.list
                                                                                response_json+="\"name\": \"$name\","
                                                                                response_json+="\"input_index\": \"$input_index\","
                                                                                response_json+="\"relay_index\": \"$relay_index\","
                                                                                response_json+="\"mode\": \"$mode\""
                                                                        else
                                                                                status="${status_code[400]}"
                                                                                response_json="{\"status\": \"400 Bad Request\", \"hint\": \"validation failed\""
                                                                        fi
	                                                        fi
							else
								status="${status_code[422]}"
                                                                response_json="{\"status\": \"422 Unprocessable Entity\", \"hint\": \"malformed json received\""
							fi
                                                else
                                                        status="${status_code[405]}"
                                                        response_json+="\"status\": \"405 Method Not Allowed\""
                                                fi
                                        ;;
                                        delete)
                                                if [ "$REQUEST_METHOD" = "DELETE" ]
                                                then
                                                        request "\"switches\": \"deleted\","

							if [ $(echo "$data_in" | jq empty > /dev/null 2>&1; echo "$?") -eq 0 ] && [ "${#data_in}" -gt 0 ]
                                                        then

	                                                        name=$(echo "$data_in" | jq -r ."name")
	                                                        input_index=$(echo "$data_in" | jq -r ."input_index")
	                                                        relay_index=$(echo "$data_in" | jq -r ."relay_index")
	                                                        mode=$(echo "$data_in" | jq -r ."mode")
	                                                        cmd="#null"

                                                                if ! validate 'no_special' "$name" 
                                                                then
                                                                        status="${status_code[400]}"
                                                                        response_json="{\"status\": \"400 Bad Request\", \"hint\": \"name alphanumeric characters only\""
                                                                fi

                                                                if ! validate 'int' "$input_index" 
                                                                then
                                                                        status="${status_code[400]}"
                                                                        response_json="{\"status\": \"400 Bad Request\", \"hint\": \"input_index can only be a int\""
                                                                fi

                                                                if ! validate 'int' "$relay_index" 
                                                                then
                                                                        status="${status_code[400]}"
                                                                        response_json="{\"status\": \"400 Bad Request\", \"hint\": \"relay_index can only be a int\""
                                                                fi

                                                                if ! validate 'no_special' "$mode" 
                                                                then
                                                                        status="${status_code[400]}"
                                                                        response_json="{\"status\": \"400 Bad Request\", \"hint\": \"mode lphanumeric characters only\""
                                                                fi

	                                                        if grep "$name|$input_index|$relay_index|$mode|$cmd" /etc/relayctl/inputs.list
	                                                        then
                                                                        if [ "$validation" = "true" ]
                                                                        then
                                                                                grep -v "$name|$input_index|$relay_index|$mode|$cmd" /etc/relayctl/inputs.list > /tmp/inputs.list.temp
                                                                                mv /tmp/inputs.list.temp /etc/relayctl/inputs.list
                                                                                rm -f /tmp/inputs.list.temp
                                                                                response_json+="\"name\": \"$name\","
                                                                                response_json+="\"input_index\": \"$input_index\","
                                                                                response_json+="\"relay_index\": \"$relay_index\","
                                                                                response_json+="\"mode\": \"$mode\""
                                                                        fi
	                                                        else
	                                                                status="${status_code[422]}"
	                                                                response_json="{\"status\": \"422 Unprocessable Entity\", \"hint\": \"switch does not exist\""
	                                                        fi
							else
								status="${status_code[422]}"
                                                                response_json="{\"status\": \"422 Unprocessable Entity\", \"hint\": \"malformed json received\""
							fi
                                                else
                                                        status="${status_code[405]}"
                                                        response_json+="\"status\": \"405 Method Not Allowed\""
                                                fi
                                        ;;
                                        *)
                                                switches_list=""
                                                while read -r switches
                                                do
                                                        if [[ "$switches" != "#"* ]]
                                                        then
                                                                name=$(cut -d '|' -f 1 <<< "$switches")
                                                                input_index=$(cut -d '|' -f 2 <<< "$switches")
                                                                relay_index=$(cut -d '|' -f 3 <<< "$switches")
                                                                mode=$(cut -d '|' -f 4 <<< "$switches")
                                                                cmd=$(cut -d '|' -f 5 <<< "$switches")

                                                                switches_list+="\"$name\": { \"name\": \"$name\", \"input_index\": \"$input_index\", \"relay_index\": \"$relay_index\", \"mode\": \"$mode\", \"cmd\": \"$cmd\"},"
                                                        fi
                                                done < "/etc/relayctl/inputs.list"

                                                switches_list=$(echo "$switches_list" | sed 's/\(.*\),/\1 /')
                                                request "$switches_list"
                                        ;;
                                esac
                        ;;
                        health)
                                request "\"$path\": \"$(uptime)\""
                        ;;
                        *)
                                status="${status_code[404]}"
                                response_json+="\"status\": \"404 Not Found\""
                        ;;
                esac

        fi
}

function main() {
        auth
        if [ "$no_auth" = "false" ]
        then
                router
        fi
        response_json+="}"
        content "$status" "$response_json"
}

main

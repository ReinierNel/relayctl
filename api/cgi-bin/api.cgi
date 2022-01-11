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

function request() {

	case "$REQUEST_METHOD" in
		GET)
			status="${status_code[200]}"
                        response_json+="\"status\": \"200 OK\","
                        response_json+="\"message\": {$1}"
		;;
		POST)
			if [ "$CONTENT_LENGTH" -gt 0 ]
	                then
	                        data_in="$(cat)"
	                        status="${status_code[200]}"
	                        response_json+="\"status\": \"200 OK\","
	                        response_json+="\"message\": {$1}"
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
				if ! [[ "$slug" =~ '^[0-9]+$' ]]
				then
					if [ "$action" = "on" ] || [ "$action" = "off" ] || [ "$action" = "status" ]
					then
						request "\"$path\": \"$slug\", \"action\": \"$action\""
						/etc/relayctl/relayctl.sh -r="$slug" "$action"
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
				if [ "$slug" = "" ]
				then
					schedule_list="["
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

							schedule_list+="{\"name\": \"$name\", \"start_time\": \"$start_time\", \"end_time\": \"$end_time\", \"days\": \"$days\", \"$relay_index\": \"$relay_index\", \"action\": \"$action\"},"
				                fi
				        done < "/etc/relayctl/schedule.list"

					schedule_list+="]"
					schedule_list=$(echo "$schedule_list" | sed 's/\(.*\),/\1 /')
					request "\"$path\": $schedule_list, \"action\": \"list\""
				fi
			;;
			switches)
				if [ "$slug" = "" ]
                                then
                                        switches_list="["
                                        while read -r switches
                                        do
                                                if [[ "$switches" != "#"* ]]
                                                then
                                                        name=$(cut -d '|' -f 1 <<< "$switches")
                                                        input_index=$(cut -d '|' -f 2 <<< "$switches")
                                                        relay_index=$(cut -d '|' -f 3 <<< "$switches")
                                                        mode=$(cut -d '|' -f 4 <<< "$switches")
                                                        cmd=$(cut -d '|' -f 5 <<< "$switches")

                                                        switches_list+="{\"name\": \"$name\", \"input_index\": \"$input_index\", \"relay_index\": \"$relay_index\", \"mode\": \"$mode\", \"cmd\": \"$cmd\"},"
                                                fi
                                        done < "/etc/relayctl/inputs.list"

                                        switches_list+="]"
                                        switches_list=$(echo "$switches_list" | sed 's/\(.*\),/\1 /')
                                        request "\"$path\": $switches_list, \"action\": \"list\""
                                fi
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
	#request "\"testing\": \"true\", \"data\": {$data_in}"
	router
	response_json+="}"
	content "$status" "$response_json"
}

main

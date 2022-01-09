#!/bin/bash

function read_schedule_list() {
	output=("[")

	count_schedule_file=$(wc -l < "$1")
	josn_row_counter=0
	while read -r schedule
        do
		((josn_row_counter="$josn_row_counter"+1))

                if [[ "$schedule" != "#"* ]]
                then
                        name=$(cut -d '|' -f 1 <<< "$schedule")
                        start_time=$(cut -d '|' -f 2 <<< "$schedule")
                        end_time=$(cut -d '|' -f 3 <<< "$schedule")
                        days=($(cut -d '|' -f 4 <<< "$schedule"))
                        months=($(cut -d '|' -f 5 <<< "$schedule"))
                        relay_index=$(cut -d '|' -f 6 <<< "$schedule")

			count_day_array="${#days[@]}"
			counter_days=0
			day_json="["

			for day in "${days[@]}"
			do
				((counter_days="$counter_days"+1))
				if [ "$count_day_array" = "$counter_days" ]
				then
					day_json+="$day"
				else
					day_json+="$day,"
				fi
			done

			month_json+="]"

			count_month_array="${#months[@]}"
                        counter_months=0
                        month_json="["

                        for month in "${months[@]}"
                        do
                                ((counter_months="$counter_months"+1))
                                if [ "$count_month_array" = "$counter_months" ]
                                then
                                        month_json+="$month"
                                else
                                        month_json+="$month,"
                                fi
                        done

                        month_json+="]"

			if [ "$josn_row_counter" = "$count_schedule_file" ]
			then
				output+=("{\"name\": \"$name\", \"start_time\": \"$start_time\", \"end_time\": \"$end_time\", \"days\": $day_json, \"months\": $month_json, \"relay_index\": \"$relay_index\"}]")
			else
				output+=("{\"name\": \"$name\", \"start_time\": \"$start_time\", \"end_time\": \"$end_time\", \"days\": $day_json, \"months\": $month_json, \"relay_index\": \"$relay_index\"},")
			fi

                fi

        done < "$1"

cat << EOF
content-type: application/json

${output[@]}
EOF

}

function bad_request_output() {
cat << EOF
content-type: application/json

{
        "date": "$(date)",
        "error": "Bad Request"
}
EOF
}

if [ "$REQUEST_METHOD" = "GET" ]
then

        action=$(echo "$QUERY_STRING" | cut -d '=' -f 2)

	case "$action" in
		list)
			read_schedule_list "/etc/relayctl/schedule.list"
		;;
	esac


else
	bad_request_output
fi

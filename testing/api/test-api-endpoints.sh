#!/bin/bash
# this script is used to test other scripts and the API to validate that all is in order

API_KEY="$2"
PROTOCOL="https"
BASE_URL="$PROTOCOL://$1/api/v1"

echo "useing API KEY $API_KEY"

declare -a get_end_points=(
	"health/"
	"relays/"
	"relays/0/on"
	"relays/0/off"
	"relays/0/status"
	"relays/1/on"
        "relays/1/off"
        "relays/1/status"
	"relays/2/on"
        "relays/2/off"
        "relays/2/status"
	"relays/3/on"
        "relays/3/off"
        "relays/3/status"
	"relays/4/on"
        "relays/4/off"
        "relays/4/status"
	"relays/5/on"
        "relays/5/off"
        "relays/5/status"
	"schedules/"
	"switches/"
)

declare -a post_end_points=(
	"schedules/add"
	"switches/add"
)

declare -a delete_end_points=(
	"schedules/delete"
	"switches/delete"
)

## RUN TEST
### GET endpoints
for end_point in "${get_end_points[@]}"
do
	output=$(curl --insecure --silent --location --request GET "$BASE_URL/$end_point" \
	--header "Authorization: Bearer $API_KEY")

	status=$(echo $output | jq -r ."status")

	if [ "$status" = "200 OK" ]
	then
		echo "[PASS] [GET] [$output] $BASE_URL/$end_point"
	else
		echo "[FAIL] [GET] [$output] $BASE_URL/$end_point"
		failed_test="true"
	fi
done

## POST endpoints
for end_point in "${post_end_points[@]}"
do
	case "$end_point" in
		schedule*)
			payload="{\"name\": \"unit-test\", \"start_time\": \"00:00:00\", \"end_time\": \"00:10:00\", \"days\": \"1 2 3 4 5 6 7\", \"relay_index\": \"0\", \"action\": \"on\"}"
		;;
		switches*)
			payload="{\"name\": \"unit-test\", \"input_index\": \"0\", \"relay_index\": \"0\", \"mode\": \"on\"}"
		;;
	esac

        output=$(curl --insecure --silent --location --request POST "$BASE_URL/$end_point" \
        --header "Authorization: Bearer $API_KEY" --data-raw "$payload")

		status=$(echo $output | jq -r ."status")

        if [ "$status" = "200 OK" ]
        then
                echo "[PASS] [POST] [$output] $BASE_URL/$end_point"
        else
                echo "[FAIL] [POST] [$output] $BASE_URL/$end_point"
                failed_test="true"
        fi
done

## DELETE endpoints
for end_point in "${delete_end_points[@]}"
do
        case "$end_point" in
                schedule*)
                        payload="{\"name\": \"unit-test\", \"start_time\": \"00:00:00\", \"end_time\": \"00:10:00\", \"days\": \"1 2 3 4 5 6 7\", \"relay_index\": \"0\", \"action\": \"on\"}"
                ;;
                switches*)
                        payload="{\"name\": \"unit-test\", \"input_index\": \"0\", \"relay_index\": \"0\", \"mode\": \"on\"}"
                ;;
        esac

        output=$(curl --insecure --silent --location --request DELETE "$BASE_URL/$end_point" \
        --header "Authorization: Bearer $API_KEY" --data-raw "$payload")

		status=$(echo $output | jq -r ."status")

        if [ "$status" = "200 OK" ]
        then
                echo "[PASS] [DELETE] [$output] $BASE_URL/$end_point"
        else
                echo "[FAIL] [DELETE] [$output] $BASE_URL/$end_point"
                failed_test="true"
        fi
done

if [ -n "$failed_test" ]
then
	echo "some tests has failed"
	exit 1
else
	echo "all tests has passed"
	exit 0
fi

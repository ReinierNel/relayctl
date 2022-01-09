#!/bin/bash

if [ "$REQUEST_METHOD" = "GET" ]
then

	relay_value="$(echo $QUERY_STRING | cut -d '&' -f 1 | cut -d '=' -f 2)"
        relay_action="$(echo $QUERY_STRING | cut -d '&' -f 2 | cut -d '=' -f 2)"
        /etc/relayctl/relayctl.sh -r="$relay_value" "$relay_action"

	cat << EOF
content-type: application/json

{
        "date": "$(date)",
	"status": "OK",
        "relay": "$relay_value",
	"action": "$relay_action"
}
EOF

else
	cat << EOF
content-type: application/json

{
        "date": "$(date)",
        "status": "Bad Request"
}
EOF

fi

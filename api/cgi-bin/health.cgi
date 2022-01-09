#!/bin/bash

if [ "$REQUEST_METHOD" = "GET" ]
then

	cat << EOF
content-type: application/json

{
        "date": "$(date)",
	"status": "OK",
        "uptime": "$(uptime -p)"
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

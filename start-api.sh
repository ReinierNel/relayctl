#!/bin/bash

docker run \
    --device /dev/gpiomem \
    -e RELAYCTL_HTML_PATH="/relayctl/web" \
    -e RELAYCTL_DB_PATH="/relayctl/db/relayctl.db" \
    -v /etc/relayctl:/relayctl \
    -it \
    -p 8000:8000 \
    -d relayctl:1.0.0
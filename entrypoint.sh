#!/bin/bash

# Check ENV
if [ -z "$FR24KEY" ]; then
	echo >&2 'error: missing required FR24KEY environment variable'
	echo >&2 '  Did you forget to -e FR24KEY="..." ?'
	exit 1
fi

# Configure FlightRadar24
cat << EOF > /etc/fr24feed.ini
bs="no"
raw="no"
mlat="yes"
logmode="0"
receiver="beast-tcp"
host="flightfeeder:30005"
fr24key="${FR24KEY}"
EOF

/usr/bin/fr24feed

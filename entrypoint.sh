#!/bin/bash

set -e

if [ -z "$LAT" ]; then
	echo >&2 'error: missing required LAT environment variable'
	echo >&2 '  Did you forget to -e LAT="..." ?'
	exit 1
fi

if [ -z "$LON" ]; then
	echo >&2 'error: missing required LON environment variable'
	echo >&2 '  Did you forget to -e LON="..." ?'
	exit 1
fi

cat << EOF > /etc/default/dump1090-fa
ENABLED=yes
DECODER_OPTIONS="--lat $LAT --lon $LON --max-range 360"
NET_OPTIONS="--net --net-heartbeat 60 --net-ro-size 1000 --net-ro-interval 1 --net-http-port 0 --net-ri-port 0 --net-ro-port 30002 --net-sbs-port 30003 --net-bi-port 30004,30104"
JSON_OPTIONS="--json-location-accuracy 2"
RECEIVER_OPTIONS="--net-only --net-bo-port 0 --fix"
EOF

/usr/share/beast-splitter/start-beast-splitter --status-file %t/beast-splitter/status.json >/dev/null 2>&1 &
/usr/share/dump1090-fa/start-dump1090-fa --write-json %t/dump1090-fa --quiet >/dev/null 2>&1 &
/usr/sbin/lighttpd -D -f /etc/lighttpd/lighttpd.conf >/dev/null 2>&1 &

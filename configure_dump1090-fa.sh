#!/bin/sh
cat > /etc/default/dump1090-fa << EOF
DECODER_OPTIONS=" --lat $LAT --lon $LON --max-range 360"
NET_OPTIONS="--net --net-heartbeat 60 --net-ro-size 1000 --net-ro-interval 1 --net-http-port 0 --net-ri-port 0 --net-ro-port 30002 --net-sbs-port 30003 --net-bi-port 30004,30104"
JSON_OPTIONS="--json-location-accuracy 2"
RECEIVER_OPTIONS="--net-only --net-bo-port 0 --fix"
EOF
systemctl start dump1090-fa
lighty-enable-mod dump1090-fa
service lighttpd force-reload

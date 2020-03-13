#!/bin/sh
cat > /etc/default/beast-splitter << EOF
ENABLED="yes"
INPUT_OPTIONS="--serial /dev/beast --fixed-baud 1000000"
OUTPUT_OPTIONS="--listen 30005:R --connect localhost:30104:R"
EOF
cat > /etc/default/dump1090-fa << EOF
ENABLED=yes
DECODER_OPTIONS=" --lat $LAT --lon $LON --max-range 360"
NET_OPTIONS="--net --net-heartbeat 60 --net-ro-size 1000 --net-ro-interval 1 --net-http-port 0 --net-ri-port 0 --net-ro-port 30002 --net-sbs-port 30003 --net-bi-port 30004,30104"
JSON_OPTIONS="--json-location-accuracy 2"
RECEIVER_OPTIONS="--net-only --net-bo-port 0 --fix"
EOF
/usr/share/beast-splitter/start-beast-splitter --status-file %t/beast-splitter/status.json >/dev/null 2>&1 &
/usr/share/dump1090-fa/start-dump1090-fa --write-json %t/dump1090-fa --quiet >/dev/null 2>&1 &

#!/bin/sh
echo "meow  ALL=(ALL:ALL) ALL" >> /etc/sudoers
cat > /etc/default/beast-splitter << EOF
ENABLED=yes
INPUT_OPTIONS="--serial /dev/beast --fixed-baud 1000000 "
OUTPUT_OPTIONS="--listen 30005:R --connect localhost:30104:R"
EOF
cat > /etc/default/dump1090-fa << EOF
DECODER_OPTIONS=" --lat $LAT --lon $LON --max-range 360"
NET_OPTIONS="--net --net-heartbeat 60 --net-ro-size 1000 --net-ro-interval 1 --net-http-port 0 --net-ri-port 0 --net-ro-port 30002 --net-sbs-port 30003 --net-bi-port 30004,30104"
JSON_OPTIONS="--json-location-accuracy 2"
RECEIVER_OPTIONS="--net-only --net-bo-port 0 --fix"
EOF
service beast-splitter start
service dump1090-fa start
lighty-enable-mod dump1090-fa
service lighttpd force-reload
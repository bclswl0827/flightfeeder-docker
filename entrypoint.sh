#!/bin/bash

# Create directory for runtime
mkdir -p /run/beast-splitter /run/dump1090-fa

# Enable services
cat << EOF > /etc/default/beast-splitter
ENABLED="yes"
INPUT_OPTIONS="--serial /dev/ttyUSB0 --fixed-baud 1000000"
OUTPUT_OPTIONS="--listen 30005:R --connect localhost:30104:R"
EOF
cat << EOF > /etc/default/dump1090-fa
ENABLED=yes
DECODER_OPTIONS="--max-range 360"
NET_OPTIONS="--net --net-heartbeat 60 --net-ro-size 1000 --net-ro-interval 1 --net-http-port 0 --net-ri-port 0 --net-ro-port 30002 --net-sbs-port 30003 --net-bi-port 30004,30104"
JSON_OPTIONS="--json-location-accuracy 2"
RECEIVER_OPTIONS="--net-only --net-bo-port 0 --fix"
EOF
cat << EOF > /etc/ntp.conf
driftfile /var/lib/ntp/ntp.drift
server ntp.nict.jp iburst
server 127.127.28.2
fudge 127.127.28.2 refid GPS stratum 8
restrict -4 default kod notrap nomodify nopeer noquery
restrict -6 default kod notrap nomodify nopeer noquery
restrict 127.0.0.1
restrict ::1
EOF

/usr/sbin/lighttpd -f /etc/lighttpd/lighttpd.conf
/usr/sbin/gpsd -b /dev/ttyUSB1 -n
/usr/sbin/ntpd -p /var/run/ntpd.pid -g
/usr/share/beast-splitter/start-beast-splitter --status-file /run/beast-splitter/status.json &
/usr/share/dump1090-fa/start-dump1090-fa --write-json /run/dump1090-fa --quiet &

#!/bin/sh
cat > /etc/default/beast-splitter << EOF
ENABLED=yes
INPUT_OPTIONS="--serial /dev/beast --fixed-baud 1000000 "
OUTPUT_OPTIONS="--listen 30005:R --connect localhost:30104:R"
EOF
service beast-splitter start

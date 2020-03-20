#!/bin/sh
rm -rf /tmp/src /home/*
useradd -m meow -d /home/meow -s /bin/bash
echo "meow:$PASSWORD" | chpasswd
echo "meow  ALL=(ALL:ALL) ALL" >> /etc/sudoers
sed -i "s/<env1>/$LAT/g" /etc/default/dump1090-fa
sed -i "s/<env2>/$LON/g" /etc/default/dump1090-fa

/etc/init.d/lighttpd restart
/usr/share/beast-splitter/start-beast-splitter --status-file %t/beast-splitter/status.json >/dev/null 2>&1 &
/usr/share/dump1090-fa/start-dump1090-fa --write-json %t/dump1090-fa --quiet >/dev/null 2>&1 &

#!/bin/sh
rm -rf /tmp/src /home/*
useradd -m meow -d /home/meow -s /bin/bash
echo "meow:$PASSWORD" | chpasswd
echo "meow  ALL=(ALL:ALL) ALL" >> /etc/sudoers
sed -i "s/<env1>/$LAT/g" /etc/default/dump1090-fa
sed -i "s/<env2>/$LON/g" /etc/default/dump1090-fa

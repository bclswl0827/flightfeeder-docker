#!/bin/bash

sed -i "s/sleep 60//g" /etc/init.d/udev
sed -i 's/ENABLED="no"/ENABLED="yes"/g' /etc/default/beast-splitter
sed -i "s/ENABLED=no/ENABLED=yes/g" /etc/default/dump1090-fa

/etc/init.d/udev stop

if [ -z "$LAT" ]; then
	echo >&2 'error: missing required LAT environment variable'
	echo >&2 '  Did you forget to -e LAT="..." ?'
	exit 1
else
        sed -i "s/_LAT_/$LAT/g" /etc/default/dump1090-fa
fi

if [ -z "$LON" ]; then
	echo >&2 'error: missing required LON environment variable'
	echo >&2 '  Did you forget to -e LON="..." ?'
	exit 1
else
        sed -i "s/_LON_/$LON/g" /etc/default/dump1090-fa
fi

/etc/init.d/udev start
/usr/bin/sleep 2s

/etc/init.d/lighttpd restart
/usr/share/beast-splitter/start-beast-splitter --status-file /run/beast-splitter/status.json &
/usr/share/dump1090-fa/start-dump1090-fa --write-json /run/dump1090-fa --quiet

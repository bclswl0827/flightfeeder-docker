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

sed -i "s/<env1>/$LAT/g" /etc/default/dump1090-fa
sed -i "s/<env2>/$LON/g" /etc/default/dump1090-fa

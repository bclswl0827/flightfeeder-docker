FROM raspbian/jessie:latest

RUN echo -e "\n1.0.0.1 flightaware.a1.workers.dev\n" >> /etc/hosts \
 && echo "deb http://flightaware.a1.workers.dev/mirror/raspbian/raspbian/ jessie main contrib non-free firmware" > /etc/apt/sources.list \
 && echo "deb http://flightaware.a1.workers.dev/adsb/flightfeeder/files/packages jessie flightfeeder" > /etc/apt/sources.list.d/flightfeeder-jessie.list \
 && echo "deb http://flightaware.a1.workers.dev/mirror/raspberrypi/debian/ jessie main ui" > /etc/apt/sources.list.d/raspberrypi.org.list \
 && apt-key adv --keyserver keyserver.ubuntu.com --recv-keys B931BB28DE85F0DD \
 && apt-get update \
 && apt-get install -y beast-splitter dump1090-fa

RUN apt-get clean \
 && mkdir /run/beast-splitter /run/dump1090-fa \
 && echo -e 'ENABLED="yes"\nINPUT_OPTIONS="--serial /dev/beast --fixed-baud 1000000"\nOUTPUT_OPTIONS="--listen 30005:R --connect localhost:30104:R"\n' > /etc/default/beast-splitter \
 && echo -e 'ENABLED=yes\nDECODER_OPTIONS="--max-range 360"\nNET_OPTIONS="--net --net-heartbeat 60 --net-ro-size 1000 --net-ro-interval 1 --net-http-port 0 --net-ri-port 0 --net-ro-port 30002 --net-sbs-port 30003 --net-bi-port 30004,30104"\nJSON_OPTIONS="--json-location-accuracy 2"\nRECEIVER_OPTIONS="--net-only --net-bo-port 0 --fix"' > /etc/default/dump1090-fa

RUN /usr/share/beast-splitter/start-beast-splitter --status-file /run/beast-splitter/status.json >/dev/null 2>&1 &
RUN /usr/share/dump1090-fa/start-dump1090-fa --write-json /run/dump1090-fa --quiet >/dev/null 2>&1 &
RUN /usr/sbin/lighttpd -D -f /etc/lighttpd/lighttpd.conf >/dev/null 2>&1 &

CMD ["/sbin/init"]

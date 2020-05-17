FROM raspbian/jessie:latest
ARG DEBIAN_FRONTEND=noninteractive
STOPSIGNAL SIGRTMIN+3
CMD ["/sbin/init"]

RUN echo -e "\n1.0.0.1 flightaware.a1.workers.dev\n" >> /etc/hosts \
 && echo -e "deb http://flightaware.a1.workers.dev/mirror/raspbian/raspbian/ jessie main contrib non-free firmware" > /etc/apt/sources.list \
 && echo -e "deb http://flightaware.a1.workers.dev/adsb/flightfeeder/files/packages jessie flightfeeder" > /etc/apt/sources.list.d/flightfeeder-jessie.list \
 && echo -e "deb http://flightaware.a1.workers.dev/mirror/raspberrypi/debian/ jessie main ui" > /etc/apt/sources.list.d/raspberrypi.org.list \
 && apt-key adv --keyserver keyserver.ubuntu.com --recv-keys B931BB28DE85F0DD \
 && apt-get update \
 && apt-get install -y dump1090-fa beast-splitter gpsd-beast

ADD entrypoint.sh /entrypoint.sh
ENTRYPOINT ["sh", "/entrypoint.sh"]

CMD /usr/share/beast-splitter/start-beast-splitter --status-file %t/beast-splitter/status.json

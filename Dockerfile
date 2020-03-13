FROM arm32v7/debian:jessie-slim
ENV LAT=31.17 LON=108.40 PASSWORD=20020204ZY.
ARG DEBIAN_FRONTEND=noninteractive
RUN rm -rf /home/* \
 && useradd -m pi -d /home/pi -s /bin/bash \
 && echo "pi:$PASSWORD" | chpasswd
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys B931BB28DE85F0DD \
 && apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 9165938D90FDDD2E \
 && echo "deb http://flightaware.a1.workers.dev/mirror/raspbian/raspbian/ jessie main contrib non-free firmware" > /etc/apt/sources.list \
 && echo "deb http://flightaware.a1.workers.dev/adsb/flightfeeder/files/packages jessie flightfeeder" > /etc/apt/sources.list.d/flightfeeder-jessie.list
RUN apt-get update && apt-get -y install \
        openssh-server \
        sudo \
        beast-splitter \
        dump1090-fa
ADD configure.sh /configure.sh
RUN chmod +x /configure.sh
CMD /configure.sh
RUN 'bash -c "service ssh start \
 && service beast-splitter start \
 && service dump1090-fa start \
 && lighty-enable-mod dump1090-fa \
 && service lighttpd force-reload"
EXPOSE 22 80

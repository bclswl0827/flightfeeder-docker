FROM arm32v7/debian:jessie-slim as builder
ARG DEBIAN_FRONTEND=noninteractive

FROM arm32v7/debian:jessie-slim
ENV LAT=31.17 LON=108.40 PASSWORD=20020204ZY.
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys B931BB28DE85F0DD \
 && apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 9165938D90FDDD2E \
 && echo "deb http://flightaware.a1.workers.dev/mirror/raspbian/raspbian/ jessie main contrib non-free firmware" > /etc/apt/sources.list \
 && echo "deb http://flightaware.a1.workers.dev/adsb/flightfeeder/files/packages jessie flightfeeder" > /etc/apt/sources.list.d/flightfeeder-jessie.list
RUN apt-get update && apt-get -y install \
        openssh-server \
        sudo \
        beast-splitter \
        dump1090-fa
RUN rm -rf /home/* /etc/default/beast-splitter /etc/default/dump1090-fa \
 && useradd -m meow -d /home/meow -s /bin/bash \
 && echo "meow:$PASSWORD" | chpasswd \
 && echo "meow  ALL=(ALL:ALL) ALL" >> /etc/sudoers
ADD configure.sh /configure.sh
RUN chmod +x /configure.sh
RUN bash /configure.sh
RUN /usr/share/beast-splitter/start-beast-splitter --status-file %t/beast-splitter/status.json >/dev/null 2>&1 &
RUN /usr/share/dump1090-fa/start-dump1090-fa --write-json %t/dump1090-fa --quiet >/dev/null 2>&1 &
EXPOSE 22 80

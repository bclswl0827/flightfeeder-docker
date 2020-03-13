FROM raspbian/stretch as builder
ARG DEBIAN_FRONTEND=noninteractive
RUN sed -i "s/archive.raspbian.org/mirror.tuna.tsinghua.edu.cn/g" /etc/apt/sources.list \
 && apt-get update && apt-get install -y git build-essential debhelper librtlsdr-dev pkg-config dh-systemd libncurses5-dev libbladerf-dev libboost-system-dev libboost-program-options-dev libboost-regex-dev
RUN git clone https://github.com/bclswl0827/dump1090 /tmp/dump1090 \
 && git clone https://github.com/bclswl0827/beast-splitter /tmp/beast-splitter
RUN cd /tmp/dump1090 \
 && dpkg-buildpackage -b
RUN cd /tmp/beast-splitter
 && dpkg-buildpackage -b

FROM raspbian/stretch
ENV LAT=31.17 LON=108.40 PASSWORD=20020204ZY.
RUN apt-get update && apt-get -y install \
        openssh-server \
        sudo \
        beast-splitter \
        dump1090-fa
RUN rm -rf /home/* /etc/default/beast-splitter /etc/default/dump1090-fa \
 && useradd -m meow -d /home/meow -s /bin/bash \
 && echo "meow:$PASSWORD" | chpasswd \
 && echo "meow  ALL=(ALL:ALL) ALL" >> /etc/sudoers
RUN /usr/share/beast-splitter/start-beast-splitter --status-file %t/beast-splitter/status.json >/dev/null 2>&1 &
RUN /usr/share/dump1090-fa/start-dump1090-fa --write-json %t/dump1090-fa --quiet >/dev/null 2>&1 &
EXPOSE 22 80

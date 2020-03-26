FROM raspbian/jessie:latest as builder
ARG DEBIAN_FRONTEND=noninteractive

RUN sed -i "s/archive.raspbian.org/mirror.tuna.tsinghua.edu.cn\/raspbian/g" /etc/apt/sources.list \
 && sed -i "s/archive.raspberrypi.org/mirror.tuna.tsinghua.edu.cn/g" /etc/apt/sources.list \
 && apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 7638D0442B90D010

RUN apt-get update && apt-get install -y \
                              git \
                              cmake \
                              build-essential \
                              debhelper \
                              pkg-config \
                              dh-systemd \
                              libboost-system-dev \
                              libboost-program-options-dev \
                              libboost-regex-dev \
                              libusb-1.0-0-dev

RUN git clone https://gitee.com/bclswl0827/beast-splitter /tmp/src/beast-splitter \
 && git clone https://gitee.com/bclswl0827/dump1090 /tmp/src/dump1090
RUN cd /tmp/src/beast-splitter \
 && dpkg-buildpackage -b
RUN cd /tmp/src/dump1090 \
 && dpkg-buildpackage -b

FROM raspbian/jessie:latest
ARG DEBIAN_FRONTEND=noninteractive
ENV PASSWORD=20020204ZY container=docker
STOPSIGNAL SIGRTMIN+3
CMD ["/sbin/init"]

RUN mkdir /tmp/src \
 && sed -i "s/archive.raspbian.org/mirror.tuna.tsinghua.edu.cn\/raspbian/g" /etc/apt/sources.list \
 && sed -i "s/archive.raspberrypi.org/mirror.tuna.tsinghua.edu.cn/g" /etc/apt/sources.list \
 && apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 7638D0442B90D010
RUN apt-get update && apt-get install -y \
                              lighttpd \
                              libboost-regex-dev \
                              libboost-program-options-dev \
                              libboost-system-dev \
                              libusb-1.0-0-dev

COPY --from=builder /tmp/src/beast-splitter_3.8.0_armhf.deb /tmp/src/beast-splitter_3.8.0_armhf.deb
COPY --from=builder /tmp/src/dump1090-fa_3.8.0_armhf.deb /tmp/src/dump1090-fa_3.8.0_armhf.deb

RUN dpkg --install /tmp/src/beast-splitter_3.8.0_armhf.deb \
 && dpkg --install /tmp/src/dump1090-fa_3.8.0_armhf.deb

RUN rm -rf /tmp/src /home/* \
 && /etc/init.d/lighttpd restart
RUN /usr/share/beast-splitter/start-beast-splitter --status-file %t/beast-splitter/status.json >/dev/null 2>&1 &
RUN /usr/share/dump1090-fa/start-dump1090-fa --write-json %t/dump1090-fa --quiet >/dev/null 2>&1 &

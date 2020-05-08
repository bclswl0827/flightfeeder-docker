FROM raspbian/jessie:latest as builder
ARG DEBIAN_FRONTEND=noninteractive

RUN sed -i "s/archive.raspbian.org/mirror.tuna.tsinghua.edu.cn\/raspbian/g" /etc/apt/sources.list \
 && sed -i "s/archive.raspberrypi.org/mirror.tuna.tsinghua.edu.cn/g" /etc/apt/sources.list \
 && apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 7638D0442B90D010 \
 && apt-get update && apt-get install -y \
                              git \
                              cmake \
                              build-essential \
                              debhelper \
                              librtlsdr-dev \
                              pkg-config \
                              dh-systemd \
                              libncurses5-dev \
                              libboost-system-dev \
                              libboost-program-options-dev \
                              libboost-regex-dev \
                              libusb-1.0-0-dev \
                              doxygen \
                              libtecla-dev \
                              libtecla1 \
                              help2man \
                              pandoc \
 && git clone https://gitee.com/bclswl0827/bladeRF /tmp/src/bladeRF \
 && git clone https://gitee.com/bclswl0827/beast-splitter /tmp/src/beast-splitter \
 && git clone https://gitee.com/bclswl0827/dump1090 /tmp/src/dump1090 \
 && cd /tmp/src/bladeRF \
 && git checkout 2017.12-rc1 \
 && dpkg-buildpackage -b \
 && cd /tmp/src/beast-splitter \
 && dpkg-buildpackage -b \
 && dpkg --install /tmp/src/libbladerf1_2017.07_armhf.deb \
 && dpkg --install /tmp/src/libbladerf-dev_2017.07_armhf.deb \
 && dpkg --install /tmp/src/libbladerf-udev_2017.07_armhf.deb \
 && cd /tmp/src/dump1090 \
 && dpkg-buildpackage -b

FROM raspbian/jessie:latest
ARG DEBIAN_FRONTEND=noninteractive
STOPSIGNAL SIGRTMIN+3
CMD ["/sbin/init"]

RUN sed -i "s/archive.raspbian.org/mirror.tuna.tsinghua.edu.cn\/raspbian/g" /etc/apt/sources.list \
 && sed -i "s/archive.raspberrypi.org/mirror.tuna.tsinghua.edu.cn/g" /etc/apt/sources.list \
 && apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 7638D0442B90D010 \
 && mkdir /tmp/src \
 && apt-get update && apt-get install -y \
                              lighttpd \
                              libboost-regex-dev \
                              libboost-program-options-dev \
                              libboost-system-dev \
                              libusb-1.0-0-dev \
                              librtlsdr-dev

COPY --from=builder /tmp/src/libbladerf1_2017.07_armhf.deb /tmp/src/libbladerf1_2017.07_armhf.deb
COPY --from=builder /tmp/src/libbladerf-dev_2017.07_armhf.deb /tmp/src/libbladerf-dev_2017.07_armhf.deb
COPY --from=builder /tmp/src/libbladerf-udev_2017.07_armhf.deb /tmp/src/libbladerf-udev_2017.07_armhf.deb
COPY --from=builder /tmp/src/beast-splitter_3.8.0_armhf.deb /tmp/src/beast-splitter_3.8.0_armhf.deb
COPY --from=builder /tmp/src/dump1090-fa_3.8.0_armhf.deb /tmp/src/dump1090-fa_3.8.0_armhf.deb

RUN dpkg --install /tmp/src/libbladerf1_2017.07_armhf.deb \
 && dpkg --install /tmp/src/libbladerf-dev_2017.07_armhf.deb \
 && dpkg --install /tmp/src/libbladerf-udev_2017.07_armhf.deb \
 && dpkg --install /tmp/src/beast-splitter_3.8.0_armhf.deb \
 && dpkg --install /tmp/src/dump1090-fa_3.8.0_armhf.deb \
 && rm -rf /tmp/src /home/*

ADD entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["sh", "/entrypoint.sh"]

CMD /usr/share/beast-splitter/start-beast-splitter --status-file %t/beast-splitter/status.json && /etc/init.d/lighttpd restart

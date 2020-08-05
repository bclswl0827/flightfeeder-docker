FROM debian:buster as builder
ARG DEBIAN_FRONTEND=noninteractive

RUN sed -i "s/deb.debian.org/mirrors.bfsu.edu.cn/g" /etc/apt/sources.list \
 && sed -i "s/security.debian.org/mirrors.bfsu.edu.cn/g" /etc/apt/sources.list \
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
                              udev

RUN git clone https://gitee.com/bclswl0827/bladeRF /tmp/src/bladeRF \
 && git clone https://github.com/bclswl0827/beast-splitter /tmp/src/beast-splitter \
 && git clone https://github.com/bclswl0827/dump1090 /tmp/src/dump1090

RUN cd /tmp/src/bladeRF \
 && git checkout 2017.12-rc1 \
 && dpkg-buildpackage -b

RUN cd /tmp/src/beast-splitter \
 && dpkg-buildpackage -b

RUN dpkg --install /tmp/src/libbladerf1_2017.07_$(dpkg --print-architecture).deb \
 && dpkg --install /tmp/src/libbladerf-dev_2017.07_$(dpkg --print-architecture).deb \
 && dpkg --install /tmp/src/libbladerf-udev_2017.07_$(dpkg --print-architecture).deb \
 && cd /tmp/src/dump1090 \
 && dpkg-buildpackage -b

RUN rm -rf /tmp/src/bladeRF /tmp/src/beast-splitter /tmp/src/dump1090

FROM debian:buster

RUN sed -i "s/deb.debian.org/mirrors.bfsu.edu.cn/g" /etc/apt/sources.list \
 && sed -i "s/security.debian.org/mirrors.bfsu.edu.cn/g" /etc/apt/sources.list \
 && apt-get update && apt-get install -y \
                              lighttpd \
                              libncurses6 \
                              libboost-regex-dev \
                              libboost-program-options-dev \
                              libboost-system-dev \
                              libusb-1.0-0-dev \
                              librtlsdr-dev \
                              udev

COPY --from=builder /tmp/src /tmp/pkg

RUN dpkg --install /tmp/pkg/libbladerf1_2017.07_$(dpkg --print-architecture).deb \
 && dpkg --install /tmp/pkg/libbladerf-dev_2017.07_$(dpkg --print-architecture).deb \
 && dpkg --install /tmp/pkg/libbladerf-udev_2017.07_$(dpkg --print-architecture).deb \
 && dpkg --install /tmp/pkg/beast-splitter_3.8.0_$(dpkg --print-architecture).deb \
 && dpkg --install /tmp/pkg/dump1090-fa_3.8.0_$(dpkg --print-architecture).deb \
 && rm -rf /tmp/pkg \
 && apt-get clean \
 && mkdir /run/beast-splitter /run/dump1090-fa

ADD entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["sh", "-c", "/entrypoint.sh"]

FROM debian:buster-slim

ADD entrypoint.sh /opt/entrypoint.sh

RUN sed -e "s/security.debian.org/mirrors.bfsu.edu.cn/g" \
        -e "s/deb.debian.org/mirrors.bfsu.edu.cn/g" \
        -i /etc/apt/sources.list \
 && apt-get update \
 && apt-get install --no-install-recommends -y gnupg1 \
 && apt-key adv --keyserver keyserver.ubuntu.com --recv-keys B931BB28DE85F0DD \
 && echo "deb http://flightaware.a1.workers.dev/adsb/flightfeeder/files/packages buster flightfeeder" >> /etc/apt/sources.list \
 && apt-get update \
 && apt-get install --no-install-recommends -y \
                                            beast-splitter \
                                            dump1090-fa \
                                            gpsd \
                                            piaware \
 && chmod +x /opt/entrypoint.sh \
 && apt-get autoremove --purge -y gnupg1 \
 && rm -rf /var/lib/apt/lists/*
 
ENTRYPOINT ["sh", "-c", "/opt/entrypoint.sh"]

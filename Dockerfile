FROM raspbian/jessie:latest
ENV LAT=31.17 LON=108.40 PASSWORD=20020204ZY.
ARG DEBIAN_FRONTEND=noninteractive
RUN rm -rf /home/* \
 && useradd -m meow -d /home/meow -s /bin/bash \
 && echo "meow:$PASSWORD" | chpasswd
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys B931BB28DE85F0DD \
 && echo "deb http://flightaware.a1.workers.dev/mirror/raspbian/raspbian/ jessie main contrib non-free firmware" > /etc/apt/sources.list \
 && echo "deb http://flightaware.a1.workers.dev/adsb/flightfeeder/files/packages jessie flightfeeder" > /etc/apt/sources.list.d/flightfeeder-jessie.list
RUN apt-get update && apt-get install apt-utils -y
RUN apt-get --yes --force-yes -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confnew" install \
        openssh-server \
        sudo \
        beast-splitter \
        dump1090-fa
RUN systemctl start sshd
ADD configure_sudo.sh /tmp/configure_sudo.sh
ADD configure_beast.sh /tmp/configure_beast.sh
ADD configure_dump1090-fa.sh /tmp/configure_dump1090-fa.sh
RUN chmod +x /tmp/configure_sudo.sh \
        /tmp/configure_beast.sh \
        /tmp/configure_dump1090-fa.sh
CMD /tmp/configure_sudo.sh
CMD /tmp/configure_beast.sh
CMD /tmp/configure_dump1090-fa.sh
EXPOSE 22 80

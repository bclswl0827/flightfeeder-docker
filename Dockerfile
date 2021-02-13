FROM alpine:3.8

ADD entrypoint.sh /opt/entrypoint.sh
RUN sed -e "s/security.debian.org/mirrors.bfsu.edu.cn/g" \
        -e "s/deb.debian.org/mirrors.bfsu.edu.cn/g" \
        -i /etc/apt/sources.list \
    && apt-get update \
    && apt-get install --no-install-recommends -y curl upx-ucl \
    && DIR_TMP="$(mktemp -d)" \
    && curl -o ${DIR_TMP}/fr24feed.tgz http://repo.feed.flightradar24.com/rpi_binaries/fr24feed_1.0.25-1_armhf.tgz \
    && tar zxvf ${DIR_TMP}/fr24feed.tgz -C ${DIR_TMP} \
    && upx --lzma ${DIR_TMP}/fr24feed_armhf/fr24feed -o /usr/bin/fr24feed \
    && chmod +x /opt/entrypoint.sh \
    && apt-get autoremove --purge -y curl upx-ucl \
    && rm -rf /var/lib/apt/lists/* \
              ${DIR_TMP}

ENTRYPOINT ["sh", "-c", "/opt/entrypoint.sh"]

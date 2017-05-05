# For ubuntu, the latest tag points to the LTS version, since that is
# recommended for general use.
FROM python:3.6

# grab gosu for easy step-down from root
ENV GOSU_VERSION 1.10
RUN set -x \
	&& wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$(dpkg --print-architecture)" \
	&& wget -O /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$(dpkg --print-architecture).asc" \
	&& export GNUPGHOME="$(mktemp -d)" \
	&& gpg --keyserver  hkp://p80.pool.sks-keyservers.net:80 --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 \
	&& gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu \
	&& rm -r "$GNUPGHOME" /usr/local/bin/gosu.asc \
	&& chmod +x /usr/local/bin/gosu \
	&& gosu nobody true

# install youtube-dl-webui
ENV YOUTUBE_DL_WEBUI_SOURCE /usr/src/youtube_dl_webui
WORKDIR $YOUTUBE_DL_WEBUI_SOURCE

RUN buildDeps=' \
		unzip \
	' \
	&& set -x \
	&& pip install --no-cache-dir youtube-dl flask \
	&& apt-get update && apt-get install -y $buildDeps --no-install-recommends && rm -fr /var/lib/apt/lists/* \
	&& wget -O youtube-dl-webui.zip https://codeload.github.com/d0u9/youtube-dl-webui/zip/dev \
	&& unzip youtube-dl-webui.zip \
    && cd youtube-dl-webui*/ \
    && cp -r ./* $YOUTUBE_DL_WEBUI_SOURCE/ \
	&& cd .. && rm -rf youtube-dl-webui* \
	&& apt-get purge -y --auto-remove ca-certificates wget unzip \
	&& rm -fr /var/lib/apt/lists/*

COPY docker-entrypoint.sh /usr/local/bin
ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["python", "-m", "youtube_dl_webui"]

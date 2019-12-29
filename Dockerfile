# For ubuntu, the latest tag points to the LTS version, since that is
# recommended for general use.
FROM python:3.6-slim

# grab gosu for easy step-down from root
# gosu is in repos for Debian 9 and later
RUN set -x \
	&& buildDeps=' \
		unzip \
		ca-certificates \
		dirmngr \
		wget \
		xz-utils \
		gpg \
		gpg-agent \
		ffmpeg \
		gosu \
	' \
	&& apt-get update && apt-get install -y --no-install-recommends $buildDeps \
	&& gosu nobody true

# install youtube-dl-webui
ENV YOUTUBE_DL_WEBUI_SOURCE /usr/src/youtube_dl_webui
WORKDIR $YOUTUBE_DL_WEBUI_SOURCE

RUN : \
	&& pip install --upgrade --no-cache-dir pip youtube-dl flask \
	&& wget -O youtube-dl-webui.zip https://github.com/d0u9/youtube-dl-webui/archive/dev.zip \
	&& unzip youtube-dl-webui.zip \
	&& cd youtube-dl-webui*/ \
	&& cp -r ./* $YOUTUBE_DL_WEBUI_SOURCE/ \
	&& ln -s $YOUTUBE_DL_WEBUI_SOURCE/example_config.json /etc/youtube-dl-webui.json \
	&& cd .. && rm -rf youtube-dl-webui* \
	&& rm -fr /var/lib/apt/lists/*

COPY docker-entrypoint.sh /usr/local/bin
COPY default_config.json /config.json
ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["python", "-m", "youtube_dl_webui"]

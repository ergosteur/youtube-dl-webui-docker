### Currently broken, do not use this.


# youtube-dl-webui

2019-12-27 updates:
- youtube-dl, pip and flask will be updated from PyPI during build
- ffmpeg uses version from apt repo (Debian)

Visit [GitHub](https://github.com/ergosteur/youtube-dl-webui-docker) for more details.


## Install

1. From DockerHUB

        docker pull ergosteur/youtube-dl-webui


2. From DockerFile

        cd /tmp
        docker build -f </path/to/Dockerfile> -t youtube-dl-webui .

## Usage

1. Run container

        docker run -d \
            --name <container_name> \
            -e PGID=<gid> \
            -e PUID=<uid> \
            -e PORT=port \
            -e CONF_FILE=<config_file_in_container> \
            -p <host_port>:<port> \
            -v <host_download_dir>:<download_dir> \
            ergosteur/youtube-dl-webui


2. Automatically start container after booting (old method, now include docker-compose.yml)

    Create `/etc/systemd/system/docker-youtube_dl_webui.service`, and fill
    with the contents below:

        [Unit]
        Description=youtube-dl downloader
        Requires=docker.service
        After=docker.service

        [Service]
        Restart=always
        ExecStart=/usr/bin/docker start -a <container_name>
        ExecStop=/usr/bin/docker stop -t 2 <container_name>

        [Install]
        WantedBy=default.target

## Default configurations

All default settings can be found in [this json file](https://github.com/ergosteur/youtube-dl-webui-docker/blob/master/default_config.json).

- Files save to: `/srv/youtube_dl`;
- Database file location: `/srv/youtube_dl/youtube_dl_webui.db`;
- Log size: `10`;
- Listen address: `0.0.0.0`;
- Listen port: `5000`

---



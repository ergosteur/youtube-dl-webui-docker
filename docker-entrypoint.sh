#!/bin/bash
set -e

pgid=${PGID:-$(id -u nobody)}
puid=${PUID:-$(id -g nobody)}

if [[ "$*" == python*-m*youtube_dl_webui* ]]; then
    exec gosu $puid:$pgid "$@"
fi

exec "$@"

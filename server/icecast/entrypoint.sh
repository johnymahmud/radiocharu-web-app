#!/bin/sh
set -e
mkdir -p /var/log/icecast2 /tmp
chown -R icecast:icecast /var/log/icecast2 /tmp
echo '[Radio Charu Engine] Starting Icecast2 Media Server on port 8000...'
exec su-exec icecast icecast -c /etc/icecast2/icecast.xml

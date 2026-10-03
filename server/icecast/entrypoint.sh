#!/bin/sh
set -e

# Ensure logging and temporary directories exist with proper permissions for icecast user
mkdir -p /var/log/icecast2 /tmp
chown -R icecast:icecast /var/log/icecast2 /tmp

# Start Icecast in the foreground
echo "[Radio Charu Engine] Starting Icecast2 Media Server on port 8000..."
exec su-exec icecast icecast -c /etc/icecast2/icecast.xml
